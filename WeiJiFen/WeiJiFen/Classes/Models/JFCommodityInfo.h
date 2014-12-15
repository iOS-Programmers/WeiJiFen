//
//  JFCommodityInfo.h
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-17.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFCommodityInfo : NSObject

@property (nonatomic, strong) NSString* comId;//商品id
@property (nonatomic, strong) NSString* name;//标题
@property (nonatomic, strong) NSString* attachment;
@property (nonatomic, readonly) NSURL* comAvatarUrl;
@property (nonatomic, assign) int crateDate;//最近修改时间
@property (nonatomic, assign) int comState;//暂无这个字段
@property (nonatomic, assign) int amount;//数量

@property (nonatomic, strong) NSString* userId;//暂无这个字段
@property (nonatomic, strong) NSString* userName;//发布者名称
@property (nonatomic, readonly) NSURL* userAvatarUrl;//发布者头像
@property (nonatomic, assign) int sellerCredit;//卖家信誉

@property (nonatomic, strong) NSString* fid;//版块id
@property (nonatomic, strong) NSString* tid;//主题id
@property (nonatomic, assign) int price;//价格
@property (nonatomic, assign) int credit;//微积分
@property (nonatomic, assign) int quality;//商品类型
@property (nonatomic, assign) int expiration;//过期时间
@property (nonatomic, assign) int recommend_add;//支持条数
@property (nonatomic, assign) int replies;//回复条数
@property (nonatomic, strong) NSString* message;//商品详情
@property (nonatomic, assign) int transport;//物流方式  0虚拟物品1卖家承担运费2买家承担运费3支付给物流公司4线下交
@property (nonatomic, assign) int ordinaryfee;//平邮运费
@property (nonatomic, assign) int expressfee;//快递运费
@property (nonatomic, assign) int emsfee;//EMS运费

@property (nonatomic, strong) NSMutableArray *replylist;//回复的帖子

@property(nonatomic, strong) NSString* jsonString;

- (void)setCommodityInfoByDic:(NSDictionary*)dic;

@end
