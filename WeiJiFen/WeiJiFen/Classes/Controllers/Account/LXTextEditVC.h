//
//  LXTextEditVC.h
//  Chemayi_iPhone2.0
//
//  Created by Bird on 14-9-20.
//  Copyright (c) 2014年 LianXian. All rights reserved.
//

#import "HTBaseViewController.h"
typedef void (^EditBackBlock) (NSString *a);

@interface LXTextEditVC : HTBaseViewController
{
    EditBackBlock backBlock;
}
@property (nonatomic,copy)NSString *holderStr;//
@property (nonatomic,copy)NSString *titleStr;//
@property (nonatomic)NSInteger titleType;//键盘输入类型
- (void)setBackBlock:(EditBackBlock)block;


@end
