//
//  GainScoreViewController.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-14.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "GainScoreViewController.h"
#import "JFCategoryTabView.h"
#import "TaskCenterViewCell.h"
#import "JFLocalDataManager.h"
#import "JSONKit.h"
#import "WeiJiFenEngine.h"
#import "SVPullToRefresh.h"

@interface GainScoreViewController ()<UITableViewDataSource,UITableViewDelegate,JFCategoryTabViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *dataSourceMutDic;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) JFCategoryTabView *categoryTabView;

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation GainScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _dataSourceMutDic = [[NSMutableDictionary alloc] init];
    _dataSource = [[NSMutableArray alloc] init];
    _selectIndex = 0;
    
    [self refreshViewUI];
    [self refreshTaskCenterInfo];
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

#pragma mark -custom
- (void)refreshViewUI{
    if (_categoryTabView == nil) {
        
        _categoryTabView = [[JFCategoryTabView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        NSMutableArray *items = [NSMutableArray arrayWithObjects:@"任务中心",@"网站任务", nil];
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

-(NSMutableArray*)customDataSourceWithTabAtIndex:(NSInteger)anIndex isRefresh:(BOOL)isRefresh
{
    [_dataSource removeAllObjects];
    
    NSMutableArray *tmpMutArray = [_dataSourceMutDic objectForKey:[NSNumber numberWithInteger:_selectIndex]];
    if (tmpMutArray == nil){
        tmpMutArray = [NSMutableArray array];
    }
    if (tmpMutArray.count == 0){
        if (_selectIndex == 0) {
            [self refreshTaskCenterInfo];
        }else if (_selectIndex == 1){
            [self refreshWebTaskInfo];
        }
        [_dataSourceMutDic setObject:tmpMutArray forKey:[NSNumber numberWithInteger:_selectIndex]];
    }
    [_dataSource addObjectsFromArray:tmpMutArray];
    [self.tableView reloadData];
    
    return tmpMutArray;
}

- (void)refreshTaskCenterInfo{
    if (_selectIndex == 0) {
        
//        NSMutableArray *tmpMutArray = [_dataSourceMutDic objectForKey:[NSNumber numberWithInteger:_selectIndex]];
        NSMutableArray *tmpMutArray = [[NSMutableArray alloc] init];
        
        NSMutableArray *tmpTaskArray = [[JFLocalDataManager shareInstance] getTaskCenterData];
        for (NSDictionary *taskDic in tmpTaskArray) {
            JFTaskInfo *taskInfo = [[JFTaskInfo alloc] init];
            [taskInfo setTaskInfoByDic:taskDic];
            [tmpMutArray addObject:taskInfo];
        }
        [_dataSourceMutDic setObject:tmpMutArray forKey:[NSNumber numberWithInteger:_selectIndex]];
        
        if (_selectIndex == 0) {
            [_dataSource removeAllObjects];
            [_dataSource addObjectsFromArray:tmpMutArray];
        }
        [self.tableView reloadData];
        
    }
}

- (void)refreshWebTaskInfo{
    
    __weak GainScoreViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] getWebTaskInfoWithToken:[WeiJiFenEngine shareInstance].token confirm:[WeiJiFenEngine shareInstance].confirm page:1 pageSize:10 tag:tag];
    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
//            return;
        }
        
        NSMutableArray *tmpMutArray = [[NSMutableArray alloc] init];
        
        NSMutableArray *tmpTaskArray = [jsonRet objectForKey:@"data"];
//        NSMutableArray *tmpTaskArray = [[JFLocalDataManager shareInstance] getTaskCenterData];
        for (NSDictionary *taskDic in tmpTaskArray) {
            JFTaskInfo *taskInfo = [[JFTaskInfo alloc] init];
            [taskInfo setTaskInfoByDic:taskDic];
            [tmpMutArray addObject:taskInfo];
        }
        [weakSelf.dataSourceMutDic setObject:tmpMutArray forKey:[NSNumber numberWithInteger:1]];
        
        if (weakSelf.selectIndex == 1) {
            [weakSelf.dataSource removeAllObjects];
            [weakSelf.dataSource addObjectsFromArray:tmpMutArray];
        }
        [weakSelf.tableView reloadData];
        
    } tag:tag];
    
}

-(void)doApplyAction:(JFTaskInfo *)taskInfo{
    
    __weak GainScoreViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] doApplyWithTaskid:taskInfo.taskId tag:tag];
    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
            return;
        }
        
    } tag:tag];
    
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"TaskCenterViewCell";
    TaskCenterViewCell *cell = (TaskCenterViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        [cell.applyButton addTarget:self action:@selector(handleClickAt:event:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    cell.isWebTask = NO;
    if (_selectIndex == 1) {
        cell.isWebTask = YES;
    }
    JFTaskInfo *taskInfo = _dataSource[indexPath.row];
    cell.taskInfo = taskInfo;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
}

-(void)handleClickAt:(id)sender event:(id)event{
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    UITableView *tempTable = self.tableView;
    CGPoint currentTouchPosition = [touch locationInView:tempTable];
    NSIndexPath *indexPath = [tempTable indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil){
        NSLog(@"indexPath: row:%ld", indexPath.row);
        JFTaskInfo *taskInfo = _dataSource[indexPath.row];
        if (taskInfo.taskId.length != 0) {
            //do someSting
            [self doApplyAction:taskInfo];
        }
    }
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
