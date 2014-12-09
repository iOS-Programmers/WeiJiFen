//
//  AccountDetailsViewController.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-29.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "AccountDetailsViewController.h"
#import "UIImageView+WebCache.h"

@interface AccountDetailsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation AccountDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.dataSource = [[NSMutableArray alloc] init];
    self.title = @"我的资料";
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = view;
    
    UIEdgeInsets inset = self.tableView.contentInset;
    if (inset.top == 0) {
        inset.top += 10;
    }
    [self setContentInsetForScrollView:self.tableView inset:inset];
    
    [self customDataSource];
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
    
    JFUserInfo *oldUserInfo = _userInfo;
    _userInfo = [[JFUserInfo alloc] init];
    _userInfo.uid = oldUserInfo.uid;
    if (_userInfo.uid.length == 0) {
        [LSCommonUtils showWarningTip:@"用户不存在" At:self.view];
        return;
    }
    
    __weak AccountDetailsViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] getMyProfileWithUserId:_userInfo.uid tag:tag];
    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
            return;
        }
        
        NSDictionary *dic = [jsonRet dictionaryObjectForKey:@"data"];
        [weakSelf.userInfo setOtherUserInfoByJsonDic:dic];
        [weakSelf customDataSource];
        
    } tag:tag];
    
}

-(void)customDataSource{
    
    self.dataSource = [[NSMutableArray alloc] initWithArray:@[@{@"title":@"头像",@"content":[_userInfo.smallAvatarUrl absoluteString]!=nil?[_userInfo.smallAvatarUrl absoluteString]:@""},@{@"title":@"用户名",@"content":_userInfo.nickName!=nil?_userInfo.nickName:@""},@{@"title":@"真实姓名",@"content":_userInfo.realname!=nil?_userInfo.realname:@""},@{@"title":@"手机",@"content":_userInfo.phone!=nil?_userInfo.phone:@""},@{@"title":@"QQ",@"content":_userInfo.qqNumber!=nil?_userInfo.qqNumber:@""},@{@"title":@"阿里旺旺",@"content":_userInfo.taobao!=nil?_userInfo.taobao:@""},@{@"title":@"E-mail",@"content":_userInfo.email!=nil?_userInfo.email:@""},@{@"title":@"居住地",@"content":_userInfo.address!=nil?_userInfo.address:@""}]];
    [self.tableView reloadData];
}

-(void)updateAvatar{
    
    __weak AccountDetailsViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    [[WeiJiFenEngine shareInstance] avatarUploadWith:nil tag:tag];
    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
            return;
        }
        
    } tag:tag];
    
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataSource.count - 1) {
        return 60;
    }
    return 32;
}

static int userAvatarImageView_tag = 102;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentfier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
        UIImageView *userAvatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(278, 0, 29, 29)];
        userAvatarImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.size.width/2;
        userAvatarImageView.layer.masksToBounds = YES;
        userAvatarImageView.clipsToBounds = YES;
        userAvatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        userAvatarImageView.tag = userAvatarImageView_tag;
        [cell addSubview:userAvatarImageView];
        
    }
    cell.textLabel.textColor = [LSCommonUtils colorWithHexString:@"686868"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:13];
    
    NSDictionary *userDic = self.dataSource[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@:  %@",[userDic stringObjectForKey:@"title"],[userDic stringObjectForKey:@"content"]];
    
    UIImageView *userAvatarImageView = (UIImageView *)[cell viewWithTag:userAvatarImageView_tag];
    userAvatarImageView.hidden = YES;
    if (indexPath.row == 0) {
        userAvatarImageView.hidden = NO;
        [userAvatarImageView sd_setImageWithURL:[NSURL URLWithString:[userDic stringObjectForKey:@"content"]] placeholderImage:[UIImage imageNamed:@"jf_message_icon.png"]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@:",[userDic stringObjectForKey:@"title"]];
    }
    
    return cell;
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
