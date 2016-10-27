//
//  Created by JC_Hu on 15/5/20.
//  Copyright (c) 2015年 JingchenHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Judge)



/// 截取指定字符长度的字符串（中文算两位）
- (NSString *)substringWithLength:(int)length;

/// 计算字符长度（中文算两位）
- (NSUInteger)lengthFixed;


#pragma mark - 正则
/*
 *  用正则判断用户名，是否4－16位
 */
- (BOOL) isValidUserName;

/*
 *  用正则判断邮箱
 */
- (BOOL) isValidEmail;

/*
 *  用正则判断密码，是否6－18位
 */
- (BOOL) isValidPassword;


/*
 *  用正则判断手机号
 */
- (BOOL)isMobileNumber;


/*
 *  判断字符串是否是数字组成
 */
- (BOOL)isNumberStr;

/*
 *  判断是否是身份证
 *  需要-(BOOL)isNumberStr:(NSString*)string配合
 */
-(BOOL)isPersonCard;



@end
