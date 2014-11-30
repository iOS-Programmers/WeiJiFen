//
//  ChatCardViewCell.m
//  WeiJiFen
//
//  Created by liguangjun on 14-11-30.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "ChatCardViewCell.h"
#import "UIButton+WebCache.h"

@implementation ChatCardViewCell

+(CGFloat)getChatCardViewCellHeight:(JFMessageInfo *)messageInfo{
    CGFloat height = 0;
    NSString *message = messageInfo.message;
    CGFloat messageHeight = [message sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(180.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping].height;
    
    height += 21;
    height += messageHeight;
    
    height += 30;
    
    return height;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMessageInfo:(JFMessageInfo *)messageInfo{
    _messageInfo = messageInfo;
    
    self.backgroundColor = [UIColor clearColor];
    
    [self.userAvatar sd_setImageWithURL:messageInfo.avatarUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"avatar.png"]];
    self.bgImageView.image = [[UIImage imageNamed:@"jf_bubble_orange.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:11];//
    self.dateLabel.text = [LSCommonUtils secondChangToDateString:[NSString stringWithFormat:@"%d",messageInfo.dateline]];
    self.contentLabel.text = messageInfo.message;
    self.contentLabel.textColor = [UIColor whiteColor];
    
    CGRect frame = self.userAvatar.frame;
    frame.origin.x = 10;
    self.userAvatar.frame = frame;
    
    frame = self.contentLabel.frame;
    frame.origin.x = self.userAvatar.frame.origin.x +  self.userAvatar.frame.size.width + 30;
    frame.origin.y = 21;
    float textHeight = [self.contentLabel sizeThatFits:CGSizeMake(frame.size.width, CGFLOAT_MAX)].height;
    frame.size.height = textHeight;
    self.contentLabel.frame = frame;
    
    frame = self.bgImageView.frame;
    frame.origin.x = self.userAvatar.frame.origin.x +  self.userAvatar.frame.size.width + 6;
    frame.size.height = textHeight + 2*7;
    self.bgImageView.frame = frame;
    
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    frame = self.dateLabel.frame;
    frame.origin.y = self.bgImageView.frame.origin.y + self.bgImageView.frame.size.height + 10;
    frame.origin.x = self.bgImageView.frame.origin.x;
    self.dateLabel.frame = frame;
    
    
    if (messageInfo.isSender) {
        self.bgImageView.image = [[UIImage imageNamed:@"jf_bubble_white.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:11];
        self.contentLabel.textColor = [LSCommonUtils getProgramMainTitleColor];
        
        CGRect frame = self.userAvatar.frame;
        frame.origin.x = self.frame.size.width - frame.size.width - 10;
        self.userAvatar.frame = frame;
        
        frame = self.contentLabel.frame;
        frame.origin.x = self.frame.size.width - (self.userAvatar.frame.size.width +10 + 30 + self.contentLabel.frame.size.width);
        float textHeight = [self.contentLabel sizeThatFits:CGSizeMake(frame.size.width, CGFLOAT_MAX)].height;
        frame.size.height = textHeight;
        self.contentLabel.frame = frame;
        
        frame = self.bgImageView.frame;
        frame.origin.x = (self.contentLabel.frame.origin.x - 13);
        frame.size.height = textHeight + 2*7;
        self.bgImageView.frame = frame;
        
        self.dateLabel.textAlignment = NSTextAlignmentLeft;
        frame = self.dateLabel.frame;
        frame.origin.y = self.bgImageView.frame.origin.y + self.bgImageView.frame.size.height + 10;
        frame.origin.x = self.bgImageView.frame.origin.x;
        self.dateLabel.frame = frame;
        
    }
}

@end
