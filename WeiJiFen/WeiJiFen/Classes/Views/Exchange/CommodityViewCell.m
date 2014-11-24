//
//  CommodityViewCell.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-20.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "CommodityViewCell.h"
#import "UIImageView+WebCache.h"

#define GridViewItemSpacing 1
#define GridViewItemSizeWidth 12

@interface CommodityViewCell ()<GMGridViewDataSource>
@end

@implementation CommodityViewCell

- (void)awakeFromNib {
    // Initialization code
    _commodityAvatar.contentMode = UIViewContentModeScaleAspectFill;
    _commodityAvatar.clipsToBounds = YES;
    
    self.userAvatar.layer.cornerRadius = self.userAvatar.bounds.size.width/2;
    self.userAvatar.layer.masksToBounds = YES;
    
    _creditGridView.style = GMGridViewStyleSwap;
    _creditGridView.itemSpacing = GridViewItemSpacing;
    _creditGridView.minEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _creditGridView.centerGrid = NO;
    _creditGridView.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutHorizontal];
//    _creditGridView.actionDelegate = self;
    _creditGridView.showsHorizontalScrollIndicator = NO;
    _creditGridView.showsVerticalScrollIndicator = NO;
    _creditGridView.dataSource = self;
    _creditGridView.scrollsToTop = NO;
}

-(int)getMaxCreditCount{
    int maxCreditCount = self.commodityInfo.sellerCredit;
    if (maxCreditCount > 10) {
        maxCreditCount = 10;
    }
    return maxCreditCount;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark GMGridViewDataSource
- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView {
    return [self getMaxCreditCount];
}
- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation {
    
    return CGSizeMake(GridViewItemSizeWidth,GridViewItemSizeWidth);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell) {
        cell = [[GMGridViewCell alloc] init];
        CGRect imageFrame = CGRectMake(0, 0, GridViewItemSizeWidth, GridViewItemSizeWidth);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
        imageView.image = [UIImage imageNamed:@"jf_sellercredit_icon.png"];
        cell.contentView = imageView;
    }
//    UIImageView* imageView = (UIImageView* )cell.contentView;
    return cell;
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
    float tmpLabelWidth = [self.userNameLabel.text sizeWithFont:self.userNameLabel.font].width;
    if (tmpLabelWidth > 80) {
        tmpLabelWidth = 80;
    }
    CGRect frame = self.userNameLabel.frame;
    frame.size.width = tmpLabelWidth;
    self.userNameLabel.frame = frame;
    
    self.dateLabel.text = [LSCommonUtils secondChangToDateString:[NSString stringWithFormat:@"%d",commodityInfo.crateDate]];
    
    //状态
    self.commodityStateBtn.backgroundColor = UIColorRGB(4, 185, 88);
    [self.commodityStateBtn setTitle:@"未开始" forState:0];
    if (commodityInfo.amount == 0){
        self.commodityStateBtn.backgroundColor = UIColorRGB(181, 181, 181);
        [self.commodityStateBtn setTitle:@"抢光了" forState:0];
    }
    if (commodityInfo.comState == 1){
        self.commodityStateBtn.backgroundColor = UIColorRGB(235, 31, 32);
        [self.commodityStateBtn setTitle:@"兑换" forState:0];
    }
    
    frame = self.creditGridView.frame;
    frame.origin.x = self.userNameLabel.frame.origin.x + self.userNameLabel.frame.size.width + 3;
    frame.size.width = [self getMaxCreditCount]*(GridViewItemSizeWidth+1);
    self.creditGridView.frame = frame;
    
    [self.creditGridView reloadData];
}

@end
