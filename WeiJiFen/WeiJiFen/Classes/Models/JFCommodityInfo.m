//
//  JFCommodityInfo.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-17.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "JFCommodityInfo.h"
#import "JSONKit.h"
#import "LSCommonUtils.h"

@implementation JFCommodityInfo

- (void)doSetCommodityInfoByDic:(NSDictionary*)dic {
    
    if ([dic objectForKey:@"name"]) {
        _name = [dic objectForKey:@"name"];
    }
    
    id objectForKey = [dic objectForKey:@"avatarUrl"];
    if (objectForKey && [objectForKey isKindOfClass:[NSString class]]) {
        _comAvatarUrl = [NSURL URLWithString:objectForKey];
    }
    
    if ([dic objectForKey:@"created_at"]) {
        NSDateFormatter *dateFormatter = [LSCommonUtils dateFormatterOFUS];
        _crateDate = [dateFormatter dateFromString:[dic objectForKey:@"created_at"]];
    }
    
    _comState = [[dic objectForKey:@"state"] intValue];
    
    if ([dic objectForKey:@"userName"]) {
        _userName = [dic objectForKey:@"userName"];
    }
}

- (void)setCommodityInfoByDic:(NSDictionary*)dic{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    _comId = [[dic objectForKey:@"id"] description];
    _userId = [[dic objectForKey:@"uid"] description];
    
    @try {
        [self doSetCommodityInfoByDic:dic];
    }
    @catch (NSException *exception) {
        NSLog(@"####LSFeedInfo setFeedInfoByDic exception:%@", exception);
    }
    
    _jsonString = [dic JSONString];
}

@end
