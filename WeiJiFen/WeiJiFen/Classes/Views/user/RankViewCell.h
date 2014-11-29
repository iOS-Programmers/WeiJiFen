//
//  RankViewCell.h
//  WeiJiFen
//
//  Created by liguangjun on 14-11-29.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankViewCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *rankDic;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *creditsLabel;
@end
