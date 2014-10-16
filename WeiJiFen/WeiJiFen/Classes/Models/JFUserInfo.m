//
//  JFUserInfo.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-16.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "JFUserInfo.h"
#import "JSONKit.h"

@interface JFUserInfo () {
    
}
@end

@implementation JFUserInfo

- (void)doSetUserInfoByJsonDic:(NSDictionary*)dic {
    
}
- (void)setUserInfoByJsonDic:(NSDictionary*)dic{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _userInfoByJsonDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    _uid = [[dic objectForKey:@"id"] description];
    
    @try {
        [self doSetUserInfoByJsonDic:dic];
    }
    @catch (NSException *exception) {
        NSLog(@"####LSUserInfo setUserInfoByJsonDic exception:%@", exception);
    }
    
    self.jsonString = [_userInfoByJsonDic JSONString];
}

@end
