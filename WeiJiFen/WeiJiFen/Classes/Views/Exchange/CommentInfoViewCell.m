//
//  CommentInfoViewCell.m
//  WeiJiFen
//
//  Created by liguangjun on 14-11-25.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "CommentInfoViewCell.h"
#import "UIImageView+WebCache.h"

@implementation CommentInfoViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCommentInfo:(JFCommentInfo *)commentInfo{
    
    [self.userAvatar sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"jf_message_icon.png"]];
    self.userNameLabel.text = commentInfo.author;
    self.dateLabel.text = [LSCommonUtils secondChangToDate:[NSString stringWithFormat:@"%d",commentInfo.dateline]];
    
    self.topicLabel.text = commentInfo.message;
    
}

@end
