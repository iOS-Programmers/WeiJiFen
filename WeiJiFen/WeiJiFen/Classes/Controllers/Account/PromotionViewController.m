//
//  PromotionViewController.m
//  WeiJiFen
//
//  Created by liguangjun on 14-11-29.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "PromotionViewController.h"
#import "LSAlertView.h"

@interface PromotionViewController ()

@property (strong, nonatomic) IBOutlet UIView *headView;
@end

@implementation PromotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"推广赚钱";
    self.tableView.tableHeaderView = self.headView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 31;
    
    [self.dataSource addObject:[NSString stringWithFormat:@"%@%@",WJF_URL_UID,[WeiJiFenEngine shareInstance].uid]];
    [self.dataSource addObject:[NSString stringWithFormat:@"%@%@",WJF_URL_USER,[WeiJiFenEngine shareInstance].userInfo.nickName]];
    
    [self.tableView reloadData];
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

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
    
}
static int label_tag = 102;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentfier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIColor *imgColor = UIColorRGB(221, 221, 221);
        UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:nil]];
        leftImageView.backgroundColor = imgColor;
        leftImageView.frame = CGRectMake(10, 0, 1, 21);
        [cell addSubview:leftImageView];
        
        UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:nil]];
        rightImageView.backgroundColor = imgColor;
        rightImageView.frame = CGRectMake(310, 0, 1, 21);
        rightImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [cell addSubview:rightImageView];
        
        UIImageView *topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:nil]];
        topImageView.backgroundColor = imgColor;
        topImageView.frame = CGRectMake(10, 0, cell.frame.size.width - 10*2, 1);
        [cell addSubview:topImageView];
        
        UIImageView *bottomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:nil]];
        bottomImageView.backgroundColor = imgColor;
        bottomImageView.frame = CGRectMake(10, 21, cell.frame.size.width - 10*2, 1);
        [cell addSubview:bottomImageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, cell.frame.size.width - 10*2, 21)];
//        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [LSCommonUtils getProgramMainHueColor];
        label.tag = label_tag;
        [cell addSubview:label];
        
    }
    
    UILabel *label = (UILabel *)[cell viewWithTag:label_tag];
    label.text = self.dataSource[indexPath.row];
    
    return cell;
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *contentText = self.dataSource[indexPath.row];
    NSString *message = [NSString stringWithFormat:@"将网址发布到QQ空间、论坛、QQ群、微博等地方，当好友通过该链接访问站点并注册新会员，即可获得推广奖励。\n\n%@",contentText];
    
    LSAlertView *alertView = [[LSAlertView alloc] initWithTitle:@"推广链接" message:message cancelButtonTitle:@"关闭" cancelBlock:^{
        
    } okButtonTitle:@"复制网址" okBlock:^{
        UIPasteboard *copyBoard = [UIPasteboard generalPasteboard];
        copyBoard.string = contentText;
        [copyBoard setPersistent:YES];
        
        LSAlertView *tureAlertView = [[LSAlertView alloc] initWithTitle:nil message:@"推广网址，已复制发到剪贴板" cancelButtonTitle:@"确定"];
        [tureAlertView show];
        
    }];
    [alertView show];
    
}

@end
