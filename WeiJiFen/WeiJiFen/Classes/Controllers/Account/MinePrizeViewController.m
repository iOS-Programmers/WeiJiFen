//
//  MinePrizeViewController.m
//  WeiJiFen
//
//  Created by liguangjun on 14-11-29.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "MinePrizeViewController.h"
#import "JFPrizeInfo.h"
#import "UIImageView+WebCache.h"

@interface MinePrizeViewController ()

@property (nonatomic, strong) NSDictionary *prizeDic;
@property (strong, nonatomic) IBOutlet UIView *PrizeCountView;
@property (weak, nonatomic) IBOutlet UILabel *PrizeCountLabel;
@property (strong, nonatomic) IBOutlet UIView *footerView;

- (IBAction)shareMonadAction:(id)sender;
@end

@implementation MinePrizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _prizeDic = [[NSDictionary alloc] init];
    self.title = @"我的奖品";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
    [self refreshViewUI];
    [self loadDataSource];
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

#pragma mark - custom
- (IBAction)shareMonadAction:(id)sender {
}

-(void)refreshViewUI{
    
//    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.PrizeCountView;
    self.PrizeCountLabel.text = [NSString stringWithFormat:@"我的奖品：%d个",[_prizeDic intValueForKey:@"count"]];
    if (self.dataSource && self.dataSource.count == 0) {
        self.tableView.tableFooterView  = self.footerView;
    }else{
        self.tableView.tableFooterView  = nil;
    }
}

#pragma mark - request
- (void)loadDataSource
{
    __weak MinePrizeViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] getMyPrizeWithUserId:[WeiJiFenEngine shareInstance].uid tag:tag];
    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
            return;
        }
        
        weakSelf.prizeDic = [[NSDictionary alloc] init];
        weakSelf.prizeDic = [jsonRet dictionaryObjectForKey:@"data"];
        NSArray *prizeArray = [weakSelf.prizeDic arrayObjectForKey:@"list"];
        for (NSDictionary *dic in prizeArray) {
            JFPrizeInfo *prizeInfo = [[JFPrizeInfo alloc] init];
            [prizeInfo setPrizeInfoByDic:dic];
            [weakSelf.dataSource addObject:prizeInfo];
        }
        [self refreshViewUI];
        [weakSelf.tableView reloadData];
        
    } tag:tag];
}

#pragma mark - UITableView DataSource
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    self.PrizeCountLabel.text = [NSString stringWithFormat:@"我的奖品：%d个",[_prizeDic intValueForKey:@"count"]];
//    return self.PrizeCountView;
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 46;
}

static int creditLabel_Tag = 102;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentfier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:nil]];
        lineImageView.backgroundColor = UIColorRGB(221, 221, 221);
        lineImageView.frame = CGRectMake(0, cell.frame.size.height - 1, cell.frame.size.width, 1);
        [cell addSubview:lineImageView];
        
        UIImageView *middleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:nil]];
        middleImageView.backgroundColor = UIColorRGB(221, 221, 221);
        middleImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        middleImageView.frame = CGRectMake(246, 0, 1, cell.frame.size.height);
        [cell addSubview:middleImageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(258, 0, 62, cell.frame.size.height)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [LSCommonUtils getProgramMainTitleColor];
        label.tag = creditLabel_Tag;
        [cell addSubview:label];
        
    }
    
    JFPrizeInfo *info = self.dataSource[indexPath.row];
    [cell.imageView sd_setImageWithURL:info.avatarUrl placeholderImage:[UIImage imageNamed:@"jf_message_icon.png"]];
    
    cell.textLabel.textColor = [LSCommonUtils getProgramMainHueColor];
    cell.textLabel.text = info.subject;
    
    cell.detailTextLabel.text = [LSCommonUtils secondChangToDateString:[NSString stringWithFormat:@"%d",info.lastupdate]];
    
    UILabel *creditLabel = (UILabel *)[cell viewWithTag:creditLabel_Tag];
    creditLabel.text = [NSString stringWithFormat:@"-%d",info.credit];
    
    return cell;
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
