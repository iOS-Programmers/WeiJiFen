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
@property (nonatomic, strong) NSString* gender;
@property (nonatomic, strong) NSString* signature;
@property (nonatomic, strong) NSString* phone;
@property (nonatomic, strong) NSDate* birthdayDate;
@property (nonatomic, readonly) int age;
@property (nonatomic, readonly) NSURL* smallAvatarUrl;
@property (nonatomic, readonly) NSURL* originalAvatarUrl;

@property(nonatomic, strong) NSString* jsonString;
@property(nonatomic, strong) NSDictionary* userInfoByJsonDic;

@end
