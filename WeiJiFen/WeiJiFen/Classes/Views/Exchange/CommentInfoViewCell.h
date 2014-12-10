//
//  CommentInfoViewCell.h
//  WeiJiFen
//
//  Created by liguangjun on 14-11-25.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFCommentInfo.h"

@interface CommentInfoViewCell : UITableViewCell

@property (nonatomic, strong) JFCommentInfo *commentInfo;
@property (nonatomic, strong) IBOutlet UIButton *userAvatar;
@property (nonatomic, strong) IBOutlet UILabel *topicLabel;
@property (nonatomic, strong) IBOutlet UILabel *userNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@property (nonatomic, assign) BOOL isHiddenReplyButton;

+(CGFloat)getCommentInfoViewCellHeight:(JFCommentInfo *)commentInfo;

@end
