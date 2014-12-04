//
//  CommodityDetailsViewController.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-22.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "CommodityDetailsViewController.h"
#import "AccountDetailsViewController.h"
#import "WeiJiFenEngine.h"
#import "JSONKit.h"


@interface CommodityDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) UIView *bgMarkView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *headView;
@property (nonatomic, strong) IBOutlet UIView *todoRenwu;
@property (nonatomic, strong) IBOutlet UIView *footView;
@property (nonatomic, retain) IBOutlet UILabel *sellerLabel;
@property (nonatomic, retain) IBOutlet UILabel *subjectLabel;
@property (nonatomic, retain) IBOutlet UILabel *priceLabel;
@property (nonatomic, retain) IBOutlet UILabel *creditLabel;
@property (nonatomic, retain) IBOutlet UIImageView *attachmentImageView;
@property (nonatomic, retain) IBOutlet UILabel *lastupdateLabel;
@property (nonatomic, retain) IBOutlet UILabel *expirationLabel;
@property (nonatomic, retain) IBOutlet UILabel *messageLabel;
@property (nonatomic, retain) IBOutlet UIButton *askBtn;
@property (nonatomic, retain) IBOutlet UIButton *buyBtn;
@property (nonatomic, retain) IBOutlet UILabel *recommend_addLabel;
@property (nonatomic, retain) IBOutlet UILabel *repliesLabel;


-(IBAction)backAction:(id)sender;
-(IBAction)buyBtn:(UIButton *)sender;
-(IBAction)askBtn:(UIButton *)sender;

-(IBAction)clickedZan:(UIButton *)sender;
-(IBAction)message:(UIButton *)sender;

-(IBAction)todoRenwu:(UIButton *)sender;
-(IBAction)notTodoRenwu:(UIButton *)sender;

#define kColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kBorderColor        kColorFromRGB(0xcccccc)

@end

@implementation CommodityDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"物品详情";
    
    JFCommodityInfo *oldCommodity = _commodityInfo;
    _commodityInfo = [[JFCommodityInfo alloc] init];
    [_commodityInfo setCommodityInfoByDic:[oldCommodity.jsonString objectFromJSONString]];
    _commodityInfo.comId = oldCommodity.comId;
    
    
    [self refreshCommodityInfo];
    [self refreshViewUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backAction:(id)sender{
//    [self.navigationController popViewControllerAnimated:YES];
    AccountDetailsViewController *accountDetailsVc = [[AccountDetailsViewController alloc] init];
    [self.navigationController pushViewController:accountDetailsVc animated:YES];
}

- (void)refreshViewUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.headView;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-48);
    self.footView.frame = CGRectMake(0, SCREEN_HEIGHT-64-48, SCREEN_WIDTH, 48);
    self.footView.layer.borderWidth = 0.5;
    self.footView.layer.borderColor = [kBorderColor CGColor];
    [self.view addSubview:self.footView];
    [self.tableView reloadData];
}

-(IBAction)buyBtn:(UIButton *)sender
{
    self.todoRenwu.frame = CGRectMake(60, SCREEN_HEIGHT, 200, 135);
    [self.view addSubview:self.todoRenwu];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.todoRenwu.frame;
        frame.origin.y = 150;
        self.todoRenwu.frame = frame;
        
    }];
    
    if (!self.bgMarkView) {
        self.bgMarkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)];
        _bgMarkView.backgroundColor = [UIColor blackColor];
        _bgMarkView.alpha = 0.7;
        [self.view insertSubview:_bgMarkView belowSubview:self.todoRenwu];
    }
}

-(IBAction)askBtn:(UIButton *)sender
{
    
}

-(IBAction)clickedZan:(UIButton *)sender
{
    
}

-(IBAction)message:(UIButton *)sender
{
    
}

-(IBAction)todoRenwu:(UIButton *)sender
{
    
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.todoRenwu.frame;
        frame.origin.y = SCREEN_HEIGHT;
        self.todoRenwu.frame = frame;
        
        
    }];
    if (_bgMarkView) {
        [_bgMarkView removeFromSuperview];
        _bgMarkView = nil;
    }
}

-(IBAction)notTodoRenwu:(UIButton *)sender{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.todoRenwu.frame;
        frame.origin.y = SCREEN_HEIGHT;
        self.todoRenwu.frame = frame;
        
    }];
    if (_bgMarkView) {
        [_bgMarkView removeFromSuperview];
        _bgMarkView = nil;
    }
}

- (void)refreshCommodityInfo{
    
    __weak CommodityDetailsViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] commodityShowWithToken:WeiJiFenEngine.userToken confirm:[WeiJiFenEngine shareInstance].confirm pId:self.commodityInfo.comId tag:tag];
    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
            return;
        }
        NSDictionary *comDic = [jsonRet objectForKey:@"data"];
        [weakSelf.commodityInfo setCommodityInfoByDic:comDic];
        
    } tag:tag];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        //        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        //        cell = [cells objectAtIndex:0];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    cell.textLabel.text = @"nihao";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
}
@end
