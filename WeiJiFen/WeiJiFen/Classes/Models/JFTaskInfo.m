//
//  JFTaskInfo.m
//  WeiJiFen
//
//  Created by liguangjun on 14-11-27.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "JFTaskInfo.h"

@implementation JFTaskInfo

- (void)setTaskInfoByDic:(NSDictionary*)dic{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    @try {
        _taskId = [[dic objectForKey:@"taskid"] description];
        _name = [[dic objectForKey:@"name"] description];
        _taskDescription = [[dic objectForKey:@"description"] description];
        _icon = [[dic objectForKey:@"icon"] description];
        _applicants = [[dic objectForKey:@"applicants"] intValue];
        _bonus = [[dic objectForKey:@"bonus"] intValue];
    }
    @catch (NSException *exception) {
        NSLog(@"####JFTaskInfo setTaskInfoByDic exception:%@", exception);
    }
    _taskInfoByDic = dic;
}

@end
