//
//  JFCategoryTabView.h
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-17.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFCategoryTabView : UIView

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, assign) NSInteger initialIndex;

-(void)initObject;
@end
