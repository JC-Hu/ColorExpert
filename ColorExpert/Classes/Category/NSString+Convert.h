//
//  Created by JC_Hu on 15/5/20.
//  Copyright (c) 2015年 JingchenHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Convert)

/// 将数字字符串转为1,123,123,000的形式
- (NSString *)convertToCountNumberFormat;

/// 将数字字符串转为1 123 123 000的形式
- (NSString *)convertToReadingNumberFormat;
@end
