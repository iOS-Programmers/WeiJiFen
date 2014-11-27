//
//  JFLocalDataManager.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-16.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "JFLocalDataManager.h"
#import "LSCommonUtils.h"
#import "JSONKit.h"

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
        [aDic setObject:@"456" forKey:@"id"];
        [aDic setObject:@"http://y0.ifengimg.com/e7f199c1e0dbba14/2013/0722/rdn_51ece7b8ad179.jpg" forKey:@"avatarUrl"];
        [aDic setObject:[[LSCommonUtils dateFormatterOFUS] stringFromDate:[NSDate date]] forKey:@"created_at"];
        [aDic setObject:@"官方账号222" forKey:@"userName"];
        [aDic setObject:[NSNumber numberWithInt:2] forKey:@"state"];
        [tmpMutArray addObject:aDic];
    }
    return tmpMutArray;
}
- (NSMutableArray *)getTaskCenterData{
    
    NSMutableArray *tmpMutArray = [NSMutableArray arrayWithArray:@[@{@"taskid":@"1",@"name":@"\u5934\u50cf\u7c7b\u4efb\u52a1",@"description":@"\u8be5\u4efb\u52a1\u4ec5\u9650\u6ca1\u6709\u4e0a\u4f20\u5934\u50cf\u7684\u4f1a\u5458\u7533\u8bf7\uff0c\u7533\u8bf7\u540e\u53ea\u8981\u4e0a\u4f20\u5934\u50cf\u5373\u53ef\u5b8c\u6210\u4efb\u52a1\uff0c\u83b7\u5f97\u76f8\u5e94\u7684\u5956\u52b1",@"applicants":@"0",@"bonus":@"2"},@{@"taskid":@"2",@"name":@"\u7ea2\u5305\u7c7b\u4efb\u52a1",@"description":@"\u7533\u8bf7\u6b64\u4efb\u52a1\u5373\u53ef\u9886\u53d6\u7ea2\u5305",@"applicants":@"1",@"bonus":@"1"}]];
    
    return tmpMutArray;
    
//    {"data":[{"taskid":"1","name":"\u5934\u50cf\u7c7b\u4efb\u52a1","description":"\u8be5\u4efb\u52a1\u4ec5\u9650\u6ca1\u6709\u4e0a\u4f20\u5934\u50cf\u7684\u4f1a\u5458\u7533\u8bf7\uff0c\u7533\u8bf7\u540e\u53ea\u8981\u4e0a\u4f20\u5934\u50cf\u5373\u53ef\u5b8c\u6210\u4efb\u52a1\uff0c\u83b7\u5f97\u76f8\u5e94\u7684\u5956\u52b1","applicants":"0","bonus":"2"},{"taskid":"2","name":"\u7ea2\u5305\u7c7b\u4efb\u52a1","description":"\u7533\u8bf7\u6b64\u4efb\u52a1\u5373\u53ef\u9886\u53d6\u7ea2\u5305","applicants":"1","bonus":"1"}],"token":"5468c5b6ea5cc","error_no":0}
    
//    NSString *text = @"{\"data\":[{\"taskid\":\"1\",\"name\":\"\u5934\u50cf\u7c7b\u4efb\u52a1\",\"description\":\"\u8be5\u4efb\u52a1\u4ec5\u9650\u6ca1\u6709\u4e0a\u4f20\u5934\u50cf\u7684\u4f1a\u5458\u7533\u8bf7\uff0c\u7533\u8bf7\u540e\u53ea\u8981\u4e0a\u4f20\u5934\u50cf\u5373\u53ef\u5b8c\u6210\u4efb\u52a1\uff0c\u83b7\u5f97\u76f8\u5e94\u7684\u5956\u52b1\",\"applicants\":\"0\",\"bonus\":\"2\"},{\"taskid\":\"2\",\"name\":\"\u7ea2\u5305\u7c7b\u4efb\u52a1\",\"description\":\"\u7533\u8bf7\u6b64\u4efb\u52a1\u5373\u53ef\u9886\u53d6\u7ea2\u5305\",\"applicants\":\"1\",\"bonus\":\"1\"}],\"token\":\"5468c5b6ea5cc\",\error_no\":0}";
//    return [text JSONString];
}
@end
