//
//  AccountViewController.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-14.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "AccountViewController.h"
#import "AccountDetailsViewController.h"
#import "UIImageView+WebCache.h"
#import "JFUserInfo.h"
#import "WeiJiFenEngine.h"
#import "FriendListController.h"
#import "LoginViewController.h"
#import "MessageListViewController.h"
#import "PersonalProfileViewController.h"
#import "MinePrizeViewController.h"
#import "RankListViewController.h"
#import "PromotionViewController.h"

@interface AccountViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) JFUserInfo *userInfo;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *headView;
@property (nonatomic, strong) IBOutlet UIView *userContainerView;
@property (nonatomic, strong) IBOutlet UIImageView *userAvatarImageView;
@property (nonatomic, strong) IBOutlet UILabel *userNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *userIntegralLabel;
@property (nonatomic, strong) IBOutlet UIView *sellerCreditView;
@property (nonatomic, strong) IBOutlet UIView *buyerCreditView;

@property (nonatomic, strong) IBOutlet UIView *actionView;

-(IBAction)myAccountAction:(id)sender;
- (IBAction)personalProfileAction:(id)sender;

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _userInfo = [[WeiJiFenEngine shareInstance] userInfo];
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

#pragma mark - Custom
- (void)refreshViewUI{
    
    CGRect frame = self.userAvatarImageView.frame;
    self.userAvatarImageView.layer.cornerRadius = frame.size.width/2;
    self.userAvatarImageView.layer.masksToBounds = YES;
    self.userAvatarImageView.clipsToBounds = YES;
    self.userAvatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.userAvatarImageView sd_setImageWithURL:_userInfo.smallAvatarUrl placeholderImage:[UIImage imageNamed:nil]];
    
    self.userNameLabel.text = _userInfo.nickName;
    self.userIntegralLabel.text = [NSString stringWithFormat:@"可用微积分：%d",_userInfo.wjf];
    
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
    credit = _userInfo.buyercredit;
    for (UIView *view in self.buyerCreditView.subviews) {
        [view removeFromSuperview];
    }
    for (int index = 0; index < credit; index ++ ) {
        UIImageView *creditImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jf_ buyercredit_icon.png"]];
        creditImageView.frame = CGRectMake((creditImageSize.width+1)*index, (self.buyerCreditView.frame.size.height-creditImageSize.height)/2, creditImageSize.width, creditImageSize.height);
        [self.buyerCreditView addSubview:creditImageView];
    }
    
    self.tableView.tableHeaderView = self.headView;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];
    
}

#pragma mark - IBAction
-(IBAction)myAccountAction:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    NSInteger bTag = button.tag;
    switch (bTag) {
        case 1:{
            AccountDetailsViewController *accountDetailsVc = [[AccountDetailsViewController alloc] init];
            accountDetailsVc.hidesBottomBarWhenPushed = YES;
            accountDetailsVc.userInfo = _userInfo;
            [self.navigationController pushViewController:accountDetailsVc animated:YES];
        }
            break;
        case 2:{
            FriendListController *listVC = [[FriendListController alloc] init];
            listVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:listVC animated:YES];

        }
            break;
        case 3:{
            MinePrizeViewController *vc = [[MinePrizeViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:{
            RankListViewController *vc = [[RankListViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:{
//#warning 测试登录入口
//            LoginViewController *loginVC = [[LoginViewController alloc] init];
//            loginVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:loginVC animated:YES];
            
            PromotionViewController *vc = [[PromotionViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:{
            MessageListViewController *listVC = [[MessageListViewController alloc] init];
            listVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:listVC animated:YES];

        }
            break;
        default:
            break;
    }
    
}

- (IBAction)personalProfileAction:(id)sender {
    
    PersonalProfileViewController *personalProfileVC = [[PersonalProfileViewController alloc] init];
    personalProfileVC.hidesBottomBarWhenPushed = YES;
    personalProfileVC.userInfo = _userInfo;
    personalProfileVC.userId = _userInfo.uid;
    [self.navigationController pushViewController:personalProfileVC animated:YES];
    
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
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
