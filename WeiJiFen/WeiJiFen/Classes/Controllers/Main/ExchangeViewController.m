//
//  ExchangeViewController.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-14.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "ExchangeViewController.h"
#import "WeiJiFenEngine.h"
#import "JSONKit.h"
#import "LSCommonUtils.h"
#import "JFCategoryTabView.h"
#import "JFLocalDataManager.h"
#import "CommodityViewCell.h"
#import "JFCommodityInfo.h"
#import "CommodityDetailsViewController.h"
#import "JFTopicInfo.h"
#import "TopicViewCell.h"
#import "TopicDetailsViewController.h"

@interface ExchangeViewController () <UITableViewDataSource,UITableViewDelegate,JFCategoryTabViewDelegate,MJRefreshBaseViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *dataSourceMutDic;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) JFCategoryTabView *categoryTabView;
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) MJRefreshHeaderView *header;
@property (nonatomic, strong) MJRefreshFooterView *footer;

@end

@implementation ExchangeViewController

-(void)logInRequest{
    
    NSString *password = @"123456";
    __weak ExchangeViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] logInUserInfo:@"wjf125" token:WeiJiFenEngine.userToken password:password confirm:@"79EF44D011ACB123CF6A918610EFC053" tag:tag];
//    [[WeiJiFenEngine shareInstance] logInUserInfo:@"wjf123" token:@"54477065e7c62" password:@"wjf5213344" confirm:@"4384CCFB0C21406F1533E46D1E2FDB5B" tag:tag];
    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
            return;
        }
        NSDictionary *dataDic = [jsonRet objectForKey:@"data"];
        JFUserInfo *userInfo = [[JFUserInfo alloc] init];
        [userInfo setUserInfoByJsonDic:dataDic];
        [WeiJiFenEngine shareInstance].userPassword = password;
        [[WeiJiFenEngine shareInstance] setUserInfo:userInfo];
        [[WeiJiFenEngine shareInstance] saveAccount];
        
        NSString *tokenStr = [jsonRet objectForKey:@"token"];
        if (!FBIsEmpty(tokenStr)) {
            [WeiJiFenEngine saveUserToken:tokenStr];
        }
        
    } tag:tag];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _dataSourceMutDic = [[NSMutableDictionary alloc] init];
    _dataSource = [[NSMutableArray alloc] init];
    _selectIndex = 0;
    
    [self refreshViewUI];
    [self refreshDataSource:0];
    //test
//    [self logInRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (UINavigationController *)navigationController{
//    if ([super navigationController]) {
//        return [super navigationController];
//    }
//    return self.tabBarController.navigationController;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -custom
- (void)refreshViewUI{
    if (_categoryTabView == nil) {
        
        _categoryTabView = [[JFCategoryTabView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        NSMutableArray *items = [NSMutableArray arrayWithObjects:@"全部",@"虚拟物品",@"事物物品",@"官方物品",@"帮助教程", nil];
        _categoryTabView.items = items;
        _categoryTabView.initialIndex = 0;
        _categoryTabView.delegate = self;
        [self.view addSubview:_categoryTabView];
        
        if (_dataSourceMutDic == nil ){
            _dataSourceMutDic = [[NSMutableDictionary alloc] init];
        }
        for (int index = 0; index < items.count; index ++){
            NSMutableArray *mutArray = [[NSMutableArray alloc] init];
            [_dataSourceMutDic setObject:mutArray forKey:[NSNumber numberWithInt:index]];
        }
    }
    
    UIEdgeInsets inset = self.tableView.contentInset;
    if (inset.top == 0) {
        inset.top += _categoryTabView.frame.size.height;
    }
    [self setContentInsetForScrollView:self.tableView inset:inset];
    
    //添加下拉刷新
//    if (!_header) {
//        _header = [[MJRefreshHeaderView alloc] init];
//        _header.delegate = self;
//        _header.scrollView = self.tableView;
//    }
//    if (!_footer) {
//        _footer = [[MJRefreshFooterView alloc] init];
//        _footer.delegate = self;
//        _footer.scrollView = self.tableView;
//    }
}

- (void)refreshDataSource:(int)type{
    
    int paramType = 0;
    if (type == 0) {
        paramType = 0;
    }else if (type == 1){
        paramType = 8;
    }else if (type == 2){
        paramType = 9;
    }else if (type == 3){
        paramType = 7;
    }
    __weak ExchangeViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] getCommodityListWithToken:WeiJiFenEngine.userToken confirm:[WeiJiFenEngine shareInstance].confirm type:paramType page:1 pageSize:10 tag:tag];
    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
            return;
        }
        
        NSMutableArray *tmpMutArray = [weakSelf.dataSourceMutDic objectForKey:[NSNumber numberWithInteger:weakSelf.selectIndex]];
        tmpMutArray = [[NSMutableArray alloc] init];
        
        NSMutableArray *tmpCommodityArray = [jsonRet objectForKey:@"data"];
        for (NSDictionary *comDic in tmpCommodityArray) {
            JFCommodityInfo *commodityInfo = [[JFCommodityInfo alloc] init];
            [commodityInfo setCommodityInfoByDic:comDic];
            [tmpMutArray addObject:commodityInfo];
        }
        [weakSelf.dataSourceMutDic setObject:tmpMutArray forKey:[NSNumber numberWithInteger:type]];
        
        if (weakSelf.selectIndex == type) {
            [weakSelf.dataSource removeAllObjects];
            [weakSelf.dataSource addObjectsFromArray:tmpMutArray];
            [weakSelf.tableView reloadData];
        }
        
    } tag:tag];
}

-(void)refreshHelpList{
    
    __weak ExchangeViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] getHelpListWithToken:WeiJiFenEngine.userToken confirm:[WeiJiFenEngine shareInstance].confirm fId:@"45" page:1 pageSize:10 tag:tag];
    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
            return;
        }
        
        NSMutableArray *tmpMutArray = [weakSelf.dataSourceMutDic objectForKey:[NSNumber numberWithInteger:(weakSelf.dataSourceMutDic.count - 1)]];
        tmpMutArray = [[NSMutableArray alloc] init];
        
        NSMutableArray *tmpTopicArray = [jsonRet objectForKey:@"data"];
        for (NSDictionary *topicDic in tmpTopicArray) {
            JFTopicInfo *topicInfo = [[JFTopicInfo alloc] init];
            [topicInfo setTopicInfoByDic:topicDic];
            [tmpMutArray addObject:topicInfo];
        }
        [weakSelf.dataSourceMutDic setObject:tmpMutArray forKey:[NSNumber numberWithInteger:(weakSelf.dataSourceMutDic.count - 1)]];
        
        if (weakSelf.selectIndex == (weakSelf.dataSourceMutDic.count - 1)) {
            [weakSelf.dataSource removeAllObjects];
            [weakSelf.dataSource addObjectsFromArray:tmpMutArray];
        }
        [weakSelf.tableView reloadData];
        
    } tag:tag];
}

-(NSMutableArray*)customDataSourceWithTabAtIndex:(NSInteger)anIndex isRefresh:(BOOL)isRefresh
{
    [_dataSource removeAllObjects];
    
    NSMutableArray *tmpMutArray = [_dataSourceMutDic objectForKey:[NSNumber numberWithInteger:_selectIndex]];
    if (tmpMutArray == nil){
        tmpMutArray = [NSMutableArray array];
    }
    if (tmpMutArray.count == 0){
        if (_selectIndex == 0) {
            [self refreshDataSource:0];
        }else if (_selectIndex == 1){
            [self refreshDataSource:1];
        }else if (_selectIndex == 2){
            [self refreshDataSource:2];
        }else if (_selectIndex == 3){
            [self refreshDataSource:3];
        }else if (_selectIndex == 4){
            [self refreshHelpList];
        }
        [_dataSourceMutDic setObject:tmpMutArray forKey:[NSNumber numberWithInteger:_selectIndex]];
    }
    [_dataSource addObjectsFromArray:tmpMutArray];
    [self.tableView reloadData];
    
    return tmpMutArray;
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectIndex == _dataSourceMutDic.count-1) {
        return 49;
    }
    return 76;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_selectIndex == _dataSourceMutDic.count-1) {
        static NSString *helpCellIdentifier = @"TopicViewCell";
        TopicViewCell *cell = (TopicViewCell *)[tableView dequeueReusableCellWithIdentifier:helpCellIdentifier];
        if (!cell) {
            NSArray* cells = [[NSBundle mainBundle] loadNibNamed:helpCellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        JFTopicInfo *topicInfo = self.dataSource[indexPath.row];
        cell.topicInfo = topicInfo;
        return cell;
    }
    
    static NSString *cellIdentifier = @"CommodityViewCell";
    CommodityViewCell *cell = (CommodityViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    JFCommodityInfo *commodityInfo = self.dataSource[indexPath.row];
    cell.commodityInfo = commodityInfo;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    
    if (_selectIndex == _dataSourceMutDic.count-1) {
        
        JFTopicInfo *topicInfo = self.dataSource[indexPath.row];
        
        TopicDetailsViewController *topicDetailsVc = [[TopicDetailsViewController alloc] init];
        topicDetailsVc.topicInfo = topicInfo;
        topicDetailsVc.isFromHelp = YES;
        topicDetailsVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:topicDetailsVc animated:YES];
        return;
    }
    
    JFCommodityInfo *commodityInfo = self.dataSource[indexPath.row];
    NSLog(@"commodityInfo.ID%@",commodityInfo.comId);
    CommodityDetailsViewController *commodityDetailsVc = [[CommodityDetailsViewController alloc] init];
    commodityDetailsVc.commodityInfo = commodityInfo;
    commodityDetailsVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commodityDetailsVc animated:YES];
//    [self.navigationController presentModalViewController:commodityDetailsVc animated:YES];
}

#pragma mark - JFCategoryTabViewDelegate
-(void)categoryTab:(JFCategoryTabView *)aTabBar didSelectTabAtIndex:(NSInteger)anIndex{
    
    if (_selectIndex == anIndex) {
        return;
    }
    _selectIndex = anIndex;
    
    [self customDataSourceWithTabAtIndex:anIndex isRefresh:NO];
    
    if (_selectIndex == _dataSourceMutDic.count-1){
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    [self.tableView reloadData];
}

#pragma mark 上下拉刷新的Delegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    //上拉刷新时的操作
    if (self.header == refreshView) {
//        [refreshView endRefreshing];
    }
    //下拉加载时的操作
    else {
        
    }
}

@end
