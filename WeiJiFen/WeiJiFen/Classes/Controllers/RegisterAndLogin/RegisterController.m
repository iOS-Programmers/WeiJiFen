//
//  RegisterController.m
//  WeiJiFen
//
//  Created by Jyh on 14/11/27.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "RegisterController.h"
#import "AppDelegate.h"

@interface RegisterController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *rePasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;

- (IBAction)registerAction:(id)sender;

@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    self.title = @"注册账号";
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

- (IBAction)registerAction:(id)sender {
    
    if (FBIsEmpty(self.userNameTF.text)) {
        [self showWithText:@"请输入用户名"];
        return;
    }
    if (FBIsEmpty(self.passwordTF.text)) {
        [self showWithText:@"请输入密码"];
        return;
    }

    if (![self.passwordTF.text isEqualToString:self.rePasswordTF.text]) {
        [self showWithText:@"两次输入密码不一致"];
        return;
    }
    
    if (FBIsEmpty(self.phoneNumberTF.text)) {
        [self showWithText:@"请输入手机号"];
        return;
    }
    
    __weak RegisterController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    
    [[WeiJiFenEngine shareInstance] registerUserInfo:self.userNameTF.text mobile:self.phoneNumberTF.text password:self.passwordTF.text confirm:[WeiJiFenEngine shareInstance].confirm tag:tag];

    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
            return;
        }
        NSDictionary *dataDic = [jsonRet objectForKey:@"data"];
        JFUserInfo *userInfo = [[JFUserInfo alloc] init];
        [userInfo setUserInfoByJsonDic:dataDic];
        [[WeiJiFenEngine shareInstance] setUserInfo:userInfo];
       
        [weakSelf registerSuccess];
        
    } tag:tag];
    
}

/**
 *  注册成功后的操作
 */
- (void)registerSuccess
{
    //注册成功后要调用下登录接口
    __weak RegisterController *weakSelf = self;
    int tag = [[WeiJiFenEngine shareInstance] getConnectTag];
    
    [[WeiJiFenEngine shareInstance] logInUserInfo:self.userNameTF.text token:nil password:self.passwordTF.text confirm:[WeiJiFenEngine shareInstance].confirm tag:tag];

    [[WeiJiFenEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WeiJiFenEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            [LSCommonUtils showWarningTip:errorMsg At:weakSelf.view];
            return;
        }
        

            //登录成功后，保存用户名跟密码到钥匙串里
        [SSKeychain setPassword:self.userNameTF.text forService:@"com.weijifen" account:@"username"];
        [SSKeychain setPassword:self.passwordTF.text forService:@"com.weijifen" account:@"password"];
    
        
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
        [WeiJiFenEngine shareInstance].userPassword = self.passwordTF.text;
        [[WeiJiFenEngine shareInstance] setUserInfo:userInfo];
        [[WeiJiFenEngine shareInstance] saveAccount];
        
        [weakSelf loginAction];
        
    } tag:tag];

}

- (void)loginAction
{
//    AppDelegate* appDelegate = (AppDelegate* )[[UIApplication sharedApplication] delegate];
//    [appDelegate signIn];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
