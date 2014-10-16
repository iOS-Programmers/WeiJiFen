//
//  JFLocalDataManager.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-16.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "JFLocalDataManager.h"

static JFLocalDataManager *_shareInstance = nil;

@implementation JFLocalDataManager

+ (JFLocalDataManager*)shareInstance{
    @synchronized(self) {
        if (_shareInstance == nil) {
            _shareInstance = [[JFLocalDataManager alloc] init];
        }
    }
    return _shareInstance;
}

@end
