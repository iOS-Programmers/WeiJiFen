//
//  JFBaseTableViewController.m
//  WeiJiFen
//
//  Created by Jyh on 14/11/28.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "JFBaseTableViewController.h"

@interface JFBaseTableViewController ()

/**
 *  判断tableView是否支持iOS7的api方法
 *
 *  @return 返回预想结果
 */
- (BOOL)validateSeparatorInset;

@end

@implementation JFBaseTableViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.canPullRefresh = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.canPullRefresh) {
        //添加下拉刷新
        if (!_header) {
            _header = [[MJRefreshHeaderView alloc] init];
            _header.delegate = self;
            _header.scrollView = self.tableView;
        }
    }
}

#pragma mark - Publish Method

- (void)configuraTableViewNormalSeparatorInset {
    if ([self validateSeparatorInset]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)configuraSectionIndexBackgroundColorWithTableView:(UITableView *)tableView {
    if ([tableView respondsToSelector:@selector(setSectionIndexBackgroundColor:)]) {
        tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
}

- (void)loadDataSource {
    // subClasse
}

#pragma mark - Propertys

- (UITableView *)tableView {
    if (!_tableView) {
        //        CGRect tableViewFrame = [UIScreen mainScreen].applicationFrame;
        //        //  [UIScreen mainScreen].applicationFrame  {{0, 20}, {320, 548}}
        //        tableViewFrame.origin.y = 0;
        //        tableViewFrame.size.height -= (self.navigationController.viewControllers.count > 1 ?(CGRectGetHeight(self.navigationController.navigationBar.bounds)) : (CGRectGetHeight(self.tabBarController.tabBar.bounds))) + (CGRectGetHeight(self.navigationController.navigationBar.bounds));
        //        if (self.navigationController.navigationBarHidden)
        //        {
        //            tableViewFrame.origin.y = IOS7_OR_LATER? tableViewFrame.origin.y+20:tableViewFrame.origin.y;
        //        }
        //        else
        //        {
        //            tableViewFrame.origin.y = IOS7_OR_LATER? tableViewFrame.origin.y+64:tableViewFrame.origin.y;
        //        }
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.tableViewStyle];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
        if (![self validateSeparatorInset]) {
            if (self.tableViewStyle == UITableViewStyleGrouped) {
                UIView *backgroundView = [[UIView alloc] initWithFrame:_tableView.bounds];
                backgroundView.backgroundColor = _tableView.backgroundColor;
                _tableView.backgroundView = backgroundView;
            }
        }
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _dataSource;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    
}

- (void)dealloc {
    self.dataSource = nil;
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.tableView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Helper Method

- (BOOL)validateSeparatorInset {
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        return YES;
    }
    return NO;
}

- (UIBarButtonItem *)createNavBtnItem:(UIViewController *)target normal:(NSString *)imgStr highlight:(NSString *)highStr selector:(SEL)selector
{
    UIImage *btnImage = [UIImage imageNamed:imgStr];
    UIImage *btnImageH = [UIImage imageNamed:highStr];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0.0f, 0.0f, btnImage.size.width+10, btnImage.size.height);
    btn.backgroundColor = [UIColor clearColor];
    [btn setImage:btnImage forState:UIControlStateNormal];
    [btn setImage:btnImageH forState:UIControlStateHighlighted];
//    if (!FBIsEmpty(target))
//    {
        [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
//    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // in subClass
    return nil;
}

#pragma mark 上下拉刷新的Delegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    //子类重写
}


@end
