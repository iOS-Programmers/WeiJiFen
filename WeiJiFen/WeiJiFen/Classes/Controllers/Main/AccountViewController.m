//
//  AccountViewController.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-14.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "AccountViewController.h"
#import "AccountDetailsViewController.h"

@interface AccountViewController ()

-(IBAction)myAccountAction:(id)sender;

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

#pragma mark - IBAction
-(IBAction)myAccountAction:(id)sender{
    AccountDetailsViewController *accountDetailsVc = [[AccountDetailsViewController alloc] init];
    accountDetailsVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:accountDetailsVc animated:YES];
    
}

@end
