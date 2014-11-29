//
//  PersonalProfileViewController.m
//  WeiJiFen
//
//  Created by liguangjun on 14-11-28.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "PersonalProfileViewController.h"

@interface PersonalProfileViewController ()

@property (nonatomic, strong) IBOutlet UIView *headView;
@property (nonatomic, strong) IBOutlet UIImageView *userAvatarImageView;
@property (nonatomic, strong) IBOutlet UILabel *userNameLabel;
@property (nonatomic, strong) IBOutlet UIView *sellerCreditView;
@property (nonatomic, strong) IBOutlet UIView *buyerCreditView;
@property (nonatomic, strong) IBOutlet UILabel *userIntegralLabel;
@property (nonatomic, strong) IBOutlet UILabel *userFriendsLabel;

@property (nonatomic, strong) IBOutlet UIButton *exitButton;
@property (nonatomic, strong) IBOutlet UIButton *addFriendButton;
@property (nonatomic, strong) IBOutlet UIButton *sendMessageButton;

- (IBAction)exitAction:(id)sender;
- (IBAction)addFriedAction:(id)sender;
- (IBAction)sendMessageAction:(id)sender;

@end

@implementation PersonalProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self refreshViewUI];
    [self loadUserInfo];
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
-(void)loadUserInfo{
    
    if (_userInfo == nil) {
        _userInfo = [[JFUserInfo alloc] init];
        _userInfo.uid = _userId;
    } else {
        JFUserInfo *oldUserInfo = _userInfo;
        _userInfo = [[JFUserInfo alloc] init];
//        [_userInfo setUserInfoByJsonDic:oldUserInfo.userInfoByJsonDic];
        _userInfo.uid = oldUserInfo.uid;
    }
    if (_userInfo.uid.length == 0) {
        [LSCommonUtils showWarningTip:@"用户不存在" At:self.view];
        return;
    }
    
    __weak PersonalProfileViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] getPersonalInfoWithUserId:_userInfo.uid tag:tag];
    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
            return;
        }
        
        NSDictionary *dic = [jsonRet dictionaryObjectForKey:@"data"];
        [weakSelf.userInfo setOtherUserInfoByJsonDic:dic];
        [weakSelf refreshViewUI];
    } tag:tag];
    
}

#pragma mark - Custom
- (BOOL)isOwner{
    return [_userInfo.uid isEqualToString:[WeiJiFenEngine shareInstance].uid];
}

- (void)refreshViewUI{
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CGRect frame = self.userAvatarImageView.frame;
    self.userAvatarImageView.layer.cornerRadius = frame.size.width/2;
    self.userAvatarImageView.layer.masksToBounds = YES;
    self.userAvatarImageView.clipsToBounds = YES;
    self.userAvatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.userAvatarImageView sd_setImageWithURL:_userInfo.smallAvatarUrl placeholderImage:nil];
    
    self.userNameLabel.text = _userInfo.nickName;
    self.userIntegralLabel.text = [NSString stringWithFormat:@"%d",_userInfo.wjf];
    
    //卖家信誉
    int credit = _userInfo.sellercredit;
    CGSize creditImageSize = CGSizeMake(12, 12);
    for (UIView *view in self.sellerCreditView.subviews) {
        [view removeFromSuperview];
    }
    for (int index = 0; index < credit; index ++ ) {
        UIImageView *creditImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jf_sellercredit_icon.png"]];
        creditImageView.frame = CGRectMake((creditImageSize.width+1)*index, (self.sellerCreditView.frame.size.height-creditImageSize.height)/2, creditImageSize.width, creditImageSize.height);
        [self.sellerCreditView addSubview:creditImageView];
    }
    //买家信誉
    credit = 3;
    for (UIView *view in self.buyerCreditView.subviews) {
        [view removeFromSuperview];
    }
    for (int index = 0; index < credit; index ++ ) {
        UIImageView *creditImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jf_ buyercredit_icon.png"]];
        creditImageView.frame = CGRectMake((creditImageSize.width+1)*index, (self.buyerCreditView.frame.size.height-creditImageSize.height)/2, creditImageSize.width, creditImageSize.height);
        [self.buyerCreditView addSubview:creditImageView];
    }
    
    self.title = [NSString stringWithFormat:@"%@的资料",_userInfo.nickName];
    
    self.exitButton.hidden = YES;
    self.addFriendButton.hidden = NO;
    self.sendMessageButton.hidden = NO;
    if ([self isOwner]) {
        self.exitButton.hidden = NO;
        self.addFriendButton.hidden = YES;
        self.sendMessageButton.hidden = YES;
        self.title = @"我的账号";
    }
    
    self.tableView.tableHeaderView = self.headView;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];
    
}

- (IBAction)exitAction:(id)sender {
}

- (IBAction)addFriedAction:(id)sender {
}

- (IBAction)sendMessageAction:(id)sender {
}

@end
