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

//第三方广告平台
#import "DMOfferWallManager.h"
#import <AdSupport/AdSupport.h>
//有米
#import "YouMiWall.h"
//点入
#import "KillAdvice.h"
#import "TalkingDataSDK.h"
//力美
#import <MBJoy/MBJoyView.h>
//易积分
#import <Eadver/HMIntegralScore.h>

#define V_FRAME      self.view.frame
#define IOS7         [[UIDevice currentDevice].systemVersion doubleValue] >= 7.0

@interface GainScoreViewController ()<UITableViewDataSource,UITableViewDelegate,JFCategoryTabViewDelegate,DMOfferWallManagerDelegate,YQLDelegate,MBJoyViewDelegate,HMIntegralScoreDelegate>
{

    //多盟广告平台
//    DMOfferWallManager *_manager;
}

@property (nonatomic, strong)   UIView *drBgView;
@property (nonatomic, assign)   CGRect initFrame;

//力美广告view
@property (nonatomic, retain) MBJoyView *adView;

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

- (BOOL)prefersStatusBarHidden//for iOS7.0
{
    return NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initframe];
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
        
        NSDictionary *dataDic = [jsonRet dictionaryObjectForKey:@"data"];
        BOOL isSucceed = [dataDic boolValueForKey:@"status"];
        if (isSucceed) {
            [LSCommonUtils showWarningTip:@"申请该任务成功！" At:weakSelf.view];
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
    
    //积分墙
    if (_selectIndex == 0) {
        switch (indexPath.row) {
            case 0:
            {
                //多盟
//                _manager = [[DMOfferWallManager alloc] initWithPublisherID:@"96ZJ37cAzeBSjwTCtz"
//                                                                 andUserID:nil];
//                _manager.delegate = self;
//                // !!!:重要：如果需要禁用应用内下载，请将此值设置为YES。
//                _manager.disableStoreKit = NO;
//                
//                [_manager presentOfferWallWithViewController:self type:eDMOfferWallTypeList];
            }
                break;
                
            case 1: {
                //有米
                [YouMiWall showOffers:YES didShowBlock:^{
                    NSLog(@"有米积分墙已显示");
                } didDismissBlock:^{
                    NSLog(@"有米积分墙已退出");
                }];
            }
                break;
                
            case 2: {
                //点入
                /*
                 第一种 直接show
                 param1:广告类型，选择你要嵌入的宏
                 
                 #define DR_OFFERWALL    1   //积分墙
                 #define DR_FREEWALL     2   //免费墙
                 
                 */
                [self createDrBgview];
                [self willAnimateRotationToInterfaceOrientation:UIInterfaceOrientationPortrait duration:0.1];
                DR_SHOW(1, self.drBgView, self)
                
                
                /*
                 第二种 自己创建view, delegate会回调view
                 在回调里加view
                 */
                //                DR_CREATE(DR_FREEWALL, self)

            }
                break;
                
            case 3: {
                //力美
                [self enterAdWall];
            }
                break;
            case 4: {
                //易积分
                HMIntegralScore *integralWall = [[HMIntegralScore alloc]init];
                integralWall.delegate = self;
                [self presentViewController:integralWall animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - 易积分广告平台
#pragma mark - IntegralScore delegate

-(void)OpenIntegralScore:(int)_value //1 打开成功  0 获取数据失败
{
    if (_value == 1) {
        NSLog(@"积分墙打开成功");
    }
    else
    {
        NSLog(@"积分墙获取数据失败");
    }
}
-(void)CloseIntegralScore  //墙关闭
{
    NSLog(@"积分墙关闭");
}

#pragma mark - 力美广告平台
// 进入积分墙
-(void)enterAdWall{
    // 实例化 MBJoyView 对象，在此处替换在力美广告平台申请到的广告位 Id；
//    self.adView = [[MBJoyView alloc]initWithAdUnitId:
//                   kLiMeiAdID adType:AdTypeList rootViewController:self
//                                            userInfo:@{accountname:@"wjf"}];
//    //添加 MBJoyView 的 Delegate；
//    self.adView.delegate=self;
//    //开始加载广告。
//    [self. adView request];
//    //将 MBJoyView 添加到界面上。
//    [self.view addSubview:self.adView];
}

#pragma mark - 点入广告平台
- (void)createDrBgview{
    self.drBgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                             0,
                                                             CGRectGetWidth(self.initFrame),
                                                             CGRectGetHeight(self.initFrame))];
    [self.view addSubview:self.drBgView];
}

- (void)initframe
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        self.initFrame = V_FRAME;
    }else{
        CGRect rect = CGRectMake(V_FRAME.origin.x,
                                 V_FRAME.origin.y,
                                 CGRectGetHeight(V_FRAME),
                                 CGRectGetWidth(V_FRAME));
        self.initFrame = rect;
    }
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

#pragma mark -- 点入广告平台Delegate

/*
 请求广告条数
 如果广告条数大于0，那么code=0，代表成功
 反之code = -1
 */
- (void)dianruDidDataReceivedView:(UIView *)view
                       dianruCode:(int)code{}

/*
 广告弹出时回调
 view有可能是空注意保护
 */
- (void)dianruDidViewOpenView:(UIView *)view{
    if (view) {
        
        /*
         如果是用DR_CREATE创建的话 可以用类似以下的代码进行添加
         */
        
        //        UIView *__view = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 220, 380)];
        //        __view.backgroundColor = [UIColor redColor];
        //        [self.view addSubview:__view];
        //        [__view addSubview:view];
        
        /*
         来控制大小
         */
        //        [view setFrame:__view.bounds];
        
    }
}

/*
 点击广告关闭按钮的回调，不代表广告从内存中释放
 */
- (void)dianruDidMainCloseView:(UIView *)view{}

/*
 广告释放时回调，从内从中释放
 */
- (void)dianruDidViewCloseView:(UIView *)view{
    if (self.drBgView) [self.drBgView removeFromSuperview];
}

/*
 曝光回调
 */
- (void)dianruDidReportedView:(UIView *)view
                   dianruData:(id)data{
}

/*
 点击广告回调
 */
- (void)dianruDidClickedView:(UIView *)view
                  dianruData:(id)data{
}

/*
 点击跳转回调
 */
- (void)dianruDidJumpedView:(UIView *)view
                 dianruData:(id)data{

}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        [self.drBgView setFrame:CGRectMake(0,
                                           0,
                                           CGRectGetWidth(self.initFrame),
                                           CGRectGetHeight(self.initFrame))];
    }else{
        [self.drBgView setFrame:CGRectMake(0,
                                           0,
                                           CGRectGetHeight(self.initFrame) + (IOS7 ? 0.0f : 20.0f),
                                           CGRectGetWidth(self.initFrame) - 0 - (IOS7 ? 0.0f : 20.0f))];
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
