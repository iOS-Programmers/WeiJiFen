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
//标题颜色
+(UIColor*)getProgramMainTitleColor;
//灰色背景
+(UIColor*)getProgramMainDaryColor;

//MB提示
+(void)showWarningTip:(NSString *)tip At:(UIView *)view;
+(void)showWarningTip:(NSString *)tip customImage:(UIImage *)customImage At:(UIView *)view;

//text字数
+ (UInt32)getHanziTextNum:(NSString*)text;
+ (UInt32)getDistinctAsciiTextNum:(NSString*)text;
//text截取
+ (NSString*)getHanziTextWithText:(NSString*)text maxLength:(UInt32)maxLength;

//获取年龄
+ (int)getAgeByDate:(NSDate*)date;
+(NSDateFormatter *) dateFormatterOFUS;
//显示年月日时分
+(NSString *)dateDiscriptionFromDate:(NSDate *)date;
#pragma mark - 时间处理
/**
 *  把秒转成  yyyy-MM-dd HH:mm 格式
 *
 *  @param dateStr 秒的字符串
 *
 *  @return  yyyy-MM-dd HH:mm
 */
+ (NSString *)secondChangToDateString:(NSString *)dateStr;

/**
 *  把秒转成  yyyy-MM-dd 格式
 *
 */
+ (NSString *)secondChangToDate:(NSString *)dateStr;

/**
 *  把秒转成 yyyy-MM 格式
 *
 */
+ (NSString *)secondChangToYearMonth:(NSString *)dateStr;

/**
 *  16进制颜色转换
 *
 *  @param stringToConvert 16进制的颜色
 */
+ (UIColor *)colorWithHexString:(NSString *) stringToConvert;
@end
