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
#import "LoginViewController.h"
//
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
//    if ([[WeiJiFenEngine shareInstance] hasAccoutLoggedin]) {
//        [self signIn];
//    }else{
//        NSLog(@"signOut for accout miss");
//        [self signOut];
//    }
    [self signIn];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)signIn{
    NSLog(@"signIn");
    
    //Exchange
    ExchangeViewController *exchangeViewController = [[ExchangeViewController alloc] init];
    exchangeViewController.title = @"微积分";
//    exchangeViewController.tabBarItem.image = [UIImage imageNamed:@"jf_tab_exchange"];
    JFBaseNavigationController *exchangeNav = [[JFBaseNavigationController alloc] initWithRootViewController:exchangeViewController];
    
    //GainScore
    GainScoreViewController *gainScoreViewController = [[GainScoreViewController alloc] init];
    gainScoreViewController.title = @"赚分";
//    gainScoreViewController.tabBarItem.image = [UIImage imageNamed:@"jf_tab_gainscore"];
    JFBaseNavigationController *gainScoreNav = [[JFBaseNavigationController alloc] initWithRootViewController:gainScoreViewController];
    
    //Community
    CommunityViewController *communityViewController = [[CommunityViewController alloc] init];
    communityViewController.title = @"社区";
//    communityViewController.tabBarItem.image = [UIImage imageNamed:@"jf_tab_community"];
    JFBaseNavigationController *communityNav = [[JFBaseNavigationController alloc] initWithRootViewController:communityViewController];
    
    //Mine
    AccountViewController *accountViewController = [[AccountViewController alloc] init];
    accountViewController.title = @"我的账号";
//    accountViewController.tabBarItem.image = [UIImage imageNamed:@"jf_tab_account"];
    JFBaseNavigationController *accountNav = [[JFBaseNavigationController alloc] initWithRootViewController:accountViewController];
    
    //tabBar
    JFBaseTabBarController *rootTabBarController = [[JFBaseTabBarController alloc] init];
    rootTabBarController.viewControllers = @[exchangeNav,gainScoreNav,communityNav,accountNav];
    [rootTabBarController setSelectedIndex:0];
    _mainTabViewController = rootTabBarController;
    
//    JFBaseNavigationController* tabNavVc = [[JFBaseNavigationController alloc] initWithRootViewController:rootTabBarController];
    
    UIColor *color = UIColorRGB(254,120,31);
//    [rootTabBarController.tabBar setSelectedImageTintColor:color];
    
    if (CURRENT_SYS_VERSION >= 7.0) {
        [[UINavigationBar appearance] setBarTintColor:color];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    } else {
        [[UINavigationBar appearance] setTintColor:color];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    }
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:17], NSFontAttributeName, nil]];
    
    self.window.rootViewController = rootTabBarController;
    
}

- (void)signOut{
    NSLog(@"signOut");
    
    [[WeiJiFenEngine shareInstance] logout];
    _mainTabViewController = nil;
    
//    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
//    //547c320b6c7be 547c33b155cf4
//    [[WeiJiFenEngine shareInstance] registerUserInfo:@"wjf100001" mobile:@"13511111121" password:@"123456" confirm:WJF_Confirm tag:tag];
//    
//    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
//        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
//        if (!jsonRet || errorMsg) {
//            [LSCommonUtils showWarningTip:errorMsg At:self.window];
//            return;
//        }
//        
//    } tag:tag];
    
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    JFBaseNavigationController* navigationController = [[JFBaseNavigationController alloc] initWithRootViewController:loginViewController];
    navigationController.navigationBarHidden = YES;
    UIColor *color = UIColorRGB(254,120,31);
    if (CURRENT_SYS_VERSION >= 7.0) {
        [[UINavigationBar appearance] setBarTintColor:color];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    } else {
        [[UINavigationBar appearance] setTintColor:color];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    }
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:17], NSFontAttributeName, nil]];
    
    self.window.rootViewController = navigationController;
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
