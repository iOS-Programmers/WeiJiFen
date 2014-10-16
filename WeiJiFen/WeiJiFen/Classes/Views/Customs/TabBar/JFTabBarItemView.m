//
//  JFTabBarItemView.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "JFTabBarItemView.h"

@interface JFTabBarItemView ()

- (IBAction)itemTouchDown:(id)sender;
@end

@implementation JFTabBarItemView

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

- (IBAction)itemTouchDown:(id)sender{
    if (self.delegate) {
        [self.delegate selectForItemView:self];
    }
}

-(void)setSelected:(bool)selected{
    self.itemBtn.selected = selected;
    if (selected) {
        self.itemBtn.backgroundColor = UIColorRGB(220,89,1);
    }else{
        self.itemBtn.backgroundColor = [UIColor clearColor];
    }
    //[self setNeedsLayout];
}

@end
