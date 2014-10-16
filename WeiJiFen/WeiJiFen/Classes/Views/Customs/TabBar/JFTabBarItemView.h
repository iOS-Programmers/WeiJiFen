//
//  JFTabBarItemView.h
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JFTabBarItemViewDelegate;

@interface JFTabBarItemView : UIView

@property (nonatomic, strong) IBOutlet UIButton *itemBtn;
@property (nonatomic, strong) IBOutlet UIImageView *itemImageView;
@property (nonatomic, strong) IBOutlet UILabel *itemLabel;
@property (nonatomic, assign) bool selected;

@property(nonatomic,assign) id<JFTabBarItemViewDelegate> delegate;
@end

@protocol JFTabBarItemViewDelegate <NSObject>

- (void)selectForItemView:(id)view;
@end