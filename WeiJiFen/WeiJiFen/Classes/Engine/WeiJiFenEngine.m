//
//  WeiJiFenEngine.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "WeiJiFenEngine.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "URLHelper.h"

#define CONNECT_TIMEOUT     20

static NSString* BASE_URL = @"http://img.hiwemeet.com";
static NSString* API_URL = @"http://test2.api.hiwemeet.com";

static WeiJiFenEngine* s_ShareInstance = nil;

@interface WeiJiFenEngine () {
    int _connectTag;
    NSMutableDictionary* _onAppServiceBlockMap;
    NSMutableDictionary* _shortRequestFailTagMap;  //短链调用本地出错匹配的表
}

@end

@implementation WeiJiFenEngine

+ (WeiJiFenEngine*)shareInstance{
    @synchronized(self) {
        if (s_ShareInstance == nil) {
            s_ShareInstance = [[WeiJiFenEngine alloc] init];
        }
    }
    return s_ShareInstance;
}

-(id)init{
    self = [super init];
    
    _connectTag = 100;
    _onAppServiceBlockMap = [[NSMutableDictionary alloc] init];
    _shortRequestFailTagMap = [[NSMutableDictionary alloc] init];
    
#ifdef DEBUG
    
#endif
    
    return self;
}
- (void)logout{
    [_onAppServiceBlockMap removeAllObjects];
}

-(NSString *)baseUrl{
    return BASE_URL;
}

+ (NSString*)getErrorMsgWithReponseDic:(NSDictionary*)dic{
    if (dic == nil) {
        return @"请检查网络连接是否正常";
    }
    if ([dic objectForKey:@"apistatus"] == nil) {
        return nil;
    }
    if ([[dic objectForKey:@"apistatus"] intValue] == 1){
        return nil;
    }
    NSString* error = [[dic objectForKey:@"result"] objectForKey:@"error_zh_CN"];
    if (!error) {
        error = [[dic objectForKey:@"result"] objectForKey:@"error"];
    }
    if (error == nil) {
        error = @"unknow error";
    }
    return error;
}
+ (NSString*)getErrorCodeWithReponseDic:(NSDictionary*)dic {
    
    return [[[dic dictionaryObjectForKey:@"result"] stringObjectForKey:@"error_code"] description];
}

#pragma mark - Delegate
- (int)getConnectTag{
    return _connectTag++;
}

- (void)addOnAppServiceBlock:(onAppServiceBlock)block tag:(NSInteger)tag{
    NSError* error = [_shortRequestFailTagMap objectForKey:[NSNumber numberWithInteger:tag]];
    if (error) {
        block(tag, nil, error);
        [_shortRequestFailTagMap removeObjectForKey:[NSNumber numberWithInteger:tag]];
        return;
    }
    
    [_onAppServiceBlockMap setObject:[block copy] forKey:[NSNumber numberWithInteger:tag]];
}
- (void)removeOnAppServiceBlockForTag:(NSInteger)tag{
    [_onAppServiceBlockMap removeObjectForKey:[NSNumber numberWithInteger:tag]];
}

- (onAppServiceBlock)getonAppServiceBlockByTag:(NSInteger)tag{
    return [_onAppServiceBlockMap objectForKey:[NSNumber numberWithInteger:tag]];
}

#pragma mark - ASIHTTPRequest Delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSString *responseString = nil;
    if ([request responseEncoding] == [request defaultResponseEncoding] && [request responseData]) {
        responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    } else {
        responseString = [request responseString];
    }
    
    NSLog(@"response tag:%ld url=%@, string: %@", request.tag, [request url], responseString);
    dispatch_async(dispatch_get_main_queue(), ^(){
        
        onAppServiceBlock block = [self getonAppServiceBlockByTag:request.tag];
        if (block) {
            [self removeOnAppServiceBlockForTag:request.tag];
            block(request.tag, [responseString objectFromJSONString], nil);
        }
    });
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    
    NSLog(@"error response string: %@, code=%d", [request responseString],[request responseStatusCode]);
    
    NSLog(@"_request error!!!,url:%@ Reason:%@, errordetail:%@"
          , [[request url] absoluteString], [error localizedFailureReason], [error localizedDescription]);
    dispatch_async(dispatch_get_main_queue(), ^(){
        onAppServiceBlock block = [self getonAppServiceBlockByTag:request.tag];
        if (block) {
            [self removeOnAppServiceBlockForTag:request.tag];
            block(request.tag, nil, error);
        }
    });
}

- (void)sendHttpRequestWithUrl:(NSString*)url params:(NSDictionary*)params requestMethod:(NSString*)requestMethod  tag:(int)tag {
    return [self sendHttpRequestWithUrl:url params:params requestMethod:requestMethod postValue:NO tag:tag];
}

- (void)sendHttpRequestWithUrl:(NSString*)url params:(NSDictionary*)params requestMethod:(NSString*)requestMethod postValue:(BOOL)postValue tag:(int)tag {
    [self sendHttpRequestWithUrl:url params:params requestMethod:requestMethod postValue:postValue timeout:CONNECT_TIMEOUT tag:tag];
}

- (void)sendHttpRequestWithUrl:(NSString*)url params:(NSDictionary*)params requestMethod:(NSString*)requestMethod postValue:(BOOL)postValue timeout:(NSTimeInterval) timeout tag:(int)tag {
    ASIHTTPRequest* request = nil;
    if (postValue) {
        NSURL *fullurl = [NSURL URLWithString:[URLHelper getURL:url queryParameters:nil]];
        ASIFormDataRequest *dataRequest = [ASIFormDataRequest requestWithURL:fullurl];
        for (NSString* key in [params allKeys]) {
            [dataRequest setPostValue:[params objectForKey:key] forKey:key];
        }
        request = dataRequest;
    } else {
        request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[URLHelper getURL:url queryParameters:params]]];
    }
    [self addCommonHeaderToRequest:request];
    
    if (requestMethod) {
        request.requestMethod = requestMethod;
    }
    
    request.timeOutSeconds = timeout;
    request.tag = tag;
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    request.useCookiePersistence = NO;
    [request startAsynchronous];
}

- (void)addCommonHeaderToRequest:(ASIHTTPRequest*)request {
    
    NSDictionary *commonHeaders = [self getHttpRequestCommonHeader];
    if (commonHeaders) {
        for (NSString *key in [commonHeaders allKeys]) {
            [request addRequestHeader:key value:[commonHeaders valueForKey:key]];
        }
    }
    
    NSDictionary *headers = [self getShortReqPageHeaders];
    if (headers) {
        for (NSString *key in [headers allKeys]) {
            [request addRequestHeader:key value:[headers valueForKey:key]];
        }
    }
}

- (NSDictionary *)getHttpRequestCommonHeader {
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    
//    if ([_weChatInstance getXWVersion]) {
//        [headers setObject:[_weChatInstance getXWVersion] forKey:@"X-WVersion"];
//    }
//    if ([_weChatInstance wchatGetMAuth].length > 0) {
//        [headers setObject:[_weChatInstance wchatGetMAuth] forKey:@"Authorization"];
//    }
//    [headers setObject:kClientId forKey:@"X-Client-ID"];
    return headers;
}

- (NSDictionary *)getShortReqPageHeaders {
    NSString *curPage = nil;
    NSString *prePage = nil;
    
//    [LSUIUtils getCurrentPage:&curPage prePage:&prePage];
    NSMutableDictionary *headers = nil;
    if (curPage || prePage) {
        headers = [[NSMutableDictionary alloc] init];
        if (curPage) {
            [headers setObject:curPage forKey:@"X-Page"];
        }
        if (prePage) {
            [headers setObject:prePage forKey:@"X-Referer"];
        }
    }
    return headers;
}

- (BOOL)querySysUserInfo:(NSString *)uid tag:(int)tag {
    
    NSString *url = [NSString stringWithFormat:@"%@/common/system_user/show", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" postValue:YES tag:tag];
    return YES;
}

@end
