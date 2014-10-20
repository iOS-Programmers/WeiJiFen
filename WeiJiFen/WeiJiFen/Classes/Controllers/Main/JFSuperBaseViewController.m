//
//  JFSuperBaseViewController.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "JFSuperBaseViewController.h"

#define LS_Default_TitleNavBar_Height 44

@interface JFSuperBaseViewController ()

@end

@implementation JFSuperBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self resetSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)resetSubViews{
    for (UIView *subview in [self.view subviews]) {
        //如果view是tableview或其子view的时候设置contentInset
        if ([subview isKindOfClass:[UIScrollView class]]){
//            [self setContentInsetForScrollView:((UIScrollView *)subview)];
            
            CGRect tableViewFrame = [UIScreen mainScreen].applicationFrame;
            tableViewFrame.origin.y = 0;
            tableViewFrame.size.height -= (self.navigationController.viewControllers.count > 1 ?(CGRectGetHeight(self.navigationController.navigationBar.bounds)) : (CGRectGetHeight(self.tabBarController.tabBar.bounds))) + (CGRectGetHeight(self.navigationController.navigationBar.bounds));
            UIScrollView *tableView = (UIScrollView *)subview;
            tableView.frame = tableViewFrame;
        }
    }
}

//设置tableview的contentInset
-(void) setContentInsetForScrollView:(UIScrollView *) scrollview
{
    if (![scrollview isKindOfClass:[UIScrollView class]]) {
        return;
    }
    
    CGFloat topInset = 0;
    topInset = LS_Default_TitleNavBar_Height;
    if ([LSCommonUtils isUpperSDK]) {
        topInset += 20;
    }
    UIEdgeInsets inset = UIEdgeInsetsMake(topInset, 0, 0, 0);
    
    [self setContentInsetForScrollView:scrollview inset:inset];
}
-(void) setContentInsetForScrollView:(UIScrollView *) scrollview inset:(UIEdgeInsets) inset
{
    if (![scrollview isKindOfClass:[UIScrollView class]]) {
        return;
    }
    [scrollview setContentInset:inset];
    [scrollview setScrollIndicatorInsets:inset];
}

@end
