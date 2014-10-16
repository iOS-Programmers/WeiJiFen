//
//  JFTabBarView.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "JFTabBarView.h"

@implementation JFTabBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setItems:(NSArray *)newItems{
    for (JFTabBarItemView *tabBarItem in self.items) {
        [tabBarItem removeFromSuperview];
    }
    _items = [NSArray arrayWithArray:newItems];
    
    if ([self.items count]) {
        [(JFTabBarItemView *)[self.items objectAtIndex:self.initialIndex] setSelected:YES];
//        self.selectedTabBarItem = [self.items objectAtIndex:self.initialIndex];
        [self.delegate tabBar:self didSelectTabAtIndex:self.initialIndex];
    }
    for (JFTabBarItemView *tabBarItem in self.items) {
        tabBarItem.userInteractionEnabled = YES;
        tabBarItem.delegate = self;
    }
    [self setNeedsLayout];
}
-(void)selectForItemView:(id)view{
    
    JFTabBarItemView* sender = (JFTabBarItemView*)view;
    for (JFTabBarItemView *tab in self.items) {
        if (tab == sender) {
            continue;
        }
        tab.selected = NO;
    }
    if (!sender.selected) {
        sender.selected = YES;
    }
    [self.delegate tabBar:self didSelectTabAtIndex:[self.items indexOfObject:sender]];
    
}

#pragma mark - UIView
-(void) layoutSubviews {
    [super layoutSubviews];
    CGRect currentBounds = self.bounds;
    
    int width = self.bounds.size.width/self.items.count;
    currentBounds.size.width = width;
    int index = 0;
    for (JFTabBarItemView *tab in self.items) {
        if (index == self.items.count -1) {
            currentBounds.size.width += self.bounds.size.width - self.items.count*width;
        }
        tab.frame = currentBounds;
        currentBounds.origin.x += currentBounds.size.width;
        
        [self addSubview:tab];
        index++;
    }
    
//    [self.selectedTabBarItem setSelected:YES];
}

-(void) setFrame:(CGRect)aFrame {
    [super setFrame:aFrame];
    [self setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
