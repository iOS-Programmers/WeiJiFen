//
//  JFUserInfo.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-16.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "JFUserInfo.h"
#import "JSONKit.h"
#import "LSCommonUtils.h"

@interface JFUserInfo () {
    
}
@end

@implementation JFUserInfo

- (void)doSetUserInfoByJsonDic:(NSDictionary*)dic {
    
    if ([dic objectForKey:@"username"]) {
        _nickName = [[dic objectForKey:@"username"] description];
    }
    if ([dic objectForKey:@"mobile"]) {
        _phone = [[dic objectForKey:@"mobile"] description];
    }
    if ([dic objectForKey:@"realname"]) {
        _realname = [[dic objectForKey:@"realname"] description];
    }
    if ([dic objectForKey:@"qq"]) {
        _qqNumber = [[dic objectForKey:@"qq"] description];
    }
    if ([dic objectForKey:@"taobao"]) {
        _taobao = [[dic objectForKey:@"taobao"] description];
    }
    if ([dic objectForKey:@"email"]) {
        _email = [[dic objectForKey:@"email"] description];
    }
    if ([dic objectForKey:@"address"]) {
        _address = [[dic objectForKey:@"address"] description];
    }
    
    id objectForKey = [dic objectForKey:@"avatar"];
    if (objectForKey && [objectForKey isKindOfClass:[NSString class]]) {
        _smallAvatarUrl = [NSURL URLWithString:objectForKey];
    }
    _wjf = [[dic objectForKey:@"wjf"] intValue];
    _buyercredit = [[dic objectForKey:@"buyercredit"] intValue];
    _sellercredit = [[dic objectForKey:@"sellercredit"] intValue];
    _friends = [[dic objectForKey:@"friends"] intValue];
    
    
    //    if ([dic objectForKey:@"gender"]) {
    //        _gender = [dic objectForKey:@"gender"];
    //    }
    //    if ([dic objectForKey:@"signature"]) {
    //        _signature = [dic objectForKey:@"signature"];
    //    }
    //    if ([dic objectForKey:@"birthday"]) {
    //        self.birthdayString = [dic objectForKey:@"birthday"];
    //    }
    
}
- (void)setUserInfoByJsonDic:(NSDictionary*)dic{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _userInfoByJsonDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    _uid = [[dic objectForKey:@"member_id"] description];
    
    @try {
        [self doSetUserInfoByJsonDic:dic];
    }
    @catch (NSException *exception) {
        NSLog(@"####JFUserInfo setUserInfoByJsonDic exception:%@", exception);
    }
    
    self.jsonString = [_userInfoByJsonDic JSONString];
}

- (void)setOtherUserInfoByJsonDic:(NSDictionary*)dic{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _otherUserInfoByJsonDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    _uid = [[dic objectForKey:@"uid"] description];
    
    @try {
        [self doSetUserInfoByJsonDic:dic];
    }
    @catch (NSException *exception) {
        NSLog(@"####JFUserInfo setOtherUserInfoByJsonDic exception:%@", exception);
    }
    
    self.jsonString = [_otherUserInfoByJsonDic JSONString];
}

- (void)setBirthdayString:(NSString *)birthdayString{
    
    NSArray* items = [birthdayString componentsSeparatedByString:@"-"];
    if (items.count != 3) {
        return;
    }
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:[[items objectAtIndex:2] integerValue]];
    [comps setMonth:[[items objectAtIndex:1] integerValue]];
    [comps setYear:[[items objectAtIndex:0] integerValue]];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [gregorian dateFromComponents:comps];
    
    _birthdayDate = date;
    _birthdayString = birthdayString;
}

- (int)age{
    if (!_birthdayDate) {
        return 0;
    }
    return [LSCommonUtils getAgeByDate:_birthdayDate];
}

@end
