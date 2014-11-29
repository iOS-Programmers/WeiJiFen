//
//  JFPrizeInfo.m
//  WeiJiFen
//
//  Created by liguangjun on 14-11-29.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "JFPrizeInfo.h"

@implementation JFPrizeInfo

- (void)setPrizeInfoByDic:(NSDictionary*)dic{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    @try {
        
        _tId = [[dic objectForKey:@"tid"] description];
        _subject = [[dic objectForKey:@"subject"] description];
        _attachment = [[dic objectForKey:@"attachment"] description];
        _lastupdate = [[dic objectForKey:@"lastupdate"] intValue];
        _credit = [[dic objectForKey:@"credit"] intValue];
    }
    @catch (NSException *exception) {
        NSLog(@"####JFPrizeInfo setPrizeInfoByDic exception:%@", exception);
    }
    _prizeInfoByDic = dic;
}

-(NSURL *)avatarUrl{
    if (_attachment == nil || [_attachment isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [[WeiJiFenEngine shareInstance] baseUrl],_attachment]];
}

@end
