//
//  JFTopicInfo.h
//  WeiJiFen
//
//  Created by liguangjun on 14-11-24.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFTopicInfo : NSObject

@property (nonatomic, strong) NSString* tId;
@property (nonatomic, strong) NSString* fId;
@property (nonatomic, strong) NSString* author;//发布者
@property (nonatomic, strong) NSString* authorId;
@property (nonatomic, strong) NSString* subject;//标题
@property (nonatomic, strong) NSString* content;//内容
@property (nonatomic, strong) NSString* price;
@property (nonatomic, assign) int dateline;//发布时间
@property (nonatomic, assign) int views;//查看数
@property (nonatomic, assign) int replies;//回复数
@property (nonatomic, readonly) NSURL* userAvatarUrl;

@property (nonatomic, strong) NSMutableArray *comments;

@property(nonatomic, strong) NSString* jsonString;

- (void)setTopicInfoByDic:(NSDictionary*)dic;

@end
