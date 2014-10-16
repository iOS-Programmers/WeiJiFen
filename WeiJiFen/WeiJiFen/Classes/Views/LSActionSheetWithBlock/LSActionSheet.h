//
//  LSActionSheet.h
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-16.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

//点击buttonIndex
typedef void (^LSActionSheetBlcok) (NSInteger buttonIndex);

@interface LSActionSheet : UIActionSheet

//init action with block
-(id)initWithTitle:(NSString *)title actionBlock:(LSActionSheetBlcok) actionBlock cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;

-(id) initWithTitle:(NSString *)title actionBlock:(LSActionSheetBlcok)actionBlock;

@end
