//
//  JFCommodityInfo.h
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-17.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFCommodityInfo : NSObject

@property (nonatomic, strong) NSString* comId;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* attachment;
@property (nonatomic, readonly) NSURL* comAvatarUrl;
@property (nonatomic, strong) NSDate* crateDate;
@property (nonatomic, assign) int comState;
@property (nonatomic, assign) int amount;

@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, assign) int sellerCredit;//卖家信誉

@property(nonatomic, strong) NSString* jsonString;

- (void)setCommodityInfoByDic:(NSDictionary*)dic;

@end
