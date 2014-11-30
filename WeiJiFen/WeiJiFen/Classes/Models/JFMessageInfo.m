//
//  JFMessageInfo.m
//  WeiJiFen
//
//  Created by liguangjun on 14-11-28.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "JFMessageInfo.h"

@implementation JFMessageInfo

- (void)setMessageInfoByDic:(NSDictionary*)dic{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    @try {
        
        _userName = [[dic objectForKey:@"username"] description];
        _authorId = [[dic objectForKey:@"authorid"] description];
        _message = [[dic objectForKey:@"message"] description];
        id objectForKey = [dic objectForKey:@"avatar"];
        if (objectForKey && [objectForKey isKindOfClass:[NSString class]]) {
            _avatarUrl = [NSURL URLWithString:objectForKey];
        }
        _dateline = [[dic objectForKey:@"dateline"] intValue];
    }
    @catch (NSException *exception) {
        NSLog(@"####JFMessageInfo setMessageInfoByDic exception:%@", exception);
    }
    _messageInfoByDic = dic;
}

- (void)setSystemMsgInfoByDic:(NSDictionary*)dic{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    @try {
        
//        _userName = [[dic objectForKey:@"username"] description];
        _message = [[dic objectForKey:@"note"] description];
        id objectForKey = [dic objectForKey:@"avatar"];
        if (objectForKey && [objectForKey isKindOfClass:[NSString class]]) {
            _avatarUrl = [NSURL URLWithString:objectForKey];
        }
        _dateline = [[dic objectForKey:@"dateline"] intValue];
    }
    @catch (NSException *exception) {
        NSLog(@"####JFMessageInfo setSystemMsgInfoByDic exception:%@", exception);
    }
    _messageInfoByDic = dic;
}

- (void)setOnLineMsgInfoByDic:(NSDictionary*)dic{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    @try {
        
        _plid = [[dic objectForKey:@"plid"] description];
        _message = [[dic objectForKey:@"message"] description];
        _authorId = [[dic objectForKey:@"authorid"] description];
        _dateline = [[dic objectForKey:@"dateline"] intValue];
        
        id objectForKey = [dic objectForKey:@"avatar"];
        if (objectForKey && [objectForKey isKindOfClass:[NSString class]]) {
            _avatarUrl = [NSURL URLWithString:objectForKey];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"####JFMessageInfo setSystemMsgInfoByDic exception:%@", exception);
    }
    _messageInfoByDic = dic;
}

@end
