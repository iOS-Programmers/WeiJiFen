//
//  JFCategoryTabView.h
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-17.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JFCategoryTabViewDelegate;

@interface JFCategoryTabView : UIView

@property (nonatomic, assign) id<JFCategoryTabViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, assign) NSInteger initialIndex;

-(void)initObject;
@end

@protocol JFCategoryTabViewDelegate <NSObject>
@optional
-(void)categoryTab:(JFCategoryTabView *)aTabBar didSelectTabAtIndex:(NSInteger)anIndex;
@end