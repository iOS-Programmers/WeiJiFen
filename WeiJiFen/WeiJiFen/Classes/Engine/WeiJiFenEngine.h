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

#pragma mark -Delegate
- (int)getConnectTag;
- (void)addOnAppServiceBlock:(onAppServiceBlock)block tag:(NSInteger)tag;
- (void)removeOnAppServiceBlockForTag:(NSInteger)tag;

#pragma mark - HttpRequest
//test
//- (BOOL)querySysUserInfo:(NSString *)uid tag:(int)tag;
//注册接口
- (BOOL)registerUserInfo:(NSString *)userName mobile:(NSString *)mobile password:(NSString *)password confirm:(NSString *)confirm tag:(int)tag;
//登陆接口
- (BOOL)logInUserInfo:(NSString *)userName token:(NSString *)token password:(NSString *)password confirm:(NSString *)confirm tag:(int)tag;

@end
