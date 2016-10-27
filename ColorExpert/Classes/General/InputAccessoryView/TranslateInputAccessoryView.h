//
//  TranslateInputAccessoryView.h
//  DishDict
//
//  Created by JC_Hu on 15/12/8.
//  Copyright © 2015年 Tubban. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^InputBlock)(NSString *text);

@interface TranslateInputAccessoryView : UIView

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, copy) InputBlock inputBlock;

- (void)setInputBlock:(InputBlock)inputBlock;

@end
