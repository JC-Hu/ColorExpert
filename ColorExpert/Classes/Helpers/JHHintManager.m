//
//  JHHintManager.m
//  ColorExpert
//
//  Created by JasonHu on 2017/8/16.
//  Copyright © 2017年 Jason Hu. All rights reserved.
//

#import "JHHintManager.h"

@implementation JHHintManager


+ (BOOL)shouldShowHintForPoint:(JHHintPoint)point
{
    NSNumber *haveRead = [[self hintPointRecordDict] objectForKey:[self keyForPoint:point]];
    
    if (haveRead) {
        return !haveRead.boolValue;
    }
    return YES;
}

+ (void)haveReadHintForPoint:(JHHintPoint)point
{
    NSMutableDictionary *dict = [self hintPointRecordDict];
    
    [dict setValue:@(1) forKey:[self keyForPoint:point]];
    
    [self saveHintPointRecordDict:dict];
}
#pragma mark -


+ (NSMutableDictionary *)hintPointRecordDict
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:JH_HINT_POINT_KEY];
    
    if (!dict) {
        dict = @{};

        [self saveHintPointRecordDict:dict];
    }
    return [NSMutableDictionary dictionaryWithDictionary:dict];
}

+ (void)saveHintPointRecordDict:(NSDictionary *)dict
{
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:JH_HINT_POINT_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)keyForPoint:(JHHintPoint)point
{
    NSString *str = nil;
    
    switch (point) {
        case JHHintPointRemoveAdButton:
            str = @"JHHintPointRemoveAdButton";
            break;
            
        case JHHintPointSwithFormButton:
            str = @"JHHintPointSwithFormButton";
            break;
            
        default:
            break;
    }
    
    NSAssert(str.length, @"Error");
    
    return str;
}




@end
