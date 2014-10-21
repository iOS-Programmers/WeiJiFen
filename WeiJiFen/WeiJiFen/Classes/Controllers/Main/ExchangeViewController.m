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

@interface ExchangeViewController () <UITableViewDataSource,UITableViewDelegate,JFCategoryTabViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *dataSourceMutDic;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) JFCategoryTabView *categoryTabView;

@property (nonatomic, assign) NSInteger selectIndex;
@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _dataSourceMutDic = [[NSMutableDictionary alloc] init];
    
    _dataSource = [[NSMutableArray alloc] init];
//    NSArray *tmpCommodityArray = [[JFLocalDataManager shareInstance] getLocalCommodityArray];
//    for (NSDictionary *comDic in tmpCommodityArray) {
//        JFCommodityInfo *commodityInfo = [[JFCommodityInfo alloc] init];
//        [commodityInfo setCommodityInfoByDic:comDic];
//        [_dataSource addObject:commodityInfo];
//    }
//    [self.tableView reloadData];
    
    [self refreshViewUI];
    [self refreshDataSource];
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

- (void)refreshViewUI{
    if (_categoryTabView == nil) {
        _categoryTabView = [[JFCategoryTabView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
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
}

- (void)refreshDataSource{
    
    __weak ExchangeViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] querySysUserInfo:@"10238" tag:tag];
    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
//            return;
        }
        
        NSMutableArray *tmpMutArray = [_dataSourceMutDic objectForKey:[NSNumber numberWithInteger:_selectIndex]];
        tmpMutArray = [[NSMutableArray alloc] init];
        
        NSMutableArray *tmpCommodityArray = [NSMutableArray arrayWithArray:[[JFLocalDataManager shareInstance] getLocalCommodityArray]];
        [tmpCommodityArray addObjectsFromArray:[[JFLocalDataManager shareInstance] getLocalCommodityArray2]];
        for (NSDictionary *comDic in tmpCommodityArray) {
            JFCommodityInfo *commodityInfo = [[JFCommodityInfo alloc] init];
            [commodityInfo setCommodityInfoByDic:comDic];
            [tmpMutArray addObject:commodityInfo];
        }
        [_dataSourceMutDic setObject:tmpMutArray forKey:[NSNumber numberWithInteger:0]];
        
        if (_selectIndex == 0) {
            [_dataSource addObjectsFromArray:tmpMutArray];
            [self.tableView reloadData];
        }
        
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
            [self refreshDataSource];
        }else if (_selectIndex == 1){
            NSMutableArray *tmpCommodityArray = [NSMutableArray arrayWithArray:[[JFLocalDataManager shareInstance] getLocalCommodityArray2]];
            for (NSDictionary *comDic in tmpCommodityArray) {
                JFCommodityInfo *commodityInfo = [[JFCommodityInfo alloc] init];
                [commodityInfo setCommodityInfoByDic:comDic];
                [tmpMutArray addObject:commodityInfo];
            }
        }else if (_selectIndex == 2){
            NSMutableArray *tmpCommodityArray = [NSMutableArray arrayWithArray:[[JFLocalDataManager shareInstance] getLocalCommodityArray2]];
            [tmpCommodityArray addObjectsFromArray:[[JFLocalDataManager shareInstance] getLocalCommodityArray]];
            for (NSDictionary *comDic in tmpCommodityArray) {
                JFCommodityInfo *commodityInfo = [[JFCommodityInfo alloc] init];
                [commodityInfo setCommodityInfoByDic:comDic];
                [tmpMutArray addObject:commodityInfo];
            }
        }else if (_selectIndex == 3){
            NSMutableArray *tmpCommodityArray = [NSMutableArray arrayWithArray:[[JFLocalDataManager shareInstance] getLocalCommodityArray]];
            for (NSDictionary *comDic in tmpCommodityArray) {
                JFCommodityInfo *commodityInfo = [[JFCommodityInfo alloc] init];
                [commodityInfo setCommodityInfoByDic:comDic];
                [tmpMutArray addObject:commodityInfo];
            }
        }else if (_selectIndex == 4){
            
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
    return 76;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"CommodityViewCell";
    CommodityViewCell *cell = (CommodityViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    JFCommodityInfo *commodityInfo = self.dataSource[indexPath.row];
    cell.commodityInfo = commodityInfo;
    
    return cell;
}

#pragma mark - JFCategoryTabViewDelegate
-(void)categoryTab:(JFCategoryTabView *)aTabBar didSelectTabAtIndex:(NSInteger)anIndex{
    
    if (_selectIndex == anIndex) {
        return;
    }
    _selectIndex = anIndex;
    
    [self customDataSourceWithTabAtIndex:anIndex isRefresh:NO];
    
    [self.tableView reloadData];
}

@end
