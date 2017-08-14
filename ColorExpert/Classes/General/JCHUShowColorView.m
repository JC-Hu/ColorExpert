//
//  JCHUShowColorView.m
//  playStoryBoard
//
//  Created by JC_Hu on 14/10/25.
//  Copyright (c) 2014年 Sixer.inc. All rights reserved.
//

#import "JCHUShowColorView.h"

@interface JCHUShowColorView ()

@property (nonatomic, strong) UIWindow *colorWindow;

@end

@implementation JCHUShowColorView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if (!self.tap) {
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        self.tap.numberOfTapsRequired = 1;
        self.tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:self.tap];
    }
}


- (void)tapAction:(UITapGestureRecognizer *)sender {
    
    // 找到window
    self.colorWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.colorWindow.windowLevel = UIWindowLevelAlert;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(windowTapAction:)];
    [self.colorWindow addGestureRecognizer:tap];
    
    
    // 设置颜色
    self.colorWindow.backgroundColor = self.backgroundColor;
    // 动画出现
    self.colorWindow.alpha = 0;
    [self.colorWindow makeKeyAndVisible];
    
    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:0 animations:^{
        self.colorWindow.alpha = 1;
    } completion:nil];
    
}

- (void)windowTapAction:(id)sender
{
    //    if (colorWindow.hidden == YES) {
    //        return colorWindow;
    //    }
    
    [UIView animateWithDuration:.3 animations:^{
        self.colorWindow.alpha = 0;
    } completion:^(BOOL finished) {
        [self.colorWindow resignKeyWindow];
        self.colorWindow = nil;
    }];
}




@end
