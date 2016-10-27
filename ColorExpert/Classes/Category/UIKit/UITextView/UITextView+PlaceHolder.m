//
//  UITextView+PlaceHolder.m
//  IOS-Categories
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "UITextView+PlaceHolder.h"
static const char *phTextView = "placeHolderTextView";
@implementation UITextView (PlaceHolder)
- (UITextView *)placeHolderTextView {
    return objc_getAssociatedObject(self, phTextView);
}
- (void)setPlaceHolderTextView:(UITextView *)placeHolderTextView {
    objc_setAssociatedObject(self, phTextView, placeHolderTextView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)addPlaceHolder:(NSString *)placeHolder {
    if (![self placeHolderTextView]) {
//        self.delegate = self;
        UITextView *textView = [[UITextView alloc] initWithFrame:self.bounds];
        textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        textView.font = self.font;
        textView.backgroundColor = [UIColor clearColor];
        textView.textColor = [UIColor lightGrayColor];
        textView.userInteractionEnabled = NO;
        textView.text = placeHolder;
        [self addSubview:textView];
        [self setPlaceHolderTextView:textView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:self];
    }
}
# pragma mark -
//# pragma mark - UITextViewDelegate
//- (void)textViewDidBeginEditing:(UITextView *)textView {
//    self.placeHolderTextView.hidden = YES;
//    // if (self.textViewDelegate) {
//    //
//    // }
//}
//- (void)textViewDidEndEditing:(UITextView *)textView {
//    if (textView.text && [textView.text isEqualToString:@""]) {
//        self.placeHolderTextView.hidden = NO;
//    }
//}

- (void)textViewTextDidChange:(NSNotification *)notification
{
    self.placeHolderTextView.hidden = self.text.length;
    
    
}


@end
