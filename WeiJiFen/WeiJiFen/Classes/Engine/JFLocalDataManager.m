//
//  JFLocalDataManager.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-16.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "JFLocalDataManager.h"
#import "LSCommonUtils.h"

static JFLocalDataManager *_shareInstance = nil;

@implementation JFLocalDataManager

+ (JFLocalDataManager*)shareInstance{
    @synchronized(self) {
        if (_shareInstance == nil) {
            _shareInstance = [[JFLocalDataManager alloc] init];
        }
    }
    return _shareInstance;
}

- (void)login{
    
}
- (void)logout{
    
}
- (NSMutableArray *)getLocalCommodityArray{
    NSMutableArray *tmpMutArray = [NSMutableArray array];
    for (int index = 0; index < 15; index ++) {
        NSMutableDictionary *aDic = [[NSMutableDictionary alloc] init];
        [aDic setObject:@"官方物品" forKey:@"name"];
        [aDic setObject:@"123" forKey:@"id"];
        [aDic setObject:@"http://d.hiphotos.baidu.com/baike/c0%3Dbaike80%2C5%2C5%2C80%2C26%3Bt%3Dgif/sign=2157a44db0de9c82b268f1dd0de8eb6f/10dfa9ec8a136327d1df8247928fa0ec08fac790.jpg" forKey:@"avatarUrl"];
        [aDic setObject:[[LSCommonUtils dateFormatterOFUS] stringFromDate:[NSDate date]] forKey:@"created_at"];
        [aDic setObject:@"官方账号111" forKey:@"userName"];
        [aDic setObject:[NSNumber numberWithInt:1] forKey:@"state"];
        [tmpMutArray addObject:aDic];
    }
    return tmpMutArray;
}

- (NSMutableArray *)getLocalCommodityArray2{
    NSMutableArray *tmpMutArray = [NSMutableArray array];
    for (int index = 0; index < 15; index ++) {
        NSMutableDictionary *aDic = [[NSMutableDictionary alloc] init];
        [aDic setObject:@"虚拟物品" forKey:@"name"];
        [aDic setObject:@"123" forKey:@"id"];
        [aDic setObject:@"http://y0.ifengimg.com/e7f199c1e0dbba14/2013/0722/rdn_51ece7b8ad179.jpg" forKey:@"avatarUrl"];
        [aDic setObject:[[LSCommonUtils dateFormatterOFUS] stringFromDate:[NSDate date]] forKey:@"created_at"];
        [aDic setObject:@"官方账号222" forKey:@"userName"];
        [aDic setObject:[NSNumber numberWithInt:1] forKey:@"state"];
        [tmpMutArray addObject:aDic];
    }
    return tmpMutArray;
}

@end
