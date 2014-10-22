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
    
    self.userAvatar.layer.cornerRadius = self.userAvatar.bounds.size.width/2;
    self.userAvatar.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Action
-(IBAction)commodityStateAction:(id)sender{
    
}

-(void)setCommodityInfo:(JFCommodityInfo *)commodityInfo{
    
    _commodityInfo = commodityInfo;
    
    [self.commodityAvatar sd_setImageWithURL:commodityInfo.comAvatarUrl placeholderImage:[UIImage imageNamed:@"jf_message_icon.png"]];
    self.commodityNameLabel.text = commodityInfo.name;
    
    [self.userAvatar sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"jf_commodity_userAvatar_defaulticon.png"]];
    self.userNameLabel.text = commodityInfo.userName;
    
    self.dateLabel.text = [LSCommonUtils dateDiscriptionFromDate:commodityInfo.crateDate];
    
    //状态
    self.commodityStateBtn.backgroundColor = UIColorRGB(4, 185, 88);
    [self.commodityStateBtn setTitle:@"未开始" forState:0];
    if (commodityInfo.comState == 1){
        self.commodityStateBtn.backgroundColor = UIColorRGB(235, 31, 32);
        [self.commodityStateBtn setTitle:@"兑换" forState:0];
    }else if (commodityInfo.comState == 2){
        self.commodityStateBtn.backgroundColor = UIColorRGB(181, 181, 181);
        [self.commodityStateBtn setTitle:@"抢光了" forState:0];
    }
}

@end
