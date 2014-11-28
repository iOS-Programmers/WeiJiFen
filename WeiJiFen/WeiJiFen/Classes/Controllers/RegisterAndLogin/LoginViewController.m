//
//  LoginViewController.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "LoginViewController.h"
#import "AccountDetailsViewController.h"
#import "RegisterController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *rememberPWBtn;

- (IBAction)rememberPWAction:(id)sender;
- (IBAction)loginAction:(id)sender;
- (IBAction)registerAction:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //如果钥匙串中有保存账号密码，则给予显示
    NSString *userName = [SSKeychain passwordForService:@"com.weijifen"account:@"username"];
    NSString *passWord = [SSKeychain passwordForService:@"com.weijifen"account:@"password"];


    if (!FBIsEmpty(userName)) {
        self.userNameTF.text = userName;
    }
    if (!FBIsEmpty(passWord)) {
        self.passwordTF.text = passWord;
    }
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

#pragma mark - IBAction
- (IBAction)rememberPWAction:(id)sender {

    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
}


-(IBAction)loginAction:(id)sender{
    
    if (FBIsEmpty(self.userNameTF.text)) {
        [self showWithText:@"请输入用户名"];
        return;
    }
    if (FBIsEmpty(self.passwordTF.text)) {
        [self showWithText:@"请输入密码"];
        return;
    }
    
    [self.view endEditing:YES];
    
    __weak LoginViewController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    
    [[WeiJiFenEngine shareInstance] logInUserInfo:self.userNameTF.text token:nil password:self.passwordTF.text confirm:WJF_Confirm tag:tag];
//    [[WeiJiFenEngine shareInstance] logInUserInfo:@"wjf125" token:nil password:@"123456" confirm:WJF_Confirm tag:tag];

    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
            return;
        }
        
        //如果勾选记住密码，则保存
        if (self.rememberPWBtn.selected) {
            //登陆成功后，保存用户名跟密码到钥匙串里
            [SSKeychain setPassword:self.userNameTF.text forService:@"com.weijifen" account:@"username"];
            [SSKeychain setPassword:self.passwordTF.text forService:@"com.weijifen" account:@"password"];
        }
        
        /**
         *  请求成功后，把服务端返回的信息存起来
         */
        NSDictionary *dataDic = [jsonRet objectForKey:@"data"];
        
        /**
         *  登录成功后把token存起来
         */
        NSString *tokenStr = [jsonRet objectForKey:@"token"];
        if (!FBIsEmpty(tokenStr)) {
            [WeiJiFenEngine saveUserToken:tokenStr];
        }
        
        JFUserInfo *userInfo = [[JFUserInfo alloc] init];
        [userInfo setUserInfoByJsonDic:dataDic];
        [[WeiJiFenEngine shareInstance] setUserInfo:userInfo];
        
        [weakSelf loginSuccess];
        
    } tag:tag];
    
}

/**
 *  这里进行登录成功之后的操作
 */
- (void)loginSuccess
{
    
}

/**
 *  点击注册
 *
 *  @param sender 
 */
- (IBAction)registerAction:(id)sender {

    RegisterController *regVC = [[RegisterController alloc] init];
    [self.navigationController pushViewController:regVC animated:YES];
}

@end
