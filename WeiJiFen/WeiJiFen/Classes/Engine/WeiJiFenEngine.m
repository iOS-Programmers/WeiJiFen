//
//  WeiJiFenEngine.m
//  WeiJiFen
//
//  Created by 李 广军 on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "WeiJiFenEngine.h"

static WeiJiFenEngine* s_ShareInstance = nil;

@interface WeiJiFenEngine (){
    
}

@end

@implementation WeiJiFenEngine

+ (WeiJiFenEngine*)shareInstance{
    @synchronized(self) {
        if (s_ShareInstance == nil) {
            s_ShareInstance = [[WeiJiFenEngine alloc] init];
        }
    }
    return s_ShareInstance;
}

-(id)init{
    self = [super init];
    
#ifdef DEBUG
    
#endif
    
    return self;
}

@end
