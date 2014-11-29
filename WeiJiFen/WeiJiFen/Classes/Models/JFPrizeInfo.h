//
//  JFPrizeInfo.h
//  WeiJiFen
//
//  Created by liguangjun on 14-11-29.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFPrizeInfo : NSObject

@property (nonatomic, strong) NSString* tId;
@property (nonatomic, strong) NSString* subject;
@property (nonatomic, assign) int lastupdate;//时间
@property (nonatomic, assign) int credit;
@property (nonatomic, strong) NSString* attachment;//
@property (nonatomic, readonly) NSURL* avatarUrl;

@property(nonatomic, strong) NSDictionary* prizeInfoByDic;

@end
