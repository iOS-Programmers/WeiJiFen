//
//  TaskCenterViewCell.m
//  WeiJiFen
//
//  Created by liguangjun on 14-11-27.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "TaskCenterViewCell.h"
#import "UIImageView+WebCache.h"

@implementation TaskCenterViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTaskInfo:(JFTaskInfo *)taskInfo{
    _taskInfo = taskInfo;
    
    [self.taskAvatarImageView sd_setImageWithURL:[NSURL URLWithString:taskInfo.icon] placeholderImage:[UIImage imageNamed:@"jf_message_icon.png"]];
    
    self.taskTitleLabel.text = taskInfo.name;
    self.taskbriefLabel.text = taskInfo.taskDescription;
    self.taskPriceLabel.text = [NSString stringWithFormat:@"%d",taskInfo.bonus];
    
    CGRect frame = self.taskAvatarImageView.frame;
    frame.size.width = 45;
    self.webTaskPriceLabel.hidden = YES;
    self.taskPriceLabel.hidden = NO;
    self.indicationImageView.hidden = NO;
    self.applyButton.hidden = YES;
    if (_isWebTask) {
        self.webTaskPriceLabel.hidden = NO;
        self.taskPriceLabel.hidden = YES;
        self.applyButton.hidden = NO;
        self.indicationImageView.hidden = YES;
        [self.applyButton setBackgroundImage:[[UIImage imageNamed:@"jf_login_btn_icon.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:4] forState:UIControlStateNormal];
        self.taskTitleLabel.text = [NSString stringWithFormat:@"%@(人气：%d)",taskInfo.name,taskInfo.applicants];
        self.webTaskPriceLabel.text = [NSString stringWithFormat:@"微积分 %d",taskInfo.bonus];
        [self.taskAvatarImageView sd_setImageWithURL:nil];
        [self.taskAvatarImageView sd_setImageWithURL:[NSURL URLWithString:taskInfo.icon] placeholderImage:[UIImage imageNamed:@"jf_webtask_default_icon.png"]];
        frame.size.width = 39;
    }
    self.taskAvatarImageView.frame = frame;
}

-(void)setMessageInfo:(JFMessageInfo *)messageInfo{
    _messageInfo = messageInfo;
    
    
    
    [self.taskAvatarImageView sd_setImageWithURL:messageInfo.avatarUrl placeholderImage:[UIImage imageNamed:@"jf_message_icon.png"]];
    
    self.taskTitleLabel.text = messageInfo.userName;
    self.taskbriefLabel.text = messageInfo.message;
    self.taskPriceLabel.text = [LSCommonUtils secondChangToDateString:[NSString stringWithFormat:@"%d",messageInfo.dateline]];
    
    CGRect frame = self.taskAvatarImageView.frame;
    frame.size.width = 45;
    self.taskAvatarImageView.frame = frame;
    
    frame = self.taskPriceLabel.frame;
    frame.size.width = 100;
    self.taskPriceLabel.frame = frame;
    
    self.webTaskPriceLabel.hidden = YES;
    self.taskPriceLabel.hidden = NO;
    self.indicationImageView.hidden = YES;
    self.applyButton.hidden = YES;
}

@end
