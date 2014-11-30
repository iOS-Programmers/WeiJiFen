//
//  LSCommonUtils.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "LSCommonUtils.h"
#import "MBProgressHUD.h"



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
//标题颜色
+(UIColor*)getProgramMainTitleColor{
    return UIColorRGB(103, 103, 103);
}
//灰色背景
+(UIColor*)getProgramMainDaryColor{
    return UIColorRGB(238,238,238);
}

+(void)showWarningTip:(NSString *)tip At:(UIView *)view{
    [self showWarningTip:tip customImage:nil At:view];
}

+(void)showWarningTip:(NSString *)tip customImage:(UIImage *)customImage At:(UIView *)view{
    if (!view) {
        return;
    }
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:view];
    [view  addSubview:hud];
    if (!customImage) {
        customImage = [UIImage imageNamed:@"s_icon_warning.png"];
    }
    hud.customView = [[UIImageView alloc] initWithImage:customImage];
    hud.mode = MBProgressHUDModeCustomView;
    hud.detailsLabelText = tip;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    [hud hide:YES afterDelay:[self errorMsgShowDelayTimeWithErrMsg:tip]];
}

+ (NSTimeInterval)errorMsgShowDelayTimeWithErrMsg:(NSString *)errMsg {
    int textNum = [LSCommonUtils getHanziTextNum:errMsg];
    if (textNum > 30) {
        return 3.0;
    } else if (textNum > 20) {
        return 2.0;
    }
    return 1.5;
}
+ (UInt32)getDistinctAsciiTextNum:(NSString*)text {
    UInt32 count = 0;
    
    for (int i = 0; i < text.length; ++i) {
        unichar c = [text characterAtIndex:i];
        if (c < 128) {
            count += 1;
        } else {
            count += 2;
        }
    }
    
    return count;
}
+ (UInt32)getHanziTextNum:(NSString*)text {
    UInt32 count = [LSCommonUtils getDistinctAsciiTextNum:text];
    return (count/2 + count%2);
}

+ (NSString*)getHanziTextWithText:(NSString*)text maxLength:(UInt32)maxLength {
    UInt32 count = 0;
    
    for (int i = 0; i < text.length; ++i) {
        unichar c = [text characterAtIndex:i];
        if (c < 128) {
            count += 1;
        } else {
            count += 2;
        }
        if ((count/2 + count%2) > maxLength) {
            //判断截取的最后几个字符是不是emoji表情，如果是emoji表情要把表情整体截取，不然会出现乱码的情况
            //emoji最多占用4个unicode码，所以index回退3个
            int backIndex = (i - 3) >0 ? (i - 3):0;
            for (int j = backIndex; j < text.length; ++j) {
                NSRange range = [text rangeOfComposedCharacterSequenceAtIndex:j];
                if (range.length > 1) {
                    if (range.location + range.length > i) {
                        return [text substringToIndex:range.location];
                    }
                    j = (int)range.location + (int)range.length;
                }
            }
            
            return [text substringToIndex:i];
        }
    }
    return text;
}

+ (int)getAgeByDate:(NSDate*)date{
    NSDate* nowDate = [NSDate date];
    NSCalendar * calender = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents *comps = [calender components:unitFlags fromDate:date];
    NSDateComponents *compsNow = [calender components:unitFlags fromDate:nowDate];
    return (int)compsNow.year - (int)comps.year;
}

+(NSDateFormatter *) dateFormatterOFUS {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE MMM d HH:mm:ss zzzz yyyy"];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    return dateFormatter;
}
//显示年月日时分
+(NSString *)dateDiscriptionFromDate:(NSDate *)date
{
    NSString *ts;
    if (date == nil) {
        return @"";
    }
    NSCalendar * calender = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit ;
    NSDateComponents *comps = [calender components:unitFlags fromDate:date];
    ts = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d", comps.year, comps.month, comps.day, comps.hour, comps.minute];
    return ts;
}

#pragma mark - 时间处理
+ (NSString *)secondChangToDateString:(NSString *)dateStr {
    
    if (FBIsEmpty(dateStr)) {
        return @"";
    }
    
    long long time = [dateStr longLongValue];
    
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    NSString *timeString=[dateFormatter stringFromDate:date];
    return timeString;
}

+ (NSString *)secondChangToDate:(NSString *)dateStr {
    
    if (FBIsEmpty(dateStr)) {
        return @"";
    }
    
    long long time = [dateStr longLongValue];
    
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSString * timeString=[dateFormatter stringFromDate:date];
    
    return timeString;
}

+ (NSString *)secondChangToYearMonth:(NSString *)dateStr
{
    if (FBIsEmpty(dateStr)) {
        return @"";
    }
    
    long long time = [dateStr longLongValue];
    
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM";
    
    NSString * timeString=[dateFormatter stringFromDate:date];
    
    return timeString;
}

+ (UIColor *)colorWithHexString:(NSString *) stringToConvert
{
    //    if (FBIsEmpty(stringToConvert))
    //    {return nil;}
    
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor clearColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

//重新计算textview的contentSzie，因为ios7的textview 杉ContentSzie在textviewDidChange之后执行了，所以文本变化不会去改变ContentSize了
+(CGFloat) calculateTextViewHeight:(UITextView *) textView
{
    //ios7 就重新计算
    if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        CGRect txtFrame = textView.frame;
        //@"%@\n "
        return [[NSString stringWithFormat:@"%@\n ",textView.text]                boundingRectWithSize:CGSizeMake(txtFrame.size.width - textView.contentInset.left - textView.contentInset.right, CGFLOAT_MAX)
                                                                                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                            attributes:[NSDictionary dictionaryWithObjectsAndKeys:textView.font,NSFontAttributeName, nil] context:nil].size.height;
    }
    
    //ios6 及以前可以直接返回textview的contentSize
    return textView.contentSize.height ;
}

//因上面方法在计算时处于换行临界情况下时会出现误差，所以取两次计算结果大的一方
+(CGSize) reSizeTextViewContentSize:(UITextView *) textview
{
    if ([textview respondsToSelector:@selector(textContainerInset)]) {
        //防止光标在中间时会有问题，先把原即是位置记录下来，把光标移动到最后
        NSRange oringalRange = textview.selectedRange;
        textview.selectedRange = NSMakeRange(textview.text.length, 0);
        CGRect line = [textview caretRectForPosition:
                       textview.selectedTextRange.start];
        
        UIEdgeInsets inset = textview.textContainerInset;
        CGSize newSize = CGSizeMake(ceil(line.size.width)  + inset.left + inset.right,
                                    ceil(line.size.height + line.origin.y) + inset.top);
        textview.contentSize = newSize;
        
        //还原原始光标
        textview.selectedRange = oringalRange;
    }
    
    return textview.contentSize;
}
//计算textview的高度
+(CGFloat) calculateTextViewMaxHeight:(UITextView *) textview
{
    return [self calculateTextViewHeight:textview];
}

@end
