//
//  CommodityDetailsViewController.h
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-22.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "HTBaseViewController.h"
#import "JFCommodityInfo.h"

@interface CommodityDetailsViewController : HTBaseViewController

@property (nonatomic, strong) JFCommodityInfo *commodityInfo;
@property (nonatomic, strong) NSString *commodType;

@end
