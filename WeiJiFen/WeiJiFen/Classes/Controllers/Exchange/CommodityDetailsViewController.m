//
//  CommodityDetailsViewController.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-22.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "CommodityDetailsViewController.h"
#import "AccountDetailsViewController.h"
#import "WeiJiFenEngine.h"
#import "JSONKit.h"

@interface CommodityDetailsViewController ()

-(IBAction)backAction:(id)sender;

@end

@implementation CommodityDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"物品详情";
    
    JFCommodityInfo *oldCommodity = _commodityInfo;
    _commodityInfo = [[JFCommodityInfo alloc] init];
    [_commodityInfo setCommodityInfoByDic:[oldCommodity.jsonString objectFromJSONString]];
    _commodityInfo.comId = oldCommodity.comId;
    
    
    [self refreshCommodityInfo];
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

- (void)refreshCommodityInfo{
    
    __weak CommodityDetailsViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] commodityShowWithToken:nil confirm:[WeiJiFenEngine shareInstance].confirm pId:self.commodityInfo.comId tag:tag];
    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
            return;
        }
        NSDictionary *comDic = [jsonRet objectForKey:@"data"];
        [weakSelf.commodityInfo setCommodityInfoByDic:comDic];
        
    } tag:tag];
}

@end
