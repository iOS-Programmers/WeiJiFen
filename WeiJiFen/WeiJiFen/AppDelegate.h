//
//  AppDelegate.h
//  WeiJiFen
//
//  Created by Chemayi on 14/10/14.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFBaseTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, nonatomic) JFBaseTabBarController* mainTabViewController;

- (void)signIn;
- (void)signOut;

@end
