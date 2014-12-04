//
//  CommunityViewController.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-14.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "CommunityViewController.h"
#import "JFCategoryTabView.h"
#import "WeiJiFenEngine.h"
#import "JFTopicInfo.h"
#import "TopicViewCell.h"
#import "TopicDetailsViewController.h"
#import "SVPullToRefresh.h"
#import "JFInputWindow.h"
#import "PersonalProfileViewController.h"

@interface CommunityViewController ()<UITableViewDataSource,UITableViewDelegate,JFCategoryTabViewDelegate,JFInputWindowDelegate>
{
    JFInputWindow *_inputSheet;
}

@property (nonatomic, strong) NSMutableDictionary *dataSourceMutDic;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) JFCategoryTabView *categoryTabView;
@property (nonatomic, strong) IBOutlet UIButton *publishButton;
@property (nonatomic, strong) IBOutlet UIView *myCommunityNoTipView;

@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) int nextPage;

- (IBAction)publishTopicAction:(id)sender;

@end

@implementation CommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _dataSourceMutDic = [[NSMutableDictionary alloc] init];
    _dataSource = [[NSMutableArray alloc] init];
    _selectIndex = 0;
    self.nextPage = 1;
    [self refreshTipView];
    
    [self refreshViewUI];
    [self refreshTopicInfo:0];
    
    __weak CommunityViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        if (!weakSelf) {
            return;
        }
        
        if (weakSelf.nextPage == -1 ) {
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            weakSelf.tableView.showsInfiniteScrolling = NO;
            return;
        }
        
        NSInteger type = weakSelf.selectIndex;
        NSString *fID = @"2";
        if (type == 0) {
            fID = @"2";//交流
        }else if (type == 1){
            fID = @"66";//晒单
        }
        int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
        [[WeiJiFenEngine shareInstance] getHelpListWithToken:WeiJiFenEngine.userToken confirm:[WeiJiFenEngine shareInstance].confirm fId:fID page:weakSelf.nextPage pageSize:10 tag:tag];
        [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
            if (!weakSelf) {
                return;
            }
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            
            NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
            if (!jsonRet || errorMsg) {
                [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
                return;
            }
            
            NSMutableArray *tmpMutArray = [NSMutableArray arrayWithArray:[weakSelf.dataSourceMutDic objectForKey:[NSNumber numberWithInteger:weakSelf.selectIndex]]];
            NSMutableArray *tmpTopicArray = (NSMutableArray *)[jsonRet arrayObjectForKey:@"data"];
            for (NSDictionary *topicDic in tmpTopicArray) {
                JFTopicInfo *topicInfo = [[JFTopicInfo alloc] init];
                [topicInfo setTopicInfoByDic:topicDic];
                [tmpMutArray addObject:topicInfo];
            }
            [weakSelf.dataSourceMutDic setObject:tmpMutArray forKey:[NSNumber numberWithInteger:type]];
            
            if (weakSelf.selectIndex == type) {
                [weakSelf.dataSource removeAllObjects];
                [weakSelf.dataSource addObjectsFromArray:tmpMutArray];
            }
            [weakSelf.tableView reloadData];
            
            if (type == 0) {
                if (!tmpTopicArray || tmpTopicArray.count == 0) {
                    weakSelf.nextPage = -1;
                    weakSelf.tableView.showsInfiniteScrolling = NO;
                }else{
                    weakSelf.nextPage ++;
                    weakSelf.tableView.showsInfiniteScrolling = YES;
                }
            }
            
        } tag:tag];
        
    }];
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
- (IBAction)publishTopicAction:(id)sender {
    
    _inputSheet = [[[NSBundle mainBundle] loadNibNamed:@"JFInputWindow" owner:nil options:nil] objectAtIndex:0];
    if (_selectIndex == 1) {
        _inputSheet.title = @"我也晒单";
    }else if (_selectIndex == 2){
        _inputSheet.title = @"发表新帖";
    }
    _inputSheet.delegate = self;
    _inputSheet.inputType = InputType_Title;
    [self.view addSubview:_inputSheet];
    [_inputSheet loadInputView];
}

- (void)refreshTipView{
    
    if (_selectIndex == 0) {
        self.publishButton.hidden = YES;
        if (self.myCommunityNoTipView.superview) {
            [self.myCommunityNoTipView removeFromSuperview];
        }
        
        self.tableView.showsInfiniteScrolling = YES;
        
    }else if (_selectIndex == 1){
        self.publishButton.hidden = NO;
        [self.publishButton setTitle:@" 我要晒单" forState:UIControlStateNormal];
        if (self.myCommunityNoTipView.superview) {
            [self.myCommunityNoTipView removeFromSuperview];
        }
        
        [self.tableView.infiniteScrollingView stopAnimating];
        self.tableView.showsInfiniteScrolling = NO;
        
    }else if (_selectIndex == 2){
        self.publishButton.hidden = NO;
        [self.publishButton setTitle:@" 发表新帖" forState:UIControlStateNormal];
        
        NSMutableArray *tmpMutArray = [_dataSourceMutDic objectForKey:[NSNumber numberWithInteger:_selectIndex]];
        if (tmpMutArray && tmpMutArray.count == 0) {
            
            if (!self.myCommunityNoTipView.superview) {
                CGRect frame = self.myCommunityNoTipView.frame;
                frame.origin.y = 120;
                self.myCommunityNoTipView.frame = frame;
                [self.view addSubview:self.myCommunityNoTipView];
            }
            
        }else{
            [self.myCommunityNoTipView removeFromSuperview];
        }
        
        [self.tableView.infiniteScrollingView stopAnimating];
        self.tableView.showsInfiniteScrolling = NO;
    }
}

- (void)refreshViewUI{
    if (_categoryTabView == nil) {
        
        _categoryTabView = [[JFCategoryTabView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        NSMutableArray *items = [NSMutableArray arrayWithObjects:@"交流",@"晒单",@"我的", nil];
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
            [self refreshTopicInfo:0];
        }else if (_selectIndex == 1){
            [self refreshTopicInfo:1];
        }else if (_selectIndex == 2){
            [self refreshMyCommunityInfo];
        }
        [_dataSourceMutDic setObject:tmpMutArray forKey:[NSNumber numberWithInteger:_selectIndex]];
    }
    [_dataSource addObjectsFromArray:tmpMutArray];
    [self.tableView reloadData];
    
    return tmpMutArray;
}

-(void)refreshTopicInfo:(int)type{
    
    NSString *fID = @"2";
    if (type == 0) {
        fID = @"2";//交流
    }else if (type == 1){
        fID = @"66";//晒单
    }
    __weak CommunityViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] getHelpListWithToken:WeiJiFenEngine.userToken confirm:[WeiJiFenEngine shareInstance].confirm fId:fID page:1 pageSize:10 tag:tag];
    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
            return;
        }
        
        NSMutableArray *tmpMutArray = [_dataSourceMutDic objectForKey:[NSNumber numberWithInteger:weakSelf.selectIndex]];
        tmpMutArray = [[NSMutableArray alloc] init];
        
        NSMutableArray *tmpTopicArray = (NSMutableArray *)[jsonRet arrayObjectForKey:@"data"];
        for (NSDictionary *topicDic in tmpTopicArray) {
            JFTopicInfo *topicInfo = [[JFTopicInfo alloc] init];
            [topicInfo setTopicInfoByDic:topicDic];
            [tmpMutArray addObject:topicInfo];
        }
        [weakSelf.dataSourceMutDic setObject:tmpMutArray forKey:[NSNumber numberWithInteger:type]];
        
        if (weakSelf.selectIndex == type) {
            [weakSelf.dataSource removeAllObjects];
            [weakSelf.dataSource addObjectsFromArray:tmpMutArray];
        }
        [weakSelf.tableView reloadData];
        
        if (type == 0) {
            if (!tmpTopicArray || tmpTopicArray.count == 0) {
                weakSelf.tableView.showsInfiniteScrolling = NO;
            }else{
                weakSelf.nextPage ++;
                weakSelf.tableView.showsInfiniteScrolling = YES;
            }
        }
        
    } tag:tag];
    
}
-(void)refreshMyCommunityInfo{
    
    __weak CommunityViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] getMyCommunityWithToken:WeiJiFenEngine.userToken confirm:[WeiJiFenEngine shareInstance].confirm page:1 pageSize:10 tag:tag];
    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
            return;
        }
        
//        NSMutableArray *tmpMutArray = [_dataSourceMutDic objectForKey:[NSNumber numberWithInteger:(_dataSourceMutDic.count - 1)]];
        NSMutableArray *tmpMutArray = [[NSMutableArray alloc] init];
        
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
        [weakSelf refreshTipView];
        
    } tag:tag];
}

-(void)publishNewThreadTitle:(NSString *)title message:(NSString *)message{
    
    NSString *fID = @"2";
    if (_selectIndex == 2) {
        fID = @"2";//交流
    }else if (_selectIndex == 1){
        fID = @"66";//晒单
    }
    __weak CommunityViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] publishNewThreadWithFid:fID title:title message:message tag:tag];
    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
            return;
        }
        
        [LSCommonUtils showWarningTip:@"发表成功！" At:weakSelf.view];
        if (_selectIndex == 2) {
            [weakSelf refreshMyCommunityInfo];
        }else if (_selectIndex == 1){
            [weakSelf refreshTopicInfo:1];
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
    return 49;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *helpCellIdentifier = @"TopicViewCell";
    TopicViewCell *cell = (TopicViewCell *)[tableView dequeueReusableCellWithIdentifier:helpCellIdentifier];
    if (!cell) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:helpCellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.userAvatar addTarget:self action:@selector(handleClickAt:event:) forControlEvents:UIControlEventTouchUpInside];
    }
    JFTopicInfo *topicInfo = self.dataSource[indexPath.row];
    cell.topicInfo = topicInfo;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    
    JFTopicInfo *topicInfo = self.dataSource[indexPath.row];
    TopicDetailsViewController *topicDetailsVc = [[TopicDetailsViewController alloc] init];
    topicDetailsVc.topicInfo = topicInfo;
    topicDetailsVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:topicDetailsVc animated:YES];
}

-(void)handleClickAt:(id)sender event:(id)event{
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    UITableView *tempTable = self.tableView;
    CGPoint currentTouchPosition = [touch locationInView:tempTable];
    NSIndexPath *indexPath = [tempTable indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil){
        NSLog(@"indexPath: row:%ld", indexPath.row);
        
        if (_selectIndex == 0 || _selectIndex == 1) {
            return;
        }
        JFTopicInfo *topicInfo = self.dataSource[indexPath.row];
        JFUserInfo *userInfo = [[JFUserInfo alloc] init];
        userInfo.uid = topicInfo.authorId;
        
        PersonalProfileViewController *vc = [[PersonalProfileViewController alloc] init];
        vc.userInfo = userInfo;
        vc.userId = topicInfo.authorId;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - JFCategoryTabViewDelegate
-(void)categoryTab:(JFCategoryTabView *)aTabBar didSelectTabAtIndex:(NSInteger)anIndex{
    
    if (_selectIndex == anIndex) {
        return;
    }
    _selectIndex = anIndex;
    
    [self refreshTipView];
    
    [self customDataSourceWithTabAtIndex:anIndex isRefresh:NO];
    [self.tableView reloadData];
}

#pragma mark -  JFInputWindowDelegate
-(void)publishActionWithJFInputWindow:(JFInputWindow *)inputView title:(NSString *)title content:(NSString *)content{
    
    [self publishNewThreadTitle:title message:content];
}
@end
