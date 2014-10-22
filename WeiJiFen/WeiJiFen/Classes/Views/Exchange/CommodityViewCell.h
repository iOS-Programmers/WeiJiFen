//
//  CommodityViewCell.h
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-20.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFCommodityInfo.h"

@interface CommodityViewCell : UITableViewCell

@property (nonatomic, strong) JFCommodityInfo *commodityInfo;
@property (nonatomic, strong) IBOutlet UIImageView *commodityAvatar;
@property (nonatomic, strong) IBOutlet UILabel *commodityNameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *userAvatar;
@property (nonatomic, strong) IBOutlet UILabel *userNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UIButton *commodityStateBtn;

-(IBAction)commodityStateAction:(id)sender;

@end
