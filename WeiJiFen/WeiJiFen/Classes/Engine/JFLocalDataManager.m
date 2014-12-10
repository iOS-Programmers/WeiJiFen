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

- (NSMutableArray *)getTaskCenterData{
    
    NSMutableArray *tmpMutArray = [NSMutableArray arrayWithArray:@[
  @{@"taskid":@"1",@"name":@"多盟广告平台",@"description":@"装应用赚积分",@"applicants":@"0",@"bonus":@"2",@"icon":@"jf_taskcenter_dm"},
  @{@"taskid":@"2",@"name":@"有米广告平台",@"description":@"装应用赚积分",@"applicants":@"1",@"bonus":@"1",@"icon":@"jf_taskcenter_ym"},
  @{@"taskid":@"2",@"name":@"点入广告平台",@"description":@"装应用赚积分",@"applicants":@"1",@"bonus":@"1",@"icon":@"jf_taskcenter_dr"},
  @{@"taskid":@"2",@"name":@"力美广告平台",@"description":@"装应用赚积分",@"applicants":@"1",@"bonus":@"1",@"icon":@"jf_taskcenter_lm"},
  @{@"taskid":@"2",@"name":@"易积分广告平台",@"description":@"装应用赚积分",@"applicants":@"1",@"bonus":@"1",@"icon":@"jf_taskcenter_yjf"}]];
    
    return tmpMutArray;
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
- (NSDictionary *)getTESTuserMsg{
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:@{@"1":@{@"authorid":@"2",@"username":@"aaa",@"message":@"\n1111",@"dateline":@"1415190876",@"avatar":@"http://www.wjf123.cn/uc_server/avatar.php?uid=2&size=middle"},@"2":@{@"authorid":@"2",@"username":@"aaa",@"message":@"1111",@"dateline":@"1415192726",@"avatar":@"http://www.wjf123.cn/uc_server/avatar.php?uid=2&size=middle"}}];
    return mutDic;
    
}
- (NSMutableArray *)getTESTSystemMsg{
    
    NSMutableArray *tmpMutArray = [NSMutableArray arrayWithArray:@[@{@"note":@"\u5c0a\u656c\u7684aaa\uff0c\u60a8\u5df2\u7ecf\u6ce8\u518c\u6210\u4e3aComsenz Inc.\u7684\u4f1a\u5458\uff0c\u8bf7\u60a8\u5728\u53d1\u8868\u8a00\u8bba\u65f6\uff0c\u9075\u5b88\u5f53\u5730\u6cd5\u5f8b\u6cd5\u89c4\u3002",@"dateline":@"1415190329"}]];
    
    return tmpMutArray;
}

- (NSMutableArray *)getTESTOnlineMsg{
    NSMutableArray *tmpMutArray = [NSMutableArray arrayWithArray:@[@{@"plid":@"1",@"authorid":@"1",@"message":@"我在手机上用咱们的wifi都看到商品",@"dateline":@"1415190329"},@{@"plid":@"1",@"authorid":@"1",@"message":@"在吗？老板 我想买Q币",@"dateline":@"1415190329"},@{@"plid":@"1",@"authorid":@"1",@"message":@"哈hha品",@"dateline":@"1415190329"},@{@"plid":@"1",@"authorid":@"1",@"message":@"还白",@"dateline":@"1415190329"}]];
    
    return tmpMutArray;
    
}

@end
