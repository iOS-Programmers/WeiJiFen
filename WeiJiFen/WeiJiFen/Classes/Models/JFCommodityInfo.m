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
#import "JFCommentInfo.h"

@implementation JFCommodityInfo

- (void)doSetCommodityInfoByDic:(NSDictionary*)dic {
    
    id objectForKey = [dic objectForKey:@"subject"];
    if (objectForKey) {
        _name = [objectForKey description];
    }
    
    objectForKey = [dic objectForKey:@"attachment"];
    if (objectForKey) {
        _attachment = [objectForKey description];
    }
    
    objectForKey = [dic objectForKey:@"lastupdate"];
    if (objectForKey) {
        _crateDate = [objectForKey intValue];
    }
    
//    _comState = [[dic objectForKey:@"state"] intValue];
    _amount = [[dic objectForKey:@"amount"] intValue];
    _sellerCredit = [[dic objectForKey:@"sellercredit"] intValue];
    
    objectForKey = [dic objectForKey:@"seller"];
    if (objectForKey) {
        _userName = [objectForKey description];
    }
    objectForKey = [dic objectForKey:@"avatar"];
    if (objectForKey) {
        _userAvatarUrl = [NSURL URLWithString:[objectForKey description]];
    }
    
    objectForKey = [dic objectForKey:@"fid"];
    if (objectForKey) {
        _fid = [objectForKey description];
    }
    objectForKey = [dic objectForKey:@"tid"];
    if (objectForKey) {
        _tid = [objectForKey description];
    }
    objectForKey = [dic stringObjectForKey:@"message"];
    if (objectForKey) {
        _message = [objectForKey description];
    }
    
    _price = [[dic objectForKey:@"price"] intValue];
    _credit = [[dic objectForKey:@"credit"] intValue];
    _quality = [[dic objectForKey:@"quality"] intValue];
    _expiration = [[dic objectForKey:@"expiration"] intValue];
    _recommend_add = [[dic objectForKey:@"recommend_add"] intValue];
    _replies = [[dic objectForKey:@"replies"] intValue];
    _transport = [[dic objectForKey:@"transport"] intValue];
    _ordinaryfee = [[dic objectForKey:@"ordinaryfee"] intValue];
    _expressfee = [[dic objectForKey:@"expressfee"] intValue];
    _emsfee = [[dic objectForKey:@"emsfee"] intValue];
    
    _replylist = [[NSMutableArray alloc] init];
    for (NSDictionary* commentDic in [dic objectForKey:@"replylist"]) {
        JFCommentInfo* commentnfo = [[JFCommentInfo alloc] init];
        [commentnfo setCommentInfoByDic:commentDic];
        [_replylist addObject:commentnfo];
    }
}

- (void)setCommodityInfoByDic:(NSDictionary*)dic{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    _comId = [[dic objectForKey:@"pid"] description];
    
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
