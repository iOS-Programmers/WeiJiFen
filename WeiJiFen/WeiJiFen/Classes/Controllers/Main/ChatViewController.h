//
//  ChatViewController.h
//  WeiJiFen
//
//  Created by liguangjun on 14-11-30.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "HTBaseViewController.h"
#import "JFUserInfo.h"

@interface ChatViewController : HTBaseViewController

@property (nonatomic, strong) JFUserInfo *userInfo;
@property (nonatomic, strong) NSString* peerId;//会话Id

@end
