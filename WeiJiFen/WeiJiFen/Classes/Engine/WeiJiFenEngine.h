//
//  WeiJiFenEngine.h
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFUserInfo.h"

#define LS_USERINFO_CHANGED_NOTIFICATION @"LS_USERINFO_CHANGED_NOTIFICATION"

typedef void(^onAppServiceBlock)(NSInteger tag, NSDictionary* jsonRet, NSError* err);

@interface WeiJiFenEngine : NSObject

@property (nonatomic,readonly) NSString* baseUrl;

@property(nonatomic, strong) NSString *confirm;
@property(nonatomic, strong) NSString* token;
@property(nonatomic, strong) NSString* userPassword;
@property(nonatomic, strong) NSString* uid;
@property(nonatomic, strong) JFUserInfo* userInfo;

+ (WeiJiFenEngine*)shareInstance;
+ (NSString*)getErrorMsgWithReponseDic:(NSDictionary*)dic;
+ (NSString*)getErrorCodeWithReponseDic:(NSDictionary*)dic;

- (NSString*)getCurrentAccoutDocDirectory;
- (void)saveAccount;
- (void)logout;

/**
 *  登录成功后，保存用户token，后面的所有接口请求用到
 *
 *  @param str token
 */
+ (void)saveUserToken:(NSString *)str;

+ (NSString *)userToken;

#pragma mark -Delegate
- (int)getConnectTag;
- (void)addOnAppServiceBlock:(onAppServiceBlock)block tag:(NSInteger)tag;
- (void)removeOnAppServiceBlockForTag:(NSInteger)tag;

#pragma mark - HttpRequest
//test
- (BOOL)querySysUserInfo:(NSString *)uid tag:(int)tag;
//注册接口
- (BOOL)registerUserInfo:(NSString *)userName mobile:(NSString *)mobile password:(NSString *)password confirm:(NSString *)confirm tag:(int)tag;
//登陆接口
- (BOOL)logInUserInfo:(NSString *)userName token:(NSString *)token password:(NSString *)password confirm:(NSString *)confirm tag:(int)tag;
//商品列表
- (BOOL)getCommodityListWithToken:(NSString *)token confirm:(NSString *)confirm type:(int)type page:(int)page pageSize:(int)pageSize tag:(int)tag;
//商品详情
- (BOOL)commodityShowWithToken:(NSString *)token confirm:(NSString *)confirm pId:(NSString *)pId tag:(int)tag;
//帮助列表 社区交流 社区晒单
- (BOOL)getHelpListWithToken:(NSString *)token confirm:(NSString *)confirm fId:(NSString *)fId page:(int)page pageSize:(int)pageSize tag:(int)tag;
//我的帖子
- (BOOL)getMyCommunityWithToken:(NSString *)token confirm:(NSString *)confirm page:(int)page pageSize:(int)pageSize tag:(int)tag;
//帖子详情
- (BOOL)getHelpInfoWithToken:(NSString *)token confirm:(NSString *)confirm fId:(NSString *)fId tId:(NSString *)tId tag:(int)tag;
//网站任务
- (BOOL)getWebTaskInfoWithToken:(NSString *)token confirm:(NSString *)confirm page:(int)page pageSize:(int)pageSize tag:(int)tag;

//好友列表
- (BOOL)getFriendListWithTag:(int)tag;

@end
