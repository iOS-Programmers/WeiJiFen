//
//  FriendListController.m
//  WeiJiFen
//
//  Created by Jyh on 14/11/28.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "FriendListController.h"

@interface FriendListController ()

@end

@implementation FriendListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"好友列表";
    
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentfier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
        UIImageView *topBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
        topBg.backgroundColor = [LSCommonUtils colorWithHexString:@"eeeeee"];
        [cell.contentView addSubview:topBg];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"avatar.png"];
    
    BOOL isOnLine;
    if (isOnLine) {
        cell.textLabel.textColor = [LSCommonUtils colorWithHexString:@"fd7a20"];
    }
    else {
        cell.textLabel.textColor = [LSCommonUtils colorWithHexString:@"686868"];
    }
    
    cell.textLabel.text = @"董家大小姐";
    
    cell.detailTextLabel.textColor = [LSCommonUtils colorWithHexString:@"949494"];
    cell.detailTextLabel.text = @"【离线】";
    
    
    return cell;
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark 上下拉刷新的Delegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    //上拉刷新时的操作
    if (self.header == refreshView) {
        
    }
    //下拉加载时的操作
    else {
        
    }
}


@end
