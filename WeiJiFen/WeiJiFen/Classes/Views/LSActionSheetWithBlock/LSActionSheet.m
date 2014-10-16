//
//  LSActionSheet.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-16.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "LSActionSheet.h"

@interface LSActionSheet()<UIActionSheetDelegate>

@property (nonatomic, strong) LSActionSheetBlcok clickBlock;
@end

@implementation LSActionSheet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//init action with block
-(id)initWithTitle:(NSString *)title actionBlock:(LSActionSheetBlcok) actionBlock cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    if(self){
        _clickBlock = actionBlock;
        va_list strButtonNameList;
        va_start(strButtonNameList, otherButtonTitles);
        for (NSString *strBtnTitle = otherButtonTitles; strBtnTitle != nil; strBtnTitle = va_arg(strButtonNameList, NSString*))
        {
            [self addButtonWithTitle:strBtnTitle];
        }
        va_end(strButtonNameList);
        
        if (destructiveButtonTitle.length > 0) {
            [self addButtonWithTitle:destructiveButtonTitle];
            self.destructiveButtonIndex = self.numberOfButtons - 1;
        }
        
        //默认都是有取消
        if (cancelButtonTitle.length > 0) {
            [self addButtonWithTitle:cancelButtonTitle];
            self.cancelButtonIndex = self.numberOfButtons - 1;
        }
    }
    
    return self;
}

-(id) initWithTitle:(NSString *)title actionBlock:(LSActionSheetBlcok)actionBlock
{
    return [self initWithTitle:title actionBlock:actionBlock cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
}

#pragma mark - Delegates
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //如果是取消就直接返回
    //    if (buttonIndex == actionSheet.cancelButtonIndex) {
    //        return;
    //    }
    
    if (self.clickBlock)
        self.clickBlock(buttonIndex);
}

@end
