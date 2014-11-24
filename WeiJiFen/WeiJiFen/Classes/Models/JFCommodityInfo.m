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
#import "WeiJiFenEngine.h"

@implementation JFCommodityInfo

- (void)doSetCommodityInfoByDic:(NSDictionary*)dic {
    
    id objectForKey = [dic objectForKey:@"subject"];
    if (objectForKey) {
        _name = objectForKey;
    }
    
    objectForKey = [dic objectForKey:@"attachment"];
    if (objectForKey) {
        _attachment = objectForKey;
    }
    
    objectForKey = [dic objectForKey:@"lastupdate"];
    if (objectForKey) {
        _crateDate = [objectForKey intValue];
    }
    
    _comState = [[dic objectForKey:@"state"] intValue];
    _amount = [[dic objectForKey:@"amount"] intValue];
    _sellerCredit = [[dic objectForKey:@"sellercredit"] intValue];
    
    objectForKey = [dic objectForKey:@"seller"];
    if (objectForKey) {
        _userName = objectForKey;
    }
}

- (void)setCommodityInfoByDic:(NSDictionary*)dic{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    _comId = [[dic objectForKey:@"pid"] description];
//    _userId = [[dic objectForKey:@"uid"] description];
    
    @try {
        [self doSetCommodityInfoByDic:dic];
    }
    @catch (NSException *exception) {
        NSLog(@"####JFCommodityInfo setCommodityInfoByDic exception:%@", exception);
    }
    
    _jsonString = [dic JSONString];
}

-(NSURL *)comAvatarUrl{
    if (_attachment == nil || [_attachment isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [[WeiJiFenEngine shareInstance] baseUrl],_attachment]];
}
@end
