//
//  JFBaseTabBarController.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-14.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "JFBaseTabBarController.h"
#import "LSCommonUtils.h"
#import "JFTabBarView.h"
#import "JFTabBarItemView.h"
#import "LSCommonUtils.h"

#define ITEMS_COUNT 4

@interface JFBaseTabBarController () <JFTabBarDelegate>

@property (nonatomic,strong) JFTabBarView *customTabBarView;

@end

@implementation JFBaseTabBarController

//这个方法会导致导航pop时没有动画 原因待查
//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideExistingTabBar];
}

- (void)hideExistingTabBar
{
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [self addCustomTabBar:view];
            break;
        }
    }
}
-(void)addCustomTabBar:(UIView*)view{
    CGRect tabBarFrame = self.tabBar.frame;
    tabBarFrame.origin.x = 0;
    tabBarFrame.origin.y = 0;
    self.customTabBarView = [[JFTabBarView alloc] initWithFrame:tabBarFrame];
    self.customTabBarView.backgroundColor = [LSCommonUtils getProgramMainHueColor];
    self.customTabBarView.initialIndex = 0;
    self.customTabBarView.delegate = self;
    [view addSubview:self.customTabBarView];
    
    NSMutableArray *controllerTabs = [NSMutableArray arrayWithCapacity:ITEMS_COUNT];
    
    for (int index = 0; index < ITEMS_COUNT ; index ++ ) {
        JFTabBarItemView *tabItem = [LSCommonUtils loadViewFromNibNamed:@"JFTabBarItemView"];
        if (index == 0) {
            tabItem.itemImageView.image = [UIImage imageNamed:@"jf_tab_exchange"];
            tabItem.itemLabel.text = @"兑换";
        }else if (index == 1){
            tabItem.itemImageView.image = [UIImage imageNamed:@"jf_tab_gainscore"];
            tabItem.itemLabel.text = @"赚分";
        }else if (index == 2){
            tabItem.itemImageView.image = [UIImage imageNamed:@"jf_tab_community"];
            tabItem.itemLabel.text = @"社区";
        }else if (index == 3){
            tabItem.itemImageView.image = [UIImage imageNamed:@"jf_tab_account"];
            tabItem.itemLabel.text = @"账户";
        }
        
        [controllerTabs addObject:tabItem];
    }
    self.customTabBarView.items = controllerTabs;
}

#pragma mark - JFTabBarDelegate
-(void)tabBar:(JFTabBarView *)aTabBar didSelectTabAtIndex:(NSUInteger)anIndex{
    self.selectedIndex = anIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

@end
