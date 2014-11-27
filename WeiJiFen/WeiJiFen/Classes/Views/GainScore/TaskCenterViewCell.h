//
//  TaskCenterViewCell.h
//  WeiJiFen
//
//  Created by liguangjun on 14-11-27.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFTaskInfo.h"

@interface TaskCenterViewCell : UITableViewCell

@property (nonatomic, strong) JFTaskInfo *taskInfo;
@property (nonatomic, strong) IBOutlet UIImageView *taskAvatarImageView;
@property (nonatomic, strong) IBOutlet UILabel *taskTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *taskbriefLabel;
@property (nonatomic, strong) IBOutlet UILabel *taskPriceLabel;
@property (nonatomic, strong) IBOutlet UILabel *webTaskPriceLabel;
@property (nonatomic, strong) IBOutlet UIImageView *indicationImageView;
@property (nonatomic, strong) IBOutlet UIButton *applyButton;

@property (nonatomic, assign) BOOL isWebTask;

@end
