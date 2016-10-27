//
//  Created by JC_Hu on 15/5/20.
//  Copyright (c) 2015年 JingchenHu. All rights reserved.
//

#import "NSString+Convert.h"

@implementation NSString (Convert)

/// 将数字字符串转为1,123,123,000的形式
- (NSString *)convertToCountNumberFormat
{
    NSString *num = self;
    
    if (!num) {
        return nil;
    }
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)    {
        count++;
        a /= 10;
    }
    
    num = [NSString stringWithFormat:@"%lld", num.longLongValue];
    
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
    
}


/// 将数字字符串转为 2011 2312 3000的形式
- (NSString *)convertToReadingNumberFormat
{
   
    NSUInteger count = self.length;
    
    NSMutableString *string = [NSMutableString stringWithString:self];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 4) {
        count -= 4;
        NSRange rang = NSMakeRange(string.length - 4, 4);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@" " atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
    
}



@end
