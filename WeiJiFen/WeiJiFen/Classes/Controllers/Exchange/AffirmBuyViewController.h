//
//  AffirmBuyViewController.h
//  WeiJiFen
//
//  Created by liguangjun on 14-12-10.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "JFBaseTableViewController.h"
#import "JFCommodityInfo.h"

typedef enum VcType_{
    VcType_Nomal = 0,//确认购买
    VcType_Pay,//确认付款and取消付款
}VcType;

@interface AffirmBuyViewController : JFBaseTableViewController

@property (nonatomic, strong) JFCommodityInfo *commodityInfo;
@property (nonatomic, assign) VcType vcType;
@property (nonatomic, strong) NSString *orderId;

@end
