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
#import "CommentInfoViewCell.h"
#import "JFCommentInfo.h"
#import "LSAlertView.h"
#import "LoginViewController.h"
#import "AffirmBuyViewController.h"

@interface CommodityDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *commodityTitle;

@property (nonatomic, retain) UIView *bgMarkView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *headView;
@property (nonatomic, strong) IBOutlet UIView *todoRenwu;
@property (nonatomic, strong) IBOutlet UIView *footView;
@property (nonatomic, retain) IBOutlet UILabel *sellerLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userAvatarImageView;

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
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UITextField *textField;


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
    
    _userName = _commodityInfo.userName;
    _commodityTitle = _commodityInfo.name;
    if (_commodType) {
        _commodityTitle = [NSString stringWithFormat:@"【%@】%@",_commodType,_commodityInfo.name];
    }
    
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
    self.footView.frame = CGRectMake(0, SCREEN_HEIGHT-64-48, SCREEN_WIDTH, 48);
    self.footView.layer.borderWidth = 0.5;
    self.footView.layer.borderColor = [kBorderColor CGColor];
    [self.view addSubview:self.footView];
    self.likeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.likeBtn.layer.borderWidth = 0.5;
    self.commentBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.commentBtn.layer.borderWidth = 0.5;
    self.textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textField.layer.borderWidth = 0.5;
    
    _attachmentImageView.contentMode = UIViewContentModeScaleAspectFill;
    _attachmentImageView.clipsToBounds = YES;
    
    _userAvatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    _userAvatarImageView.clipsToBounds = YES;
    
    self.subjectLabel.text = _commodityTitle;
    [self.userAvatarImageView sd_setImageWithURL:_commodityInfo.userAvatarUrl placeholderImage:[UIImage imageNamed:@"avatar.png"]];
    [self.attachmentImageView sd_setImageWithURL:_commodityInfo.comAvatarUrl placeholderImage:[UIImage imageNamed:@"jf_message_icon.png"]];
    self.sellerLabel.text = _userName;
    self.lastupdateLabel.text = [LSCommonUtils secondChangToDateString:[NSString stringWithFormat:@"%d",_commodityInfo.crateDate]];
    self.priceLabel.text = [NSString stringWithFormat:@"现金%d元",_commodityInfo.price];
    self.creditLabel.text = [NSString stringWithFormat:@"微积分%d",_commodityInfo.credit];
    NSString *comMold = @"无";
    if (_commodityInfo.quality == 2) {
        comMold = @"二手商品";
    }else if (_commodityInfo.quality == 1){
        comMold = @"全新商品";
    }
    self.expirationLabel.text = [NSString stringWithFormat:@"商品类型：%@",comMold];
    
    if (_commodityInfo.message) {
        self.messageLabel.text = [NSString stringWithFormat:@"商品详情：%@",_commodityInfo.message];
    }
    [self.likeBtn setTitle:[NSString stringWithFormat:@"  %d",_commodityInfo.recommend_add] forState:0];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"  %d",_commodityInfo.replies] forState:0];
    
    [self.tableView reloadData];
}

-(IBAction)buyBtn:(UIButton *)sender
{
    
    
    if (![WeiJiFenEngine shareInstance].hasAccoutLoggedin) {
        
        LSAlertView *alertView = [[LSAlertView alloc] initWithTitle:@"温馨提示" message:@"对不起！您还未登录！！！" cancelButtonTitle:@"取消" cancelBlock:^{
            
        } okButtonTitle:@"登陆" okBlock:^{
            
            LoginViewController *vc = [[LoginViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [alertView show];
        return;
    }
    
    AffirmBuyViewController *affirmBuyVc = [[AffirmBuyViewController alloc] init];
    affirmBuyVc.commodityInfo = _commodityInfo;
    affirmBuyVc.vcType = VcType_Nomal;
    [self.navigationController pushViewController:affirmBuyVc animated:YES];
    return;
    
    
    
    
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
    __weak CommodityDetailsViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] likeThreadWithTid:_commodityInfo.tid tag:tag];
    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
            return;
        }
        NSDictionary *comDic = [jsonRet dictionaryObjectForKey:@"data"];
        _commodityInfo.recommend_add = [comDic intValueForKey:@"recommend_add"];
        [weakSelf refreshViewUI];
    } tag:tag];
}

-(IBAction)message:(UIButton *)sender
{
    [self sendReplyMessage];
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
        [weakSelf refreshViewUI];
    } tag:tag];
}

-(void)sendReplyMessage
{
    __weak CommodityDetailsViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] userReplyMessageWithPid:nil tid:_commodityInfo.tid fid:_commodityInfo.fid message:_textField.text tag:tag];
    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
            return;
        }
        
        [LSCommonUtils showWarningTip:@"回复成功！" At:weakSelf.view];
        [weakSelf refreshCommodityInfo];
        
    } tag:tag];
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _commodityInfo.replylist.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JFCommentInfo *commentInfo = _commodityInfo.replylist[indexPath.row];
    
    return [CommentInfoViewCell getCommentInfoViewCellHeight:commentInfo];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"CommentInfoViewCell";
    CommentInfoViewCell *cell = (CommentInfoViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        [cell.userAvatar addTarget:self action:@selector(userAvatarClickAt:event:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.replyButton addTarget:self action:@selector(handleClickAt:event:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.isHiddenReplyButton = YES;
    JFCommentInfo *commentInfo = _commodityInfo.replylist[indexPath.row];
    cell.commentInfo = commentInfo;
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.textField resignFirstResponder];
}

@end
