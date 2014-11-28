//
//  JFFriendList.m
//  WeiJiFen
//
//  Created by Jyh on 14/11/28.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "JFFriendList.h"

@implementation JFFriendList

- (void)setFriendListInfoByDic:(NSDictionary*)dic{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    @try {
        _fuid = [[dic objectForKey:@"fuid"] description];
        _fusername = [[dic objectForKey:@"fusername"] description];
        _state = [[dic objectForKey:@"state"] description];
        _avatar = [[dic objectForKey:@"message"] description];
    }
    @catch (NSException *exception) {
        NSLog(@"####JFFriendList setFriendListInfoByDic exception:%@", exception);
    }
    _friendListInfoByDic = dic;
}

@end
