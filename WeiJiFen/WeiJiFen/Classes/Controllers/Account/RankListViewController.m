//
//  RankListViewController.m
//  WeiJiFen
//
//  Created by liguangjun on 14-11-29.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "RankListViewController.h"
#import "RankViewCell.h"

@interface RankListViewController ()

@property (nonatomic, strong) NSDictionary *rankDic;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;

@end

@implementation RankListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"排行榜";
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

-(void)refreshViewUI{
    
    self.positionLabel.text = [NSString stringWithFormat:@"%d",[_rankDic intValueForKey:@"position"]];
    if ([_rankDic intValueForKey:@"position"] <= 0) {
        self.positionLabel.text = @"未上榜";
    }
    self.tableView.tableHeaderView = self.headView;
}

#pragma mark - request
- (void)loadDataSource
{
    __weak RankListViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] getRankListWithPage:1 pageSize:10 tag:tag];
    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
            return;
        }
        
        weakSelf.rankDic = [[NSDictionary alloc] init];
        weakSelf.rankDic = [jsonRet dictionaryObjectForKey:@"data"];
        NSArray *prizeArray = [weakSelf.rankDic arrayObjectForKey:@"list"];
        for (NSDictionary *dic in prizeArray) {
            
            [weakSelf.dataSource addObject:dic];
        }
        [self refreshViewUI];
        [weakSelf.tableView reloadData];
        
    } tag:tag];
}

#pragma mark - UITableView DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 21;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *helpCellIdentifier = @"RankViewCell";
    RankViewCell *cell = (RankViewCell *)[tableView dequeueReusableCellWithIdentifier:helpCellIdentifier];
    if (!cell) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:helpCellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *rankDic = self.dataSource[indexPath.row];
    cell.rankDic = rankDic;
    cell.positionLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    return cell;
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
