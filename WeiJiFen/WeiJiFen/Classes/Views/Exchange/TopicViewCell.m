//
//  TopicViewCell.m
//  WeiJiFen
//
//  Created by liguangjun on 14-11-24.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "TopicViewCell.h"
#import "UIImageView+WebCache.h"

@implementation TopicViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTopicInfo:(JFTopicInfo *)topicInfo{
    _topicInfo = topicInfo;
    
    self.contentView.backgroundColor = [LSCommonUtils getProgramMainDaryColor];
    [self.userAvatar sd_setImageWithURL:topicInfo.userAvatarUrl placeholderImage:[UIImage imageNamed:@"jf_message_icon.png"]];
    self.topicLabel.text = topicInfo.subject;
    self.userNameLabel.text = topicInfo.author;
    self.dateLabel.text = [LSCommonUtils secondChangToDate:[NSString stringWithFormat:@"%d",topicInfo.dateline]];
    self.checkAndreplyLabel.text = [NSString stringWithFormat:@"%d/%d",topicInfo.replies,topicInfo.views];
}

@end
