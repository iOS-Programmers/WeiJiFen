//
//  JFTopicInfo.m
//  WeiJiFen
//
//  Created by liguangjun on 14-11-24.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "JFTopicInfo.h"
#import "JSONKit.h"
#import "JFCommentInfo.h"

@interface JFTopicInfo () {
    NSMutableArray* _comments;
    NSString* _jsonString;
}

@end

@implementation JFTopicInfo

- (void)doSetTopicInfoByDic:(NSDictionary *)dic{
    
    id objectForKey = [dic objectForKey:@"author"];
    if (objectForKey) {
        _author = objectForKey;
    }
    objectForKey = [dic objectForKey:@"authorid"];
    if (objectForKey) {
        _authorId = objectForKey;
    }
    
    objectForKey = [dic objectForKey:@"subject"];
    if (objectForKey) {
        _subject = objectForKey;
    }
    
    objectForKey = [dic objectForKey:@"dateline"];
    if (objectForKey) {
        _dateline = [objectForKey intValue];
    }
    _views = [[dic objectForKey:@"views"] intValue];
    _replies = [[dic objectForKey:@"replies"] intValue];
    
    objectForKey = [dic objectForKey:@"abs(price)"];
    if (objectForKey) {
        _price = objectForKey;
    }
    
    _comments = [[NSMutableArray alloc] init];
    for (NSDictionary* commentDic in [dic objectForKey:@"replylist"]) {
        JFCommentInfo* commentnfo = [[JFCommentInfo alloc] init];
        [commentnfo setCommentInfoByDic:commentDic];
        [_comments addObject:commentnfo];
    }
    
}

- (void)setTopicInfoByDic:(NSDictionary*)dic{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    _tId = [[dic objectForKey:@"tid"] description];
    _fId = [[dic objectForKey:@"fid"] description];
    
    @try {
        [self doSetTopicInfoByDic:dic];
    }
    @catch (NSException *exception) {
        NSLog(@"####JFTopicInfo setTopicInfoByDic exception:%@", exception);
    }
    
    _jsonString = [dic JSONString];
}

@end
