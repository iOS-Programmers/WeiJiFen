//
//  JFTabBarView.h
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFTabBarItemView.h"

@protocol JFTabBarDelegate;

@interface JFTabBarView : UIView <JFTabBarItemViewDelegate>

@property (nonatomic, assign) id<JFTabBarDelegate> delegate;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, assign) UInt32 initialIndex;
@end

@protocol JFTabBarDelegate <NSObject>
@optional
-(void)tabBar:(JFTabBarView *)aTabBar didSelectTabAtIndex:(NSUInteger)anIndex;
@end