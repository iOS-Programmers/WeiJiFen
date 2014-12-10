//
//  AffirmBuyViewController.m
//  WeiJiFen
//
//  Created by liguangjun on 14-12-10.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "AffirmBuyViewController.h"

@interface AffirmBuyViewController ()
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *commodityAvatar;
@property (weak, nonatomic) IBOutlet UILabel *commodityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentPriceLabel;
@property (weak, nonatomic) IBOutlet UITextField *buyNumberTextField;
@property (weak, nonatomic) IBOutlet UILabel *tradeMethodsLabel;
@property (weak, nonatomic) IBOutlet UITextField *buyerNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;
@property (weak, nonatomic) IBOutlet UITextField *buyerCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *buyerTallTextField;
@property (weak, nonatomic) IBOutlet UITextField *buyerPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;

//确认付款的view
@property (strong, nonatomic) IBOutlet UIView *payHeadView;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextView *buyerMessageTextView;


- (IBAction)affimBuyAction:(id)sender;
- (IBAction)paymentAction:(id)sender;
- (IBAction)cancelBuyAction:(id)sender;
@end

@implementation AffirmBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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

-(void)refreshViewUI{
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _commodityAvatar.contentMode = UIViewContentModeScaleAspectFill;
    _commodityAvatar.clipsToBounds = YES;
    [self.commodityAvatar sd_setImageWithURL:_commodityInfo.comAvatarUrl placeholderImage:[UIImage imageNamed:@"jf_message_icon.png"]];
    self.commodityTitleLabel.text = _commodityInfo.name;
    if (_commodityInfo.name.length == 0) {
        self.commodityTitleLabel.text = @"暂无标题";
    }
    self.buyerNameLabel.text = _commodityInfo.userName;
    self.currentPriceLabel.text = [NSString stringWithFormat:@"微积分%d",_commodityInfo.credit];
    self.paymentPriceLabel.text = [NSString stringWithFormat:@"微积分%d",_commodityInfo.credit];
    self.buyNumberTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.buyNumberTextField.layer.borderWidth = 0.5;
    
    self.buyerNameTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.buyerNameTextField.layer.borderWidth = 0.5;
    self.addressTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.addressTextView.layer.borderWidth = 0.5;
    self.buyerCodeTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.buyerCodeTextField.layer.borderWidth = 0.5;
    self.buyerTallTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.buyerTallTextField.layer.borderWidth = 0.5;
    self.buyerPhoneTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.buyerPhoneTextField.layer.borderWidth = 0.5;
    self.remarkTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.remarkTextView.layer.borderWidth = 0.5;
    self.passwordTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.passwordTextField.layer.borderWidth = 0.5;
    self.buyerMessageTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.buyerMessageTextView.layer.borderWidth = 0.5;
    
    int transport = _commodityInfo.transport;//0虚拟物品1卖家承担运费2买家承担运费3支付给物流公司4线下交易
    if (transport == 0) {
        self.tradeMethodsLabel.text = @"虚拟物品";
    }else if (transport == 1){
        self.tradeMethodsLabel.text = @"卖家承担运费";
    }else if (transport == 2){
        self.tradeMethodsLabel.text = @"买家承担运费";
    }else if (transport == 3){
        self.tradeMethodsLabel.text = @"支付给物流公司";
    }else if (transport == 4){
        self.tradeMethodsLabel.text = @"线下交易";
    }
    if (_vcType == VcType_Nomal) {
        self.title = @"确认购买信息";
        self.tableView.tableHeaderView = self.headView;
    }else if (_vcType == VcType_Pay){
        self.title = @"交易单";
        self.tableView.tableHeaderView = self.payHeadView;
    }
    
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentfier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    return cell;
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self resignFirstResponder];
}

- (IBAction)affimBuyAction:(id)sender {
    
    int transportfee = 0;
    if (_commodityInfo.transport == 2) {
        transportfee = _commodityInfo.transport;
    }
    
    __weak AffirmBuyViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] confirmBuyWithTId:_commodityInfo.tid pId:_commodityInfo.comId count:[_buyNumberTextField.text intValue] buyercontact:_addressTextView.text buyername:_buyerNameTextField.text buyerzip:_buyerCodeTextField.text buyerphone:_buyerTallTextField.text buyermobile:_buyerPhoneTextField.text buyermsg:_remarkTextView.text transportfee:transportfee tag:tag];
    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
            return;
        }
        
        NSDictionary *aDic = [jsonRet dictionaryObjectForKey:@"data"];
        NSString *orderId = [aDic stringObjectForKey:@"orderid"];
        
        [LSCommonUtils showWarningTip:@"订单生成成功！" At:weakSelf.view];
        
        AffirmBuyViewController *affirmBuyVc = [[AffirmBuyViewController alloc] init];
        affirmBuyVc.commodityInfo = _commodityInfo;
        affirmBuyVc.vcType = VcType_Pay;
        affirmBuyVc.orderId = orderId;
        [self.navigationController pushViewController:affirmBuyVc animated:YES];
        
    } tag:tag];
    
}

- (IBAction)paymentAction:(id)sender {
    
    __weak AffirmBuyViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] confirmPaymentWithOrderId:_orderId message:_buyerMessageTextView.text password:_passwordTextField.text tag:tag];
    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
            return;
        }
        [LSCommonUtils showWarningTip:@"您已确认付款，等待卖家发货！" At:weakSelf.view];
        [self.navigationController popViewControllerAnimated:YES];
        
    } tag:tag];
    
}

- (IBAction)cancelBuyAction:(id)sender {
    __weak AffirmBuyViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] cancelTradeWithOrderId:_orderId message:_buyerMessageTextView.text password:_passwordTextField.text tag:tag];
    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
            return;
        }
        [LSCommonUtils showWarningTip:@"此订单已取消。" At:weakSelf.view];
        [self.navigationController popViewControllerAnimated:YES];
        
    } tag:tag];
}
@end
