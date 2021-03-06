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
#import "AppDelegate.h"
#import "NSString+MD5.h"
#import "LSAlertView.h"
#import "LoginViewController.h"

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
    
    _confirm = [[WJF_Confirm md5] md5];
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
    
    [self deleteAccount];
    _userInfo = [[JFUserInfo alloc] init];
    [self setUserInfo:_userInfo];
    //退出登录后token设置默认值
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"jf_token"];
}

-(NSString *)baseUrl{
    return BASE_URL;
}
-(NSString *)token{
    return [WeiJiFenEngine userToken];
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

-(NSString *)confirmWithUid{
    if (!_uid) {
        return _confirm;
    }
    return [[NSString stringWithFormat:@"%@%@",[WJF_Confirm md5],_uid] md5];
}

- (void)setUserInfo:(JFUserInfo *)userInfo{
    _userInfo = userInfo;
    _uid = _userInfo.uid;
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
- (void)deleteAccount{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[self getAccountsStoragePath]]) {
        [fileManager removeItemAtPath:[self getAccountsStoragePath] error:nil];
    }
}

- (BOOL)hasAccoutLoggedin{
    NSLog(@" _userPassword=%@, _uid=%@", _userPassword, _uid);
    return (_userPassword && _uid);
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

+ (NSInteger)getErrorCodeWithDic:(NSDictionary *)dic{
    
    return [[dic stringObjectForKey:@"error_no"] integerValue];
}
//验证失效重新登录
+ (BOOL)getErrorAuthWithDic:(NSDictionary *)dic{
    
    return [WeiJiFenEngine getErrorCodeWithDic:dic] == -130;
}

-(void)isNeedAnewAuth:(NSDictionary *)dic{
    if ([WeiJiFenEngine getErrorAuthWithDic:dic]) {
//        AppDelegate* appDelegate = (AppDelegate* )[[UIApplication sharedApplication] delegate];
//        LSAlertView *alertView = [[LSAlertView alloc] initWithTitle:@"温馨提示" message:@"对不起！您还未登录！！！" cancelButtonTitle:@"取消" cancelBlock:^{
//            
//        } okButtonTitle:@"登陆" okBlock:^{
//            
//            LoginViewController *vc = [[LoginViewController alloc] init];
//            [appDelegate.mainTabViewController.navigationController pushViewController:vc animated:YES];
//        }];
//        [alertView show];
    }
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
    
    NSDictionary *jsonRet = [responseString objectFromJSONString];
    
    [self isNeedAnewAuth:jsonRet];
    
    if ([jsonRet objectForKey:@"token"]) {
        [WeiJiFenEngine saveUserToken:[[jsonRet objectForKey:@"token"] description]];
    }
    NSMutableDictionary *mutJsonRet = [NSMutableDictionary dictionaryWithDictionary:jsonRet];
    if ([[jsonRet objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
        NSMutableArray *tmpArray = [NSMutableArray array];
        [mutJsonRet setObject:tmpArray forKey:@"data"];
    }
    
    NSLog(@"response tag:%d url=%@, string: %@", request.tag, [request url], responseString);
    dispatch_async(dispatch_get_main_queue(), ^(){
        
        onAppServiceBlock block = [self getonAppServiceBlockByTag:request.tag];
        if (block) {
            [self removeOnAppServiceBlockForTag:request.tag];
            block(request.tag, mutJsonRet, nil);
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
    if (_confirm){
        [params setObject:_confirm forKey:@"confirm"];
    }
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" postValue:NO tag:tag];
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
    if (_confirm){
        [params setObject:_confirm forKey:@"confirm"];
    }
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" postValue:NO tag:tag];
    return YES;
}

- (BOOL)getCommodityListWithToken:(NSString *)token confirm:(NSString *)confirm type:(int)type page:(int)page pageSize:(int)pageSize tag:(int)tag{
    
    NSString *url = [NSString stringWithFormat:@"%@/Home/Index/exchangeList", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
//    if (token){
//        [params setObject:token forKey:@"token"];
//    }
    if (_confirm){
        [params setObject:_confirm forKey:@"confirm"];
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
    
//    if (token){
//        [params setObject:token forKey:@"token"];
//    }
    if (_confirm){
        [params setObject:_confirm forKey:@"confirm"];
    }
    if (pId) {
        [params setObject:pId forKey:@"pid"];
    }
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" tag:tag];
    return YES;
}

- (BOOL)confirmBuyWithTId:(NSString *)tid pId:(NSString *)pid count:(int)count buyercontact:(NSString *)buyercontact buyername:(NSString *)buyername buyerzip:(NSString *)buyerzip buyerphone:(NSString *)buyerphone buyermobile:(NSString *)buyermobile buyermsg:(NSString *)buyermsg transportfee:(int)transportfee tag:(int)tag{
    
    NSString *url = [NSString stringWithFormat:@"%@/Home/Index/confirmTrade", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if (tid) {
        [params setObject:tid forKey:@"tid"];
    }
    if (pid) {
        [params setObject:pid forKey:@"pid"];
    }
    if (buyercontact) {
        [params setObject:buyercontact forKey:@"buyercontact"];
    }
    if (buyername) {
        [params setObject:buyername forKey:@"buyername"];
    }
    if (buyerphone) {
        [params setObject:buyerphone forKey:@"buyerphone"];
    }
    if (buyermobile) {
        [params setObject:buyermobile forKey:@"buyermobile"];
    }
    if (buyermsg) {
        [params setObject:buyermsg forKey:@"buyermsg"];
    }
    
    [params setObject:[NSNumber numberWithInt:count] forKey:@"number"];
    [params setObject:[NSNumber numberWithInt:transportfee] forKey:@"transportfee"];
    
    if ([WeiJiFenEngine userToken]) {
        [params setObject:[WeiJiFenEngine userToken] forKey:@"token"];
    }
    [params setObject:[self confirmWithUid] forKey:@"confirm"];
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" tag:tag];
    return YES;
}

- (BOOL)confirmPaymentWithOrderId:(NSString *)orderId message:(NSString *)message password:(NSString *)password tag:(int)tag{
    
    NSString *url = [NSString stringWithFormat:@"%@/Home/Index/confirmPayment", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if (orderId) {
        [params setObject:orderId forKey:@"orderid"];
    }
    if (message) {
        [params setObject:message forKey:@"message"];
    }
    if (password) {
        [params setObject:password forKey:@"password"];
    }
    
    if ([WeiJiFenEngine userToken]) {
        [params setObject:[WeiJiFenEngine userToken] forKey:@"token"];
    }
    [params setObject:[self confirmWithUid] forKey:@"confirm"];
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" tag:tag];
    return YES;
}

- (BOOL)cancelTradeWithOrderId:(NSString *)orderId message:(NSString *)message password:(NSString *)password tag:(int)tag{
    
    NSString *url = [NSString stringWithFormat:@"%@/Home/Index/cancelTrade", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if (orderId) {
        [params setObject:orderId forKey:@"orderid"];
    }
    if (message) {
        [params setObject:message forKey:@"message"];
    }
    if (password) {
        [params setObject:password forKey:@"password"];
    }
    
    if ([WeiJiFenEngine userToken]) {
        [params setObject:[WeiJiFenEngine userToken] forKey:@"token"];
    }
    [params setObject:[self confirmWithUid] forKey:@"confirm"];
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" tag:tag];
    return YES;
    
}

- (BOOL)getHelpListWithToken:(NSString *)token confirm:(NSString *)confirm fId:(NSString *)fId page:(int)page pageSize:(int)pageSize tag:(int)tag{
    
    NSString *url = [NSString stringWithFormat:@"%@/Home/Index/helpList", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
//    if (token){
//        [params setObject:token forKey:@"token"];
//    }
    if (_confirm){
        [params setObject:_confirm forKey:@"confirm"];
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
    
    if ([WeiJiFenEngine userToken]) {
        [params setObject:[WeiJiFenEngine userToken] forKey:@"token"];
    }
    [params setObject:[self confirmWithUid] forKey:@"confirm"];
    
//    [params setObject:[NSNumber numberWithInt:page] forKey:@"page"];
//    [params setObject:[NSNumber numberWithInt:pageSize] forKey:@"pagesize"];
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" tag:tag];
    return YES;
}

- (BOOL)getHelpInfoWithToken:(NSString *)token confirm:(NSString *)confirm fId:(NSString *)fId tId:(NSString *)tId tag:(int)tag{
    
    NSString *url = [NSString stringWithFormat:@"%@/Home/Index/helpInfo", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
//    if (token){
//        [params setObject:token forKey:@"token"];
//    }
    if (_confirm){
        [params setObject:_confirm forKey:@"confirm"];
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
    
    if ([WeiJiFenEngine userToken]) {
        [params setObject:[WeiJiFenEngine userToken] forKey:@"token"];
    }
    
    [params setObject:[self confirmWithUid] forKey:@"confirm"];
    
    [params setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [params setObject:[NSNumber numberWithInt:pageSize] forKey:@"pagesize"];
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" tag:tag];
    return YES;
}

#pragma mark - account
- (BOOL)getFriendListWithTag:(int)tag
{
    NSString *url = [NSString stringWithFormat:@"%@/Home/Index/myFriends", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if ([WeiJiFenEngine userToken]) {
        [params setObject:[WeiJiFenEngine userToken] forKey:@"token"];
    }
    
    [params setObject:[self confirmWithUid] forKey:@"confirm"];
    
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" tag:tag];
    return YES;
}

- (BOOL)sendMessageWithPlid:(NSString *)plid receiveuid:(NSString *)receiveuid message:(NSString *)message tag:(int)tag{
    
    NSString *url = [NSString stringWithFormat:@"%@/Home/Index/sendMessage", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if (plid) {
        [params setObject:plid forKey:@"plid"];
    }
    if (receiveuid) {
        [params setObject:receiveuid forKey:@"receiveuid"];
    }
    if (message) {
        [params setObject:message forKey:@"message"];
    }
    
    if ([WeiJiFenEngine userToken]) {
        [params setObject:[WeiJiFenEngine userToken] forKey:@"token"];
    }
    [params setObject:[self confirmWithUid] forKey:@"confirm"];
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" tag:tag];
    return YES;
    
}
- (BOOL)onlineMessageListWithReceiveUid:(NSString *)receiveuid tag:(int)tag{
    
    NSString *url = [NSString stringWithFormat:@"%@/Home/Index/onlineMessageList", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if (receiveuid) {
        [params setObject:receiveuid forKey:@"receiveuid"];
    }
    
    if ([WeiJiFenEngine userToken]) {
        [params setObject:[WeiJiFenEngine userToken] forKey:@"token"];
    }
    [params setObject:[self confirmWithUid] forKey:@"confirm"];
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" tag:tag];
    return YES;
    
}

//用户消息
- (BOOL)getUserMessagesWithToken:(NSString *)token confirm:(NSString *)confirm tag:(int)tag{
    
    NSString *url = [NSString stringWithFormat:@"%@/Home/Index/privatepm", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if ([WeiJiFenEngine userToken]) {
        [params setObject:[WeiJiFenEngine userToken] forKey:@"token"];
    }
    [params setObject:[self confirmWithUid] forKey:@"confirm"];
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" tag:tag];
    return YES;
    
}
//系统消息
- (BOOL)getSystemMessagesWithToken:(NSString *)token confirm:(NSString *)confirm page:(int)page pageSize:(int)pageSize tag:(int)tag{
    
    NSString *url = [NSString stringWithFormat:@"%@/Home/Index/systempm", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if ([WeiJiFenEngine userToken]) {
        [params setObject:[WeiJiFenEngine userToken] forKey:@"token"];
    }
    [params setObject:[self confirmWithUid] forKey:@"confirm"];
    
    [params setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [params setObject:[NSNumber numberWithInt:pageSize] forKey:@"pagesize"];
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" tag:tag];
    return YES;
}

- (BOOL)getPersonalInfoWithUserId:(NSString *)uid tag:(int)tag{
    
    NSString *url = [NSString stringWithFormat:@"%@/Home/Index/clickHead", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if ([WeiJiFenEngine userToken]) {
        [params setObject:[WeiJiFenEngine userToken] forKey:@"token"];
    }
    [params setObject:[self confirmWithUid] forKey:@"confirm"];
    if (uid) {
        [params setObject:uid forKey:@"sellid"];
    }
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" tag:tag];
    return YES;
    
}

- (BOOL)getMyProfileWithUserId:(NSString *)uid tag:(int)tag{
    NSString *url = [NSString stringWithFormat:@"%@/Home/Index/myProfile", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if ([WeiJiFenEngine userToken]) {
        [params setObject:[WeiJiFenEngine userToken] forKey:@"token"];
    }
    [params setObject:[self confirmWithUid] forKey:@"confirm"];
//    if (uid) {
//        [params setObject:uid forKey:@"uid"];
//    }
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" tag:tag];
    return YES;
    
}

//我的奖品
- (BOOL)getMyPrizeWithUserId:(NSString *)uid tag:(int)tag{
    
    NSString *url = [NSString stringWithFormat:@"%@/Home/Index/myPrize", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if ([WeiJiFenEngine userToken]) {
        [params setObject:[WeiJiFenEngine userToken] forKey:@"token"];
    }
    [params setObject:[self confirmWithUid] forKey:@"confirm"];
    //    if (uid) {
    //        [params setObject:uid forKey:@"uid"];
    //    }
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" tag:tag];
    return YES;
    
}

//排行榜
- (BOOL)getRankListWithPage:(int)page pageSize:(int)pageSize tag:(int)tag{
    
    NSString *url = [NSString stringWithFormat:@"%@/Home/Index/wjfList", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if ([WeiJiFenEngine userToken]) {
        [params setObject:[WeiJiFenEngine userToken] forKey:@"token"];
    }
    [params setObject:[self confirmWithUid] forKey:@"confirm"];
//    [params setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [params setObject:[NSNumber numberWithInt:pageSize] forKey:@"num"];
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" tag:tag];
    return YES;
    
}

- (BOOL)likeThreadWithTid:(NSString *)tid tag:(int)tag{
    
    NSString *url = [NSString stringWithFormat:@"%@/Home/Index/addRecommend", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if (tid) {
        [params setObject:tid forKey:@"tid"];
    }
    
    if ([WeiJiFenEngine userToken]) {
        [params setObject:[WeiJiFenEngine userToken] forKey:@"token"];
    }
    [params setObject:[self confirmWithUid] forKey:@"confirm"];
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" tag:tag];
    return YES;
    
}

- (BOOL)userReplyMessageWithPid:(NSString *)pid tid:(NSString *)tid fid:(NSString *)fid message:(NSString *)message tag:(int)tag{
    
    NSString *url = [NSString stringWithFormat:@"%@/Home/Index/addreply", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if (pid) {
       [params setObject:pid forKey:@"pid"];
    }
    if (tid) {
        [params setObject:tid forKey:@"tid"];
    }
    if (fid) {
        [params setObject:fid forKey:@"fid"];
    }
    if (message) {
        [params setObject:message forKey:@"message"];
    }
    
    if ([WeiJiFenEngine userToken]) {
        [params setObject:[WeiJiFenEngine userToken] forKey:@"token"];
    }
    [params setObject:[self confirmWithUid] forKey:@"confirm"];
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" tag:tag];
    return YES;
    
}
- (BOOL)publishNewThreadWithFid:(NSString *)fid title:(NSString *)title message:(NSString *)message tag:(int)tag{
    
    NSString *url = [NSString stringWithFormat:@"%@/Home/Index/addNewthread", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if (fid) {
        [params setObject:fid forKey:@"fid"];
    }
    if (title) {
        [params setObject:title forKey:@"title"];
    }
    if (message) {
        [params setObject:message forKey:@"message"];
    }
    
    if ([WeiJiFenEngine userToken]) {
        [params setObject:[WeiJiFenEngine userToken] forKey:@"token"];
    }
    [params setObject:[self confirmWithUid] forKey:@"confirm"];
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" tag:tag];
    return YES;
    
}
- (BOOL)doApplyWithTaskid:(NSString *)taskid tag:(int)tag{
    
    NSString *url = [NSString stringWithFormat:@"%@/Home/Index/doApply", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if (taskid) {
        [params setObject:taskid forKey:@"taskid"];
    }
    
    if ([WeiJiFenEngine userToken]) {
        [params setObject:[WeiJiFenEngine userToken] forKey:@"token"];
    }
    [params setObject:[self confirmWithUid] forKey:@"confirm"];
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" tag:tag];
    return YES;
    
}

- (BOOL)addFriendWithFuid:(NSString *)fuid gid:(NSString *)gid note:(NSString *)note tag:(int)tag{
    
    NSString *url = [NSString stringWithFormat:@"%@/Home/Index/makeFriend", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if (fuid) {
        [params setObject:fuid forKey:@"uid"];
    }
    if (gid) {
        [params setObject:gid forKey:@"gid"];
    }
    if (note) {
        [params setObject:note forKey:@"note"];
    }
    
    if ([WeiJiFenEngine userToken]) {
        [params setObject:[WeiJiFenEngine userToken] forKey:@"token"];
    }
    [params setObject:[self confirmWithUid] forKey:@"confirm"];
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"GET" tag:tag];
    return YES;
}

- (BOOL)avatarUploadWith:(NSString *)data tag:(int)tag{
    
    NSString *url = [NSString stringWithFormat:@"%@/Home/Index/myAvatarUpload", API_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if (data) {
        [params setObject:data forKey:@"$_FILES"];
    }
    
    if ([WeiJiFenEngine userToken]) {
        [params setObject:[WeiJiFenEngine userToken] forKey:@"token"];
    }
    [params setObject:[self confirmWithUid] forKey:@"confirm"];
    
    [self sendHttpRequestWithUrl:url params:params requestMethod:@"POST" postValue:YES tag:tag];
    return YES;
    
}
@end
