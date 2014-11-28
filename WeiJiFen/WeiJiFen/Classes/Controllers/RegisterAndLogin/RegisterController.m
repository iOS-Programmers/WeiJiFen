//
//  RegisterController.m
//  WeiJiFen
//
//  Created by Jyh on 14/11/27.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "RegisterController.h"

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
    
    [[WeiJiFenEngine shareInstance] registerUserInfo:self.userNameTF.text mobile:self.phoneNumberTF.text password:self.passwordTF.text confirm:WJF_Confirm tag:tag];

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
    
}
@end
