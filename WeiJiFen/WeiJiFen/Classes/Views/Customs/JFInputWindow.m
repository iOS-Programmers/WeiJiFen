//
//  JFInputWindow.m
//  WeiJiFen
//
//  Created by liguangjun on 14-11-30.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "JFInputWindow.h"

@interface JFInputWindow () <UITextFieldDelegate,UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *inputContView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *inputTitleView;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UIView *inputContentView;
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic) IBOutlet UIButton *publishButton;
- (IBAction)publishAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
@end

@implementation JFInputWindow

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)dealloc
{
    NSLog(@"JFInputWindow delloc \n\n\n\n");
    
}

-(void)loadInputView{
//    self.windowLevel = UIWindowLevelStatusBar + 3.0f;
    
    self.titleLabel.text = _title;
    
    self.inputTitleView.hidden = YES;
    CGRect frame = self.inputContentView.frame;
    frame.origin.y = self.inputTitleView.frame.origin.y;
    frame.size.height = 206;
    self.inputContentView.frame = frame;
    
    if (_inputType == InputType_Title) {
        self.inputTitleView.hidden = NO;
        frame = self.inputContentView.frame;
        frame.origin.y = self.inputTitleView.frame.origin.y + self.inputTitleView.frame.size.height + 6;
        frame.size.height = 175;
        self.inputContentView.frame = frame;
    }
    
    frame = self.inputContView.frame;
    frame.size.height = self.inputContentView.frame.origin.y + self.inputContentView.frame.size.height + 38;
    self.inputContView.frame = frame;
    
    [self addSubview:self.inputContView];
    
    CGRect sframe = self.inputContView.frame;
    sframe.origin.y -= sframe.size.height;
    self.inputContView.frame = sframe;
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [UIView animateWithDuration:.2 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
        
        CGRect sframe = self.inputContView.frame;
        sframe.origin.y = 0;
        self.inputContView.frame = sframe;
    }];
//    [self makeKeyAndVisible];
}

- (IBAction)publishAction:(id)sender {
    
    NSString *title = [self.titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *content = [self.contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (_inputType == InputType_Title) {
        if (title.length == 0) {
            [LSCommonUtils showWarningTip:@"标题必填" At:self];
            return;
        }
    }else if (_inputType == InputType_Nomal){
        if (content.length == 0) {
            [LSCommonUtils showWarningTip:@"请填写内容" At:self];
            return;
        }
    }
    if (title.length == 0) {
        title = nil;
    }
    if (content.length == 0) {
        content = nil;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(publishActionWithJFInputWindow:title:content:)]) {
        [self.delegate publishActionWithJFInputWindow:self title:title content:content];
    }
    
    [self hiddenActionSheet];
}

- (IBAction)cancelAction:(id)sender {
    [self hiddenActionSheet];
}
-(void)hiddenActionSheet{
    UIView *sheet = _inputContView;
    [UIView animateWithDuration:.2 animations:^{
        [sheet superview].backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        CGRect sframe = sheet.frame;
        sframe.origin.y -= sframe.size.height;
        sheet.frame = sframe;
    } completion:^(BOOL finished) {
//        UIView * supperWindow = (UIView*)[sheet superview];
//        supperWindow.hidden = YES;
        [self removeFromSuperview];
    }];
    
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self];
    UIView *sheet = _inputContView;
    float blank_max_y = [[UIScreen mainScreen] bounds].size.height-sheet.frame.origin.y - sheet.frame.size.height;
    if (currentLocation.y>blank_max_y) {
        [self hiddenActionSheet];
    }
}
@end
