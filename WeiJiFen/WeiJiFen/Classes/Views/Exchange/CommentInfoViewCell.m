//
//  CommentInfoViewCell.m
//  WeiJiFen
//
//  Created by liguangjun on 14-11-25.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "CommentInfoViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@implementation CommentInfoViewCell

+(CGFloat)getCommentInfoViewCellHeight:(JFCommentInfo *)commentInfo{
    CGFloat height = 0;
    NSString *message = commentInfo.message;
    CGFloat messageHeight = [message sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(247.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping].height;
    
    height += messageHeight;
    height += 50;
    height += 10;
    
    return height;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCommentInfo:(JFCommentInfo *)commentInfo{
    
    [self.replyButton setBackgroundImage:[[UIImage imageNamed:@"jf_greyandwhite_bg.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:4] forState:UIControlStateNormal];
    self.replyButton.hidden = NO;
    if (_isHiddenReplyButton) {
        self.replyButton.hidden = YES;
    }
    
    [self.userAvatar sd_setImageWithURL:commentInfo.avatarUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"jf_message_icon.png"]];
    self.userNameLabel.text = commentInfo.author;
    self.dateLabel.text = [LSCommonUtils secondChangToDate:[NSString stringWithFormat:@"%d",commentInfo.dateline]];
    
    self.topicLabel.text = commentInfo.message;
    
    CGRect frame = self.topicLabel.frame;
//    frame.size.width = self.frame.size.width - 10*2;
    float textHeight = [self.topicLabel sizeThatFits:CGSizeMake(frame.size.width, CGFLOAT_MAX)].height;
    frame.size.height = textHeight;
    self.topicLabel.frame = frame;
}

@end
