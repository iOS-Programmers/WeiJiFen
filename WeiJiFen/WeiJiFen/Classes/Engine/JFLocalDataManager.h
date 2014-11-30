//
//  JFLocalDataManager.h
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-16.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFLocalDataManager : NSObject

+ (JFLocalDataManager*)shareInstance;
- (void)login;
- (void)logout;

- (NSMutableArray *)getTaskCenterData;

- (NSMutableArray *)getLocalCommodityArray;
- (NSMutableArray *)getLocalCommodityArray2;
- (NSDictionary *)getTESTuserMsg;
- (NSMutableArray *)getTESTSystemMsg;
- (NSMutableArray *)getTESTOnlineMsg;

@end
