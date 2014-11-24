//
//  TopicViewCell.h
//  WeiJiFen
//
//  Created by liguangjun on 14-11-24.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFTopicInfo.h"

@interface TopicViewCell : UITableViewCell

@property (nonatomic, strong) JFTopicInfo *topicInfo;
@property (nonatomic, strong) IBOutlet UIImageView *userAvatar;
@property (nonatomic, strong) IBOutlet UILabel *topicLabel;
@property (nonatomic, strong) IBOutlet UILabel *userNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *checkAndreplyLabel;

@end
