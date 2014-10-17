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
    ts = [NSString stringWithFormat:@"%04ld-%02ld-%02ld %02ld:%02ld", comps.year, comps.month, comps.day, comps.hour, comps.minute];
    return ts;
}

@end
