//
//  JFTaskInfo.h
//  WeiJiFen
//
//  Created by liguangjun on 14-11-27.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFTaskInfo : NSObject

@property (nonatomic, strong) NSString* taskId;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* taskDescription;
@property (nonatomic, strong) NSString* icon;//
@property (nonatomic, assign) int applicants;//人气
@property (nonatomic, assign) int bonus;//微积分

@property(nonatomic, strong) NSDictionary* taskInfoByDic;

@end
