//
//  LSCommonUtils.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "LSCommonUtils.h"

@implementation LSCommonUtils

//是否为ios7及以上
+(BOOL) isUpperSDK
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        return YES;
    }
    return NO;
}

//Load view from nib file
+(id)loadViewFromNibNamed:(NSString*)nibName {
    NSArray *objectsInNib = [[NSBundle mainBundle] loadNibNamed:nibName
                                                          owner:nil
                                                        options:nil];
    assert( objectsInNib.count == 1);
    return [objectsInNib objectAtIndex:0];
}

//程序主颜色
+(UIColor*)getProgramMainHueColor{
    UIColor *color = UIColorRGB(254,120,31);
    return color;
}

@end
