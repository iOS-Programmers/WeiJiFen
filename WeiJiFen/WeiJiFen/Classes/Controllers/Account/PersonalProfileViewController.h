//
//  PersonalProfileViewController.h
//  WeiJiFen
//
//  Created by liguangjun on 14-11-28.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "HTBaseViewController.h"
#import "JFBaseTableViewController.h"
#import "JFUserInfo.h"

@interface PersonalProfileViewController : JFBaseTableViewController

@property (nonatomic, strong) JFUserInfo *userInfo;
@property (nonatomic, strong) NSString* userId;

@end
