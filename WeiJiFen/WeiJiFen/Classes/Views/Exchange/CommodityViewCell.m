//
//  CommodityViewCell.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-20.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "CommodityViewCell.h"
#import "UIImageView+WebCache.h"

@implementation CommodityViewCell

- (void)awakeFromNib {
    // Initialization code
    _commodityAvatar.contentMode = UIViewContentModeScaleAspectFill;
    _commodityAvatar.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCommodityInfo:(JFCommodityInfo *)commodityInfo{
    
    _commodityInfo = commodityInfo;
    [self.commodityAvatar sd_setImageWithURL:commodityInfo.comAvatarUrl placeholderImage:[UIImage imageNamed:@"jf_message_icon.png"]];
    self.commodityNameLabel.text = commodityInfo.name;
//    [self.userAvatar sd_setImageWithURL:commodityInfo.u placeholderImage:<#(UIImage *)#>]
    self.userNameLabel.text = commodityInfo.userName;
    
    self.dateLabel.text = [LSCommonUtils dateDiscriptionFromDate:commodityInfo.crateDate];
}

@end
