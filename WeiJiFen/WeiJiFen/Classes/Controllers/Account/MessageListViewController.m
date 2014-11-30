//
//  MessageListViewController.m
//  WeiJiFen
//
//  Created by liguangjun on 14-11-28.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "MessageListViewController.h"
#import "JFCategoryTabView.h"
#import "WeiJiFenEngine.h"
#import "TaskCenterViewCell.h"
#import "JFTaskInfo.h"
#import "JFMessageInfo.h"
#import "JFLocalDataManager.h"
#import "ChatViewController.h"

#define CATEGORY_TAB_INDEX_0 0
#define CATEGORY_TAB_INDEX_1 1

@interface MessageListViewController ()<UITableViewDataSource,UITableViewDelegate,JFCategoryTabViewDelegate>

@property (nonatomic, strong) NSMutableArray *userMessageInfos;
@property (nonatomic, strong) NSMutableArray *systemMessageInfos;
@property (nonatomic, strong) IBOutlet UITableView *userTableView;
@property (nonatomic, strong) IBOutlet UITableView *systemTableView;
@property (nonatomic, strong) JFCategoryTabView *categoryTabView;
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, assign) int systemNextPage;

@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的消息";
    
    _userMessageInfos = [[NSMutableArray alloc] init];
    _systemMessageInfos = [[NSMutableArray alloc] init];
    _selectIndex = CATEGORY_TAB_INDEX_0;
    [self selectCategoryTabAtIndex:_selectIndex needRefresh:NO];
    
    [self refreshViewUI];
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

#pragma mark - request
-(void)refreshUserMessagesInfo{
    
    __weak MessageListViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] getUserMessagesWithToken:[WeiJiFenEngine shareInstance].token confirm:[WeiJiFenEngine shareInstance].confirm tag:tag];
    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
            return;
        }
        
        weakSelf.userMessageInfos = [[NSMutableArray alloc] init];
        
        NSDictionary *TmpMsgArray = [jsonRet dictionaryObjectForKey:@"data"];
//        NSDictionary *TmpMsgArray = [[JFLocalDataManager shareInstance] getTESTuserMsg];
        [TmpMsgArray enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            JFMessageInfo *messageInfo = [[JFMessageInfo alloc] init];
            [messageInfo setMessageInfoByDic:(NSDictionary *)obj];
            [weakSelf.userMessageInfos addObject:messageInfo];
        }];
        
        [weakSelf.userTableView reloadData];
        
    } tag:tag];
    
}
-(void)refreshSystemMessagesInfo{
    
    __weak MessageListViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] getSystemMessagesWithToken:[WeiJiFenEngine shareInstance].token confirm:[WeiJiFenEngine shareInstance].confirm page:1 pageSize:10 tag:tag];
    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
            return;
        }
        
        weakSelf.systemMessageInfos = [[NSMutableArray alloc] init];
        
        NSArray *TmpMsgArray = [jsonRet arrayObjectForKey:@"data"];
//        NSArray *TmpMsgArray = [[JFLocalDataManager shareInstance] getTESTSystemMsg];
        for (NSDictionary *dic in TmpMsgArray) {
            JFMessageInfo *msgInfo = [[JFMessageInfo alloc] init];
            [msgInfo setSystemMsgInfoByDic:dic];
            msgInfo.userName = @"微积分";
            [weakSelf.systemMessageInfos addObject:msgInfo];
        }
        
//        if (!TmpMsgArray || TmpMsgArray.count == 0) {
//            weakSelf.systemTableView.showsInfiniteScrolling = NO;
//        }else{
//            weakSelf.nextPage ++;
//            weakSelf.tableView.showsInfiniteScrolling = YES;
//        }
        
        [weakSelf.systemTableView reloadData];
        
    } tag:tag];
}

#pragma mark - custom
- (void)refreshViewUI{
    if (_categoryTabView == nil) {
        
        _categoryTabView = [[JFCategoryTabView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        NSMutableArray *items = [NSMutableArray arrayWithObjects:@"用户消息",@"系统消息", nil];
        _categoryTabView.items = items;
        _categoryTabView.initialIndex = 0;
        _categoryTabView.delegate = self;
        [self.view addSubview:_categoryTabView];
        
    }
    
    UIEdgeInsets inset = self.userTableView.contentInset;
    if (inset.top == 0) {
        inset.top += _categoryTabView.frame.size.height;
    }
    [self setContentInsetForScrollView:self.userTableView inset:inset];
    
    inset = self.systemTableView.contentInset;
    if (inset.top == 0) {
        inset.top += _categoryTabView.frame.size.height;
    }
    [self setContentInsetForScrollView:self.systemTableView inset:inset];
}

- (void)selectCategoryTabAtIndex:(NSInteger)tag needRefresh:(BOOL)needRefresh{
    if (tag == CATEGORY_TAB_INDEX_0) {
        self.userTableView.hidden = NO;
        self.systemTableView.hidden = YES;
        if (self.userMessageInfos && self.userMessageInfos.count == 0) {
            [self refreshUserMessagesInfo];
            return;
        }
        if (needRefresh) {
            [self refreshUserMessagesInfo];
        }
    }else if (tag == CATEGORY_TAB_INDEX_1){
        self.userTableView.hidden = YES;
        self.systemTableView.hidden = NO;
        if (self.systemMessageInfos && self.systemMessageInfos.count == 0) {
            [self refreshSystemMessagesInfo];
            return;
        }
        if (needRefresh) {
            [self refreshUserMessagesInfo];
        }
    }
}

-(NSMutableArray*)customMessageInfos:(UITableView *)tableView
{
    NSMutableArray *newMessageInfos;
    if (tableView) {
        if (tableView == self.userTableView) {
            newMessageInfos = self.userMessageInfos;
        }else if (tableView == self.systemTableView){
            newMessageInfos = self.systemMessageInfos;
        }
        return newMessageInfos;
    }
    if (_selectIndex == CATEGORY_TAB_INDEX_0) {
        newMessageInfos = self.userMessageInfos;
    }else if (_selectIndex == CATEGORY_TAB_INDEX_1){
        newMessageInfos = self.systemMessageInfos;
    }
    return newMessageInfos;
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self customMessageInfos:tableView].count;
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
    }
    
    JFMessageInfo *msgInfo = [self customMessageInfos:tableView][indexPath.row];
    cell.messageInfo = msgInfo;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    
    JFMessageInfo *msgInfo = [self customMessageInfos:tableView][indexPath.row];
    
    ChatViewController *chatVc = [[ChatViewController alloc] init];
    chatVc.peerId = msgInfo.authorId;
    [self.navigationController pushViewController:chatVc animated:YES];
}

#pragma mark - JFCategoryTabViewDelegate
-(void)categoryTab:(JFCategoryTabView *)aTabBar didSelectTabAtIndex:(NSInteger)anIndex{
    
    if (_selectIndex == anIndex) {
        return;
    }
    _selectIndex = anIndex;
    [self selectCategoryTabAtIndex:anIndex needRefresh:NO];
}

@end
