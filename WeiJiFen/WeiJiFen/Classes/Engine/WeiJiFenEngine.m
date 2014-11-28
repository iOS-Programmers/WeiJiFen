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
#import "NSDictionary+objectForKey.h"
#import "PathHelper.h"

#define CONNECT_TIMEOUT     20

static NSString* BASE_URL = @"http://www.wjf123.cn/data/attachment/forum/";
static NSString* API_URL = @"http://www.wjf123.cn/wjfapi/index.php";//http://test2.api.hiwemeet.com
//static NSString* API_URL = @"http://test2.api.hiwemeet.com";

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
    
    _confirm = WJF_Confirm;
    _token = nil;
    _userPassword = nil;
    _uid = nil;
    [self loadAccount];
    _userInfo = [[JFUserInfo alloc] init];
    _userInfo.uid = _uid;
    [self loadUserInfo];
    
#ifdef DEBUG
    
#endif
    
    return self;
}
- (void)logout{
    [_onAppServiceBlockMap removeAllObjects];
    
    [self saveAccount];
}

-(NSString *)baseUrl{
    return BASE_URL;
}

#pragma mark - userInfo

/**
 *  登录成功后，保存用户token，后面的所有接口请求用到
 *
 *  @param str token
 */
+ (void)saveUserToken:(NSString *)str
{
    if (!FBIsEmpty(str))
    {
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"jf_token"];
    }
}

+ (NSString *)userToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"jf_token"];
}


- (void)setUserInfo:(JFUserInfo *)userInfo{
    _userInfo = userInfo;
    [[NSNotificationCenter defaultCenter] postNotificationName:LS_USERINFO_CHANGED_NOTIFICATION object:self];
    [self saveUserInfo];
}

- (void)loadUserInfo{
    if (!_uid) {
        return;
    }
    NSString* path = [[self getCurrentAccoutDocDirectory] stringByAppendingPathComponent:@"myUserInfo.xml"];
    NSString* jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary* userDic = [jsonString objectFromJSONString];
    if (userDic) {
        if (_userInfo == nil) {
            _userInfo = [[JFUserInfo alloc] init];
        }
        [_userInfo setUserInfoByJsonDic:userDic];
    }
    
}

- (void)saveUserInfo {
    if (!_uid) {
        return;
    }
    
    if (!self.userInfo.jsonString) {
        return;
    }
    NSString* path = [[self getCurrentAccoutDocDirectory] stringByAppendingPathComponent:@"myUserInfo.xml"];
    [self.userInfo.jsonString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
- (NSString*)getCurrentAccoutDocDirectory{
    return [PathHelper documentDirectoryPathWithName:[NSString stringWithFormat:@"accounts/%@", _uid]];
}

- (NSString *)getAccountsStoragePath{
    NSString *filePath = [[PathHelper documentDirectoryPathWithName:nil] stringByAppendingPathComponent:@"account"];
    return filePath;
}

- (void)loadAccount{
    NSDictionary * accountDic = [NSDictionary dictionaryWithContentsOfFile:[self getAccountsStoragePath]];
    _token = [accountDic objectForKey:@"token"];
    _userPassword = [accountDic objectForKey:@"accountPwd"];
    _uid = [accountDic objectForKey:@"uid"];
}
- (void)saveAccount{
    NSMutableDictionary* accountDic= [NSMutableDictionary dictionaryWithCapacity:2];
    if(_token)
        [accountDic setValue:_token forKey:@"token"];
    if(_userPassword)
        [accountDic setValue:_userPassword forKey:@"accountPwd"];
    if (_uid) {
        [accountDic setValue:_uid forKey:@"uid"];
    }
    
    [accountDic writeToFile:[self getAccountsStoragePath] atomically:NO];
}

#pragma mark - 网络错误处理
+ (NSString*)getErrorMsgWithReponseDic:(NSDictionary*)dic{
    if (dic == nil) {
        return @"请检查网络连接是否正常";
    }
    if ([dic objectForKey:@"error_no"] == nil) {
        return nil;
    }
    if ([[dic objectForKey:@"error_no"] integerValue] == 0){
        return nil;
    }
    NSString* error = [dic objectForKey:@"error_info"];
    if (!error) {
        error = [dic objectForKey:@"error_no"];
    }
    if (error == nil) {
        error = @"unknow error";
    }
    return error;
}
+ (NSString*)getErrorCodeWithReponseDic:(NSDictionary*)dic {
    
    return [[dic stringObjectForKey:@"error_info"] description];
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
    
    NSLog(@"response tag:%d url=%@, string: %@", request.tag, [request url], responseString);
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
//    [self addCommonHeaderToRequest:request];
    
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

#pragma mark - HttpRequest
//test
- (BOOL)querySysUserInfo:(NSString *)uid tag:(int)tag{
    
    NSString *url = [NSString stringWithFormat:@"%@/common/system_user/show", @"http://test2.api.hiwemeet.com"];
    NSMutableDictionary *pdic = [NSMutableDictionary dictionaryWithCapacity:1];
    [pdic setObject:uid forKey:@"id"];
   	ASIHTTPRequest* request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[URLHelper getURL:url queryParameters:pdic]]];
    [self addCommonHeaderToRequest:request];
    request.requestMethod = @"GET";
    request.timeOutSeconds = CONNECT_TIMEOUT;
    request.tag = tag;
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    request.useCookiePersistence = NO;
    [request startAsynchronous];
    return YES;
}

- (BOOL)registerUserInfo:(NSString *)userName mobile:(NSString *)mobile password:(NSString *)password confirm:(NSString *)confirm tag:(int)tag {
    
    NSString *url = [NSString stringWithFormat:@"%@/Index/userRegister", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    if (userName){
        [params setObject:userName forKey:@"username"];
    }
    if (mobile){
        [params setObject:mobile forKey:@"mobile"];
    }
    if (password){
        [params setObject:password forKey:@"password"];
    }
    if (confirm){
        [params setObject:confirm forKey:@"confirm"];//@"79EF44D011ACB123CF6A918610EFC053"
    }
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"POST" postValue:YES tag:tag];
    return YES;
}

- (BOOL)logInUserInfo:(NSString *)userName token:(NSString *)token password:(NSString *)password confirm:(NSString *)confirm tag:(int)tag{
    
    NSString *url = [NSString stringWithFormat:@"%@/Index/userLogin", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    if (userName){
        [params setObject:userName forKey:@"username"];
    }
    if (token){
        [params setObject:token forKey:@"token"];
    }
    if (password){
        [params setObject:password forKey:@"password"];
    }
    if (confirm){
        [params setObject:confirm forKey:@"confirm"];
    }
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" postValue:NO tag:tag];
    return YES;
}

- (BOOL)getCommodityListWithToken:(NSString *)token confirm:(NSString *)confirm type:(int)type page:(int)page pageSize:(int)pageSize tag:(int)tag{
    
    NSString *url = [NSString stringWithFormat:@"%@/Home/Index/exchangeList", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if (token){
        [params setObject:token forKey:@"token"];
    }
    if (confirm){
        [params setObject:confirm forKey:@"confirm"];
    }
    [params setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    [params setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [params setObject:[NSNumber numberWithInt:pageSize] forKey:@"pagesize"];
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"POST" postValue:NO tag:tag];
    return YES;
}

- (BOOL)commodityShowWithToken:(NSString *)token confirm:(NSString *)confirm pId:(NSString *)pId tag:(int)tag{
    
    NSString *url = [NSString stringWithFormat:@"%@/Home/Index/exchangeInfo", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if (token){
        [params setObject:token forKey:@"token"];
    }
    if (confirm){
        [params setObject:confirm forKey:@"confirm"];
    }
    if (pId) {
        [params setObject:pId forKey:@"pid"];
    }
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" tag:tag];
    return YES;
}

- (BOOL)getHelpListWithToken:(NSString *)token confirm:(NSString *)confirm fId:(NSString *)fId page:(int)page pageSize:(int)pageSize tag:(int)tag{
    
    NSString *url = [NSString stringWithFormat:@"%@/Home/Index/helpList", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if (token){
        [params setObject:token forKey:@"token"];
    }
    if (confirm){
        [params setObject:confirm forKey:@"confirm"];
    }
    if (fId) {
        [params setObject:fId forKey:@"fid"];
    }
    [params setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [params setObject:[NSNumber numberWithInt:pageSize] forKey:@"pagesize"];
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" tag:tag];
    return YES;
}

- (BOOL)getMyCommunityWithToken:(NSString *)token confirm:(NSString *)confirm page:(int)page pageSize:(int)pageSize tag:(int)tag{
    
    NSString *url = [NSString stringWithFormat:@"%@/Home/Index/myCommunityTies", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if (token){
        [params setObject:token forKey:@"token"];
    }
    if (confirm){
        [params setObject:confirm forKey:@"confirm"];
    }
//    [params setObject:[NSNumber numberWithInt:page] forKey:@"page"];
//    [params setObject:[NSNumber numberWithInt:pageSize] forKey:@"pagesize"];
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" tag:tag];
    return YES;
}

- (BOOL)getHelpInfoWithToken:(NSString *)token confirm:(NSString *)confirm fId:(NSString *)fId tId:(NSString *)tId tag:(int)tag{
    
    NSString *url = [NSString stringWithFormat:@"%@/Home/Index/helpInfo", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if (token){
        [params setObject:token forKey:@"token"];
    }
    if (confirm){
        [params setObject:confirm forKey:@"confirm"];
    }
    if (fId) {
        [params setObject:fId forKey:@"fid"];
    }
    if (tId) {
        [params setObject:tId forKey:@"tid"];
    }
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" tag:tag];
    return YES;
}

- (BOOL)getWebTaskInfoWithToken:(NSString *)token confirm:(NSString *)confirm page:(int)page pageSize:(int)pageSize tag:(int)tag{
    
    NSString *url = [NSString stringWithFormat:@"%@/Home/Index/webtask", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if (token){
        [params setObject:token forKey:@"token"];
    }
    if (confirm){
        [params setObject:confirm forKey:@"confirm"];
    }
    [params setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [params setObject:[NSNumber numberWithInt:pageSize] forKey:@"pagesize"];
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" tag:tag];
    return YES;
}

- (BOOL)getFriendListWithTag:(int)tag
{
    NSString *url = [NSString stringWithFormat:@"%@/Home/Index/myFriends", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [params setObject:[WeiJiFenEngine userToken] forKey:@"token"];

    [params setObject:WJF_Confirm forKey:@"confirm"];

    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" tag:tag];
    return YES;

}

@end
