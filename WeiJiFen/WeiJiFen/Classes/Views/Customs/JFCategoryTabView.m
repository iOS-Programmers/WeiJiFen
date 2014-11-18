//
//  JFCategoryTabView.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-17.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "JFCategoryTabView.h"
#import "GMGridView.h"
#import "GMGridViewLayoutStrategies.h"
//#import "GMGridViewCell+Extended.h"
#import "LSCommonUtils.h"

#define GridView_Item_Width 0

@interface JFCategoryTabView () <GMGridViewDataSource, GMGridViewActionDelegate>{
    
}
@property (nonatomic, strong) GMGridView *gridView;
@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, assign) CGFloat gridViewItemWidth;

@end

@implementation JFCategoryTabView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = UIColorRGB(238,238,238);
        [self initObject];
    }
    return self;
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    CGRect frame = self.bounds;
//    frame.size.width = [UIScreen mainScreen].applicationFrame.size.width;
////    [self setFrame:(CGRect)];
//}

-(void)initObject{
    _gridViewItemWidth = GridView_Item_Width;
    _selectedImageView = [[UIImageView alloc] init];
    _selectedImageView.backgroundColor = [LSCommonUtils getProgramMainHueColor];
    _selectedImageView.frame = CGRectMake(0, self.frame.size.height - 2, _gridViewItemWidth + 1, 2);
    
    self.gridView = [[GMGridView alloc] initWithFrame:self.bounds];
    [self addSubview:_gridView];
    [self addSubview:_selectedImageView];
    _gridView.backgroundColor = [UIColor clearColor];
    _gridView.style = GMGridViewStyleSwap;
    
    _gridView.itemSpacing = 1.0;
    _gridView.minEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _gridView.centerGrid = NO;
    _gridView.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutHorizontal];
    _gridView.actionDelegate = self;
    _gridView.showsHorizontalScrollIndicator = NO;
    _gridView.showsVerticalScrollIndicator = NO;
    _gridView.dataSource = self;
//    //解决点击状态栏无法滚动到顶部的问题
    _gridView.scrollsToTop = NO;
}

#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView {
    return self.items.count;
}
- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation {
    
    return CGSizeMake(_gridViewItemWidth , self.frame.size.height);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell) {
        cell = [[GMGridViewCell alloc] init];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitleColor:UIColorRGB(103,103,103) forState:UIControlStateNormal];
//        [button setTitleColor:[LSCommonUtils getProgramMainHueColor] forState:UIControlStateHighlighted];
        [button setTitleColor:[LSCommonUtils getProgramMainHueColor] forState:UIControlStateSelected];
        CGRect imageFrame = CGRectMake(cell.frame.size.width, (self.frame.size.height-20)/2, 0.5, 20);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
        imageView.backgroundColor = UIColorRGB(151,151,151);
        [button addSubview:imageView];
        cell.contentView = button;
    }
    UIButton* button = (UIButton* )cell.contentView;
    if ([[_items objectAtIndex:index] isKindOfClass:[NSString class]]) {
        [button setTitle:[_items objectAtIndex:index] forState:UIControlStateNormal];
    }
    if (index == _initialIndex) {
        button.selected = YES;
    }else{
        button.selected = NO;
    }
    return cell;
}
#pragma mark GMGridViewActionDelegate
- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %d", position);
    [self setInitialIndex:position];
    if (self.delegate && [self.delegate respondsToSelector:@selector(categoryTab:didSelectTabAtIndex:)]) {
        [self.delegate categoryTab:self didSelectTabAtIndex:position];
    }
}

-(void)setItems:(NSMutableArray *)items{
    _items = items;
    if (_items.count == 0) {
        return;
    }
    _gridViewItemWidth = self.frame.size.width/_items.count - 1;
    _selectedImageView.frame = CGRectMake(0, self.frame.size.height - 2, _gridViewItemWidth + 1, 2);
    [self.gridView reloadData];
}

-(void)setInitialIndex:(NSInteger)initialIndex{
    
    _initialIndex = initialIndex;
    [self.gridView reloadData];
    _selectedImageView.frame = CGRectMake(initialIndex*(_gridViewItemWidth + 1), self.frame.size.height - 2, _gridViewItemWidth + 1, 2);
}

@end
