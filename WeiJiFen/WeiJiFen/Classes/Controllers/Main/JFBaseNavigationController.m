//
//  JFBaseNavigationController.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-14.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "JFBaseNavigationController.h"

@interface JFBaseNavigationController ()

@end

@implementation JFBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

#pragma mark -- 禁止横竖屏切换
-(BOOL)shouldSupportRotate{
    if ([[self.viewControllers lastObject] isKindOfClass:NSClassFromString(@"LSMWPhotoBrowser")]
        ){
        return YES;
    }
    return NO;
}
//5.0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([self shouldSupportRotate]){
        return YES;
    }
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
//6.0
- (BOOL)shouldAutorotate{
    return [self shouldSupportRotate];
}
- (NSUInteger)supportedInterfaceOrientations{
    if ([self shouldSupportRotate])
        return UIInterfaceOrientationMaskAll;
    else
        return UIInterfaceOrientationMaskPortrait;
}

@end
