//
//  JFFriendList.h
//  WeiJiFen
//
//  Created by Jyh on 14/11/28.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFFriendList : NSObject

@property (nonatomic, strong) NSString* fuid;
@property (nonatomic, strong) NSString* fusername;
@property (nonatomic, strong) NSString* state;
@property (nonatomic, strong) NSString* avatar;//

@property(nonatomic, strong) NSDictionary* friendListInfoByDic;

@end
