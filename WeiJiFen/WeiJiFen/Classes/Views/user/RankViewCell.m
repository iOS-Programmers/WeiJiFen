//
//  RankViewCell.m
//  WeiJiFen
//
//  Created by liguangjun on 14-11-29.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "RankViewCell.h"

@implementation RankViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRankDic:(NSDictionary *)rankDic{
    _rankDic = rankDic;
    
    self.creditsLabel.text = [NSString stringWithFormat:@"%d",[rankDic intValueForKey:@"extcredits1"]];
    self.userNameLabel.text = [rankDic stringObjectForKey:@"username"];
    
}

@end
