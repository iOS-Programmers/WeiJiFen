//
//  JFCommentInfo.h
//  WeiJiFen
//
//  Created by liguangjun on 14-11-24.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFCommentInfo : NSObject

@property (nonatomic, strong) NSString* pId;
@property (nonatomic, strong) NSString* author;//发布者
@property (nonatomic, strong) NSString* authorId;
@property (nonatomic, strong) NSString* message;
@property (nonatomic, assign) int dateline;//发布时间

@property(nonatomic, strong) NSDictionary* commentInfoByDic;

@end
