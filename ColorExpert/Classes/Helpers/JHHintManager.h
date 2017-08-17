//
//  JHHintManager.h
//  ColorExpert
//
//  Created by JasonHu on 2017/8/16.
//  Copyright © 2017年 Jason Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    JHHintPointSwithFormButton,
    JHHintPointRemoveAdButton
} JHHintPoint;

#define JH_HINT_POINT_KEY @"JHHintManager.hintPointKey"

@interface JHHintManager : NSObject

+ (BOOL)shouldShowHintForPoint:(JHHintPoint)point;
+ (void)haveReadHintForPoint:(JHHintPoint)point;
@end
