//
//  Created by JC_Hu on 15/5/20.
//  Copyright (c) 2015年 JingchenHu. All rights reserved.
//

#import "NSString+Judge.h"

@implementation NSString (Judge)

/// 截取指定字符长度的字符串（中文算两位）
-(NSString *)substringWithLength:(int)length
{
    NSString *substring = @"";
    
    if (length < 1 || self.length == 0) {
        return substring;
    }
    
    
    for (int i = 0; i < self.length; i++) {
        
        substring = [self substringToIndex:i + 1];
        
        if ([substring lengthFixed] > length) {
            substring = [self substringToIndex:i];
            break;
        }
    }
    return substring;
}

/// 计算字符长度（中文算两位）
- (NSUInteger)lengthFixed

{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [self dataUsingEncoding:enc];
    
    NSUInteger l = [da length];
    return l;
}

/*
 *  用正则判断用户名，是否1－6位（中文算一位）
 */
- (BOOL) isValidUserName
{
    NSString *Regex = @"^\\w{1,6}$";
    NSPredicate *userName = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [userName evaluateWithObject:self];
}


/*
 *  用正则判断邮箱
 */
- (BOOL) isValidEmail
{
    NSString *Regex = @"[A-Z0-9a-z._%--]-@[A-Za-z0-9.-]-\\.[A-Za-z]{2,4}";
    NSPredicate *email = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [email evaluateWithObject:self];
}

/*
 *  用正则判断密码，是否6－12位
 */
- (BOOL) isValidPassword
{
    NSString *Regex = @"\\w{6,12}";
    NSPredicate *password = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [password evaluateWithObject:self];
}



- (BOOL)isMobileNumber
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|4[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|7[0-9]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    // 新添加
    NSString *newString = @"(13[0-9]|15[0-9]|18[0-9]|14[0-9]|17[0-9])[0-9]{8}$";
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", newString];
    
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES)
        || ([newPredicate evaluateWithObject:self] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


/*
 *  判断字符串是否是数字组成
 */
- (BOOL)isNumberStr
{
    NSString *number =@"0123456789";
    NSCharacterSet * cs =[[NSCharacterSet characterSetWithCharactersInString:number]invertedSet];
    NSString * comparStr = [[self componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    return [self isEqualToString:comparStr];
}



/*
 *  判断是否是身份证
 *  需要-(BOOL)isNumberStr:(NSString*)string配合
 */
-(BOOL)isPersonCard
{
    //    NSLog(@"%d",[self length]);
    if ([self length]!= 15 && [self length] != 18)
    {
        return NO;
    }
    else if ( ([self length] == 18 ||[self length] ==15) && [self isNumberStr])
    {
        return YES;
    }
    else if ([self length] == 18  && ([[self substringToIndex:17] isNumberStr] && ([self hasSuffix:@"X"] || [self hasSuffix:@"x"])))
    {
        return YES;
    }
    else
    {
        return NO;
    }
    //    return [string isMatchedByRegex:@"^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}((19\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|(19\\d{2}(0[13578]|1[02])31)|(19\\d{2}02(0[1-9]|1\\d|2[0-8]))|(19([13579][26]|[2468][048]|0[48])0229))\\d{3}(\\d|X|x)?$"];
}


@end
