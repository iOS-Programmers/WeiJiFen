//
//  LSCommonUtils.h
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSCommonUtils : NSObject

+(BOOL) isUpperSDK;
//通过xib文件加载view
+(id)loadViewFromNibNamed:(NSString*)nibName;
//程序主颜色
+(UIColor*)getProgramMainHueColor;
//MB提示
+(void)showWarningTip:(NSString *)tip At:(UIView *)view;
+(void)showWarningTip:(NSString *)tip customImage:(UIImage *)customImage At:(UIView *)view;

//text字数
+ (UInt32)getHanziTextNum:(NSString*)text;
+ (UInt32)getDistinctAsciiTextNum:(NSString*)text;
//text截取
+ (NSString*)getHanziTextWithText:(NSString*)text maxLength:(UInt32)maxLength;
@end
