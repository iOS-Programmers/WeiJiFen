//
//  FriendListController.m
//  WeiJiFen
//
//  Created by Jyh on 14/11/28.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "FriendListController.h"
#import "JFFriendList.h"


@interface FriendListController ()

@end

@implementation FriendListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"好友列表";
    
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self loadDataSource];
}

- (void)loadDataSource
{
    __weak FriendListController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] getFriendListWithTag:tag];
    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
            //            return;
        }
        
        //        NSMutableArray *tmpMutArray = [_dataSourceMutDic objectForKey:[NSNumber numberWithInteger:(_dataSourceMutDic.count - 1)]];
//        NSMutableArray *tmpMutArray = [[NSMutableArray alloc] init];
        
        
        NSMutableArray *tmpFriendArray = [jsonRet objectForKey:@"data"];
        
        for (NSDictionary* commentDic in tmpFriendArray) {
            JFFriendList* commentnfo = [[JFFriendList alloc] init];
            [commentnfo setFriendListInfoByDic:commentDic];
            [weakSelf.dataSource addObject:commentnfo];
        }
        
        /**
         *  这里去加载好友信息
         */
        
        [weakSelf.tableView reloadData];

        
    } tag:tag];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
    
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
    
    JFFriendList *info = self.dataSource[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:info.avatar]];
    
    cell.imageView.image = [UIImage imageNamed:@"avatar.png"];
    

    if ([info.state isEqualToString:@"1"]) {
        cell.textLabel.textColor = [LSCommonUtils colorWithHexString:@"fd7a20"];
        
        cell.detailTextLabel.text = @"【在线】";
    }
    else {
        cell.textLabel.textColor = [LSCommonUtils colorWithHexString:@"686868"];
        
        cell.detailTextLabel.text = @"【离线】";
    }
    
    cell.textLabel.text = info.fusername;
    
    cell.detailTextLabel.textColor = [LSCommonUtils colorWithHexString:@"949494"];
    
    
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
