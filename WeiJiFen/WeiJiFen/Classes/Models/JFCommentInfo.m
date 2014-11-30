//
//  JFCommentInfo.m
//  WeiJiFen
//
//  Created by liguangjun on 14-11-24.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "JFCommentInfo.h"

@implementation JFCommentInfo

- (void)setCommentInfoByDic:(NSDictionary*)dic{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    @try {
        _pId = [[dic objectForKey:@"pid"] description];
        _author = [[dic objectForKey:@"author"] description];
        _authorId = [[dic objectForKey:@"authorid"] description];
        _message = [[dic objectForKey:@"message"] description];
        _dateline = [[dic objectForKey:@"dateline"] intValue];
    }
    @catch (NSException *exception) {
        NSLog(@"####JFCommentInfo setCommentInfoByDic exception:%@", exception);
    }
    _commentInfoByDic = dic;
}
@end
