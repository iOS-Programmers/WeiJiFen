//
//  JFMessageInfo.h
//  WeiJiFen
//
//  Created by liguangjun on 14-11-28.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFMessageInfo : NSObject

@property (nonatomic, strong) NSString* authorId;
@property (nonatomic, strong) NSString* userName;//发送者
@property (nonatomic, strong) NSURL* avatarUrl;
@property (nonatomic, strong) NSString* message;
@property (nonatomic, assign) int dateline;//发布时间

@property (nonatomic, strong) NSDictionary* messageInfoByDic;

//系统消息
@property (nonatomic, strong) NSDictionary* systemMsgInfoByDic;

//在线消息
@property (nonatomic, strong) NSString* plid;//消息id
@property (nonatomic, assign) BOOL isSender;//是否发送者
@property (nonatomic, strong) NSDictionary* onLineMsgInfoByDic;

@end
