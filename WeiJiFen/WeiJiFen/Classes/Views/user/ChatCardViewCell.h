//
//  ChatCardViewCell.h
//  WeiJiFen
//
//  Created by liguangjun on 14-11-30.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFMessageInfo.h"

@interface ChatCardViewCell : UITableViewCell

@property (nonatomic, strong) JFMessageInfo *messageInfo;
@property (nonatomic, strong) IBOutlet UIButton *userAvatar;
@property (nonatomic, strong) IBOutlet UIImageView *bgImageView;
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;

+(CGFloat)getChatCardViewCellHeight:(JFMessageInfo *)messageInfo;

@end
