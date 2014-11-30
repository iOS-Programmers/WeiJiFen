//
//  JFInputWindow.h
//  WeiJiFen
//
//  Created by liguangjun on 14-11-30.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum InputType_{
    InputType_Nomal = 0,
    InputType_Title,
}InputType;

@protocol JFInputWindowDelegate;

@interface JFInputWindow : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) InputType inputType;
@property (nonatomic, assign) id<JFInputWindowDelegate>delegate;

-(void)loadInputView;
-(void)hiddenActionSheet;

@end

@protocol JFInputWindowDelegate <NSObject>
@optional

-(void)publishActionWithJFInputWindow:(JFInputWindow *)inputView title:(NSString *)title content:(NSString *)content;

@end