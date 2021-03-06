//
//  JFUserInfo.h
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-16.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFUserInfo : NSObject

@property (nonatomic, strong) NSString* uid;
@property (nonatomic, strong) NSString* nickName;
@property (nonatomic, assign) int wjf;
@property (nonatomic, assign) int buyercredit;
@property (nonatomic, assign) int sellercredit;
@property (nonatomic, assign) int friends;

@property (nonatomic, strong) NSString* realname;
@property (nonatomic, strong) NSString* phone;
@property (nonatomic, strong) NSString* qqNumber;
@property (nonatomic, strong) NSString* taobao;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* address;

@property (nonatomic, readonly) NSURL* smallAvatarUrl;
@property (nonatomic, readonly) NSURL* originalAvatarUrl;

@property (nonatomic, strong) NSString* gender;//性别
@property (nonatomic, strong) NSString* signature;//签名
@property (nonatomic, strong) NSDate* birthdayDate;
@property (nonatomic, strong) NSString* birthdayString;
@property (nonatomic, readonly) int age;

@property(nonatomic, strong) NSString* jsonString;
@property(nonatomic, strong) NSDictionary* userInfoByJsonDic;

@property(nonatomic, strong) NSDictionary* otherUserInfoByJsonDic;

@end
