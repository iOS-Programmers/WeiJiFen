//
//  CommodityDetailsViewController.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-22.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "CommodityDetailsViewController.h"
#import "AccountDetailsViewController.h"

@interface CommodityDetailsViewController ()

-(IBAction)backAction:(id)sender;

@end

@implementation CommodityDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"物品详情";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backAction:(id)sender{
//    [self.navigationController popViewControllerAnimated:YES];
    AccountDetailsViewController *accountDetailsVc = [[AccountDetailsViewController alloc] init];
    [self.navigationController pushViewController:accountDetailsVc animated:YES];
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
