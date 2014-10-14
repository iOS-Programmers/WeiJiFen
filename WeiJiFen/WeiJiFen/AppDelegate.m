//
//  AppDelegate.m
//  WeiJiFen
//
//  Created by Chemayi on 14/10/14.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "AppDelegate.h"
#import "JFBaseTabBarController.h"
#import "JFBaseNavigationController.h"
#import "ExchangeViewController.h"
#import "GainScoreViewController.h"
#import "CommunityViewController.h"
#import "AccountViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    //Exchange
    ExchangeViewController *exchangeViewController = [[ExchangeViewController alloc] init];
    exchangeViewController.title = @"兑换";
    exchangeViewController.tabBarItem.image = [UIImage imageNamed:@"jf_tab_exchange"];
    JFBaseNavigationController *exchangeNav = [[JFBaseNavigationController alloc] initWithRootViewController:exchangeViewController];
    
    //GainScore
    GainScoreViewController *gainScoreViewController = [[GainScoreViewController alloc] init];
    gainScoreViewController.title = @"赚分";
    gainScoreViewController.tabBarItem.image = [UIImage imageNamed:@"jf_tab_gainscore"];
    JFBaseNavigationController *gainScoreNav = [[JFBaseNavigationController alloc] initWithRootViewController:gainScoreViewController];
    
    //Community
    CommunityViewController *communityViewController = [[CommunityViewController alloc] init];
    communityViewController.title = @"社区";
    communityViewController.tabBarItem.image = [UIImage imageNamed:@"jf_tab_community"];
    JFBaseNavigationController *communityNav = [[JFBaseNavigationController alloc] initWithRootViewController:communityViewController];
    
    //Mine
    AccountViewController *accountViewController = [[AccountViewController alloc] init];
    accountViewController.title = @"账户";
    accountViewController.tabBarItem.image = [UIImage imageNamed:@"jf_tab_account"];
    JFBaseNavigationController *accountNav = [[JFBaseNavigationController alloc] initWithRootViewController:accountViewController];
    
    //tabBar
    JFBaseTabBarController *rootTabBarController = [[JFBaseTabBarController alloc] init];
    rootTabBarController.viewControllers = @[exchangeNav,gainScoreNav,communityNav,accountNav];
    [rootTabBarController setSelectedIndex:0];
    
    UIColor *color = UIColorRGB(253,90,36);
    [rootTabBarController.tabBar setSelectedImageTintColor:[UIColor whiteColor]];
    [rootTabBarController.tabBar setBackgroundColor:color];
    
    [[UINavigationBar appearance] setBarTintColor:color];
//    [[UINavigationBar appearance] setTintColor:[UIColor yellowColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:17], NSFontAttributeName, nil]];
    
    self.window.rootViewController = rootTabBarController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
