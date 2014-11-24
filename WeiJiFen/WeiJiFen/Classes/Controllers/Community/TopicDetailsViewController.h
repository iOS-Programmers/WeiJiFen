//
//  TopicDetailsViewController.h
//  WeiJiFen
//
//  Created by liguangjun on 14-11-24.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "HTBaseViewController.h"
#import "JFTopicInfo.h"

@interface TopicDetailsViewController : HTBaseViewController

@property (nonatomic, strong) JFTopicInfo *topicInfo;
@property (nonatomic, assign) BOOL isFromHelp;

@end
