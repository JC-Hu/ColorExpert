//
//  TodayViewController.m
//  ColorExpert-Today
//
//  Created by JC_Hu on 16/4/21.
//  Copyright © 2016年 Jason Hu. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "UIView+Shortcut.h"
#import "ShortcutMacro.h"
#import "UITextField+Blocks.h"
#import "ColorExpertHelper.h"
#import "UIColor+HEX.h"
#import "UIColor+JCHUColorInfo.h"

#define kTextFieldPreferWidth 48
#define kTextFieldPreferSpace 4


@interface TodayViewController () <NCWidgetProviding, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *colorButton;



@property (weak, nonatomic) IBOutlet UIView *buttonContainerView;

//@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonArray;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *alphabetButtonArray;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *numberButtonArray;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@property (weak, nonatomic) IBOutlet UIButton *copyyButton;

@property (weak, nonatomic) IBOutlet UIButton *pasteButton;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *formatButtonArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *componentTFArray;

@property (weak, nonatomic) IBOutlet UITextField *leftTF;
@property (weak, nonatomic) IBOutlet UITextField *middleTF;
@property (weak, nonatomic) IBOutlet UITextField *rightTF;
@property (weak, nonatomic) IBOutlet UITextField *fourthTF;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleTFWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceBetweenRightAndFourthTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourthTFWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightTFWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftTFWidth;

@property (nonatomic, assign) NSInteger selectedComponentIndex;

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) ColorFormType selectedType;

@property (weak, nonatomic) IBOutlet UILabel *hintShowMoreLabel;

@end

@implementation TodayViewController


// 1. 监听剪贴板显示颜色
// 2. 仿计算器。显示颜色
//
//

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self.extensionContext respondsToSelector:@selector(setWidgetLargestAvailableDisplayMode:)]) {
        // iOS10+
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    }
    
    
    self.color = [UIColor darkGrayColor];
    [self colorUpdated];
    [self formChangeToType:ColorFormRGB];
    
    
    [self setupViews];
    
    [self updateViewHeight];
    
    [self updateButtonState];
//    [self changeToThreeTF];
    [self.leftTF becomeFirstResponder];
}



- (void)setupViews
{

    
    // 所有按钮
    for (UIButton *button in self.buttonArray) {
        button.layer.cornerRadius = 2;
    }
    
    // A-F字母按钮
    for (UIButton *button in self.alphabetButtonArray) {
        
        [button addTarget:self action:@selector(alphabetButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // RGB、HEX等格式按钮
    for (UIButton *button in self.formatButtonArray) {
        
        [button addTarget:self action:@selector(formatButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    // 0-9数字按钮
    for (UIButton *button in self.numberButtonArray) {
        
        [button addTarget:self action:@selector(numberButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // 元素TF
    for (UITextField *tf in self.componentTFArray) {
        
        tf.inputView = [[UIView alloc] init];
        
        tf.tintColor = [UIColor whiteColor];
        
//        tf.delegate = self;
        
        [tf setShouldBegindEditingBlock:^BOOL(UITextField *textField) {
        
            self.selectedComponentIndex = [self.componentTFArray indexOfObject:textField];

            return YES;
        }];
        
    }
    
    
}

#pragma mark - InterAction
- (void)alphabetButtonAction:(UIButton *)button
{
    [self inputText:[button titleForState:UIControlStateNormal]];
}

- (void)numberButtonAction:(UIButton *)button
{
    [self inputText:[button titleForState:UIControlStateNormal]];
}

- (void)formatButtonAction:(UIButton *)button
{
    ColorFormType type = [self.formatButtonArray indexOfObject:button];
    
    self.selectedType = type;
    [self formChangeToType:type];
    [self updateButtonState];
}



- (IBAction)nextButtonAction:(id)sender {
    
    if (self.selectedComponentIndex < 0) {
        self.selectedComponentIndex = 0;
    }
    
    NSInteger i = self.selectedComponentIndex + 1;
    
    while (1) {
        
        if (i > self.componentTFArray.count - 1) {
            i = 0;
        }
        
        UITextField *nextTF = self.componentTFArray[i];
        
        if (nextTF.hidden == NO) {
            
            self.selectedComponentIndex = i;
            [nextTF becomeFirstResponder];
            break;
        }
        
        i++;
    }
    
}

- (IBAction)colorButtonAction:(id)sender {
    
//    [(UIButton *)sender setBackgroundColor:[UIColor colorWithRed:(arc4random() % 256 / 255.0) green:(arc4random() % 256 / 255.0) blue:(arc4random() % 256 / 255.0) alpha:1.0]];
    
    NSDictionary *dict = @{
                           @"event": @"color",
                           @"formType":@(self.selectedType),
                           @"value":[self.color stringForColorType:self.selectedType]
                           
                           };
    
    
    NSString *json = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil]  encoding:NSUTF8StringEncoding];

    NSUserDefaults *groupTempUserDefault = [[NSUserDefaults alloc] initWithSuiteName:APP_GROUP_TEMP_CONTAINER_ID];
    
    [groupTempUserDefault setObject:json forKey:@"json"];
    [groupTempUserDefault synchronize];
    
    
    NSString *str = [NSString stringWithFormat: @"colorexpertpro://"];
//    NSString *str = [NSString stringWithFormat: @"colorexpertpro://?json=%@", json];
    [self.extensionContext openURL:[NSURL URLWithString:str] completionHandler:^(BOOL success) {
        
    }];
}

- (IBAction)deleteButtonAction:(id)sender {
    
    [self deleteText];
}

- (IBAction)clearButtonAction:(id)sender {
    
    [self clearText];
}


- (IBAction)copyButtonAction:(id)sender {
    
    if (!self.color) {
        return;
    }
    NSString *textToPaste = [self.color stringForColorType:self.selectedType];
    
    [[UIPasteboard generalPasteboard] setString:textToPaste];
}

- (IBAction)pasteButtonAction:(id)sender {
    
    NSString *text = [UIPasteboard generalPasteboard].string;
    
    NSCharacterSet *legalSet = [NSCharacterSet characterSetWithCharactersInString:@"1234567890ABCDEF,"];
    
    
    text = [text stringByTrimmingCharactersInSet:[legalSet invertedSet]];
    
//    NSLog(@"%@", text);
//    self.middleTF.text = text;
    
    if ([text containsString:@","]) {
        
        NSArray *compArr = [text componentsSeparatedByString:@","];
        
        if (compArr.count == 3) {
            
            if (self.selectedType == ColorFormHSB) {
                // HSB
                self.leftTF.text = compArr[0];
                self.middleTF.text = compArr[1];
                self.rightTF.text = compArr[2];
                
                [self textChanged];
                
            } else {
                // RGB

                self.selectedType = ColorFormRGB;
//                [self changeToThreeTF];
                [self formChangeToType:ColorFormRGB];
                [self updateButtonState];

                self.leftTF.text = compArr[0];
                self.middleTF.text = compArr[1];
                self.rightTF.text = compArr[2];
                
                [self textChanged];
            }
            
        } else if (compArr.count == 4) {
            // CMYK
            
            self.selectedType = ColorFormCMYK;
//            [self changeToFourTF];
            [self formChangeToType:ColorFormCMYK];
            [self updateButtonState];
            
            self.leftTF.text = compArr[0];
            self.middleTF.text = compArr[1];
            self.rightTF.text = compArr[2];
            self.fourthTF.text = compArr[3];
            
            [self textChanged];
            
        } else {
            // None
        }
        
    } else {
        
        // Hex
        self.selectedType = ColorFormHex;
//        [self changeToOneTF];
        [self formChangeToType:ColorFormHex];
        [self updateButtonState];

        self.middleTF.text = text;
        [self textChanged];
        
    }
    
    
    
}

#pragma mark - Input
- (void)inputText:(NSString *)str
{
    if (self.selectedComponentIndex < 0) {
        self.selectedComponentIndex = 0;
        [self.leftTF becomeFirstResponder];
    }
    
    UITextField *currentTF = self.componentTFArray[self.selectedComponentIndex];
    
    NSString *oldText = currentTF.text;
    
    NSString *newText = [oldText stringByAppendingString:str];
    
    currentTF.text = newText;
    
    [self textChanged];
}

- (void)deleteText
{
    if (self.selectedComponentIndex < 0) {
        self.selectedComponentIndex = 0;
    }
    
    
    UITextField *currentTF = self.componentTFArray[self.selectedComponentIndex];
    
    NSString *oldText = currentTF.text;
    
    if (!oldText.length) {
        
        // 当前TF无文本，选中前一个TF
        
        NSInteger i = self.selectedComponentIndex - 1;
        
        while (1) {
            
            if (i < 0) {
                i = self.componentTFArray.count - 1;
            }
            
            UITextField *nextTF = self.componentTFArray[i];
            
            if (nextTF.hidden == NO) {
                
                self.selectedComponentIndex = i;
                [nextTF becomeFirstResponder];
                break;
            }
            
            i--;
        }
        return;
    }
    
    NSString *newText = [oldText substringToIndex:oldText.length-1];
    
    currentTF.text = newText;
    
    [self textChanged];
}

- (void)clearText
{
    if (self.selectedComponentIndex < 0) {
        self.selectedComponentIndex = 0;
    }
    
    UITextField *currentTF = self.componentTFArray[self.selectedComponentIndex];
    
    currentTF.text = nil;
    
    [self textChanged];
}

- (void)textChanged
{
    [self textChangedNeedUpdateColor:YES];
    
}

- (void)textChangedNeedUpdateColor:(BOOL)updateColor
{
    // 防止溢出
    
    switch (self.selectedType) {
        case ColorFormRGB:{
            
            for (UITextField *tf in self.componentTFArray) {
                
                if ([tf.text integerValue] > 255) {
                    tf.text = @"255";
                }
            }
            
            break;
        }
        case ColorFormHex:{
            for (int i = 0; i < self.middleTF.text.length; i++) {
                NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEF01234567890"];
                unichar c = [self.middleTF.text characterAtIndex:i];
                
                if (![set characterIsMember:c]) {
                    self.middleTF.text = @"";
                }
                
                
            }
            break;
        }
        case ColorFormHSB:{
            for (UITextField *tf in self.componentTFArray) {
                
                if ([tf.text integerValue] > 100) {
                    tf.text = @"100";
                }
            }
            break;
        }
        case ColorFormCMYK:{
            for (UITextField *tf in self.componentTFArray) {
                
                if ([tf.text integerValue] > 100) {
                    tf.text = @"100";
                }
            }
            break;
        }
            
    }
    
    if (updateColor) {
        [self updateColor];
    }
}

#pragma mark 格式切换
/// 格式切换
- (void)formChangeToType:(ColorFormType)type
{
    [self.view layoutIfNeeded];
    
    for (UITextField *tf in self.componentTFArray) {
        tf.text = @"";
        tf.inputAccessoryView = nil;
    }
    
    
    switch (type) {
        case ColorFormRGB:{
            [self changeToThreeTF];
            self.selectedComponentIndex = 0;
            
            ColorRGBInfo *rgb = [self.color RGBInfo];
            self.leftTF.text = rgb.red;
            self.middleTF.text = rgb.green;
            self.rightTF.text = rgb.blue;
            
            [self.leftTF becomeFirstResponder];
            break;
        }
        case ColorFormHex:{
            [self changeToOneTF];
            self.selectedComponentIndex = 1;
            
            self.middleTF.text = [self.color HexInfo].hex;
            
            [self.middleTF becomeFirstResponder];

            break;
        }
        case ColorFormHSB:{
            [self changeToThreeTF];
            self.selectedComponentIndex = 0;
            
            ColorHSBInfo *hsb = [self.color HSBInfo];
            self.leftTF.text = hsb.hInfo;
            self.middleTF.text = hsb.sInfo;
            self.rightTF.text = hsb.bInfo;
            
            [self.leftTF becomeFirstResponder];
            break;
        }
        case ColorFormCMYK:{
            [self changeToFourTF];
            self.selectedComponentIndex = 0;
            
            ColorCMYKInfo *cmyk = [self.color CMYKInfo];
            self.leftTF.text = cmyk.cInfo;
            self.middleTF.text = cmyk.mInfo;
            self.rightTF.text = cmyk.yInfo;
            self.fourthTF.text = cmyk.kInfo;
            
            [self.leftTF becomeFirstResponder];
            break;
        }
    }
    
    
    [UIView animateWithDuration:.381 delay:0 usingSpringWithDamping:.95 initialSpringVelocity:.5 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - textField count change
- (void)changeToFourTF
{
    for (UITextField *tf in self.componentTFArray) {
        tf.hidden = NO;
    }
    
    self.middleTFWidth.constant = kTextFieldPreferWidth;
    self.fourthTFWidth.constant = kTextFieldPreferWidth;
    self.leftTFWidth.constant = kTextFieldPreferWidth;
    self.rightTFWidth.constant = kTextFieldPreferWidth;
    
    self.spaceBetweenRightAndFourthTF.constant = kTextFieldPreferSpace;
}

- (void)changeToThreeTF
{
    for (UITextField *tf in self.componentTFArray) {
        
        if (tf == self.fourthTF) {
            tf.hidden = YES;
        } else {
            tf.hidden = NO;
        }
    }
    
    self.middleTFWidth.constant = kTextFieldPreferWidth;
    self.fourthTFWidth.constant = 0;
    self.leftTFWidth.constant = kTextFieldPreferWidth;
    self.rightTFWidth.constant = kTextFieldPreferWidth;
    
    self.spaceBetweenRightAndFourthTF.constant = 0;
}

- (void)changeToOneTF
{
    for (UITextField *tf in self.componentTFArray) {
        
        if (tf == self.middleTF) {
            tf.hidden = NO;
        } else {
            tf.hidden = YES;
        }
    }
    
    self.middleTFWidth.constant = kTextFieldPreferWidth*3;
    self.fourthTFWidth.constant = 0;
    self.leftTFWidth.constant = 0;
    self.rightTFWidth.constant = 0;
    
    
    self.spaceBetweenRightAndFourthTF.constant = 0;
    
}

// 根据selectedType和TF内容识别颜色
- (void)updateColor
{
    ColorFormType type = self.selectedType;
    
    switch (type) {
        case ColorFormRGB:{
            self.color = RGBACOLOR(self.leftTF.text.integerValue, self.middleTF.text.integerValue, self.rightTF.text.integerValue, 1);
            break;
        }
        case ColorFormHex:{
            if (self.middleTF.text.length == 0) {
                self.color = [UIColor blackColor];
                break;
            } else if (self.middleTF.text.length != 6) {
                return;
            }
            self.color = [UIColor colorWithHexString:self.middleTF.text];
            break;
        }
        case ColorFormHSB:{
            self.color = [UIColor colorWithHue:self.leftTF.text.integerValue/360.0 saturation:self.middleTF.text.integerValue/100.0 brightness:self.rightTF.text.integerValue/100.0 alpha:1];
            break;
        }
        case ColorFormCMYK:{
            
            self.color = [UIColor colorWithC:self.leftTF.text.integerValue M:self.middleTF.text.integerValue Y:self.rightTF.text.integerValue K:self.fourthTF.text.integerValue];
            break;
        }
        default:
            break;
    }
    
    [self colorUpdated];
}


// 根据颜色更新UI
- (void)colorUpdated
{
    if (!self.color) {
        return;
    }
    
    self.colorButton.backgroundColor = self.color;
    
    
//    self.hexLabel.text = [NSString stringWithFormat:@"Hex:    %@", [self.color HexInfo].hex];
//    
//    ColorRGBInfo *rgb = [self.color RGBInfo];
//    self.rgbLabel.text = [NSString stringWithFormat:@"R: %@    G: %@    B: %@", rgb.red, rgb.green, rgb.blue];
//    
//    ColorHSBInfo *hsb = [self.color HSBInfo];
//    self.hsbLabel.text = [NSString stringWithFormat:@"H: %@    S: %@    B: %@", hsb.hInfo, hsb.sInfo, hsb.bInfo];
//    
//    ColorCMYKInfo *cmyk = [self.color CMYKInfo];
//    self.cmykLabel.text = [NSString stringWithFormat:@"C: %@    M: %@    Y: %@    K: %@", cmyk.cInfo, cmyk.mInfo, cmyk.yInfo, cmyk.kInfo];
}




#pragma mark - Reuse


- (void)updateViewHeight
{
    if ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height) {
        // 横屏
        self.buttonHeight.constant = 32;
        
    } else {
        // 竖屏
        self.buttonHeight.constant = 38;
    }
    
    [self.view setNeedsLayout];
    
    CGFloat width = 0;
    
    if ([self.extensionContext respondsToSelector:@selector(widgetMaximumSizeForDisplayMode:)]) {
        // iOS10+
        width = [self.extensionContext widgetMaximumSizeForDisplayMode:self.extensionContext.widgetActiveDisplayMode].width;
    } else {
        width = kWidthOfScreen;
    }
    
    
    CGSize fittingSize = CGSizeZero;
    
    NSLayoutConstraint *tempWidthConstraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
    [self.view addConstraint:tempWidthConstraint];
    // Auto layout engine does its math
    fittingSize = [self.view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    [self.view removeConstraint:tempWidthConstraint];
    
    
    fittingSize = CGSizeMake(fittingSize.width, fittingSize.height + 8);
    
    self.preferredContentSize = fittingSize;
    
    
    // test
//    self.resultLabel.text = [NSString stringWithFormat:@"%@",@(fittingSize.height)];
    
}

- (void)updateButtonState
{
    for (int i = 0; i < self.formatButtonArray.count; i++) {
        UIButton *button = self.formatButtonArray[i];
        
        if (i == self.selectedType) {
            button.selected = YES;
        } else {
            button.selected = NO;
        }
    }
}

#pragma mark - Widget

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [self updateViewHeight];

        completionHandler(NCUpdateResultNewData);
    });
}



// Widgets wishing to customize the default margin insets can return their preferred values.
// Widgets that choose not to implement this method will receive the default margin insets.
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
//    return UIEdgeInsetsMake(defaultMarginInsets.top, 0, defaultMarginInsets.bottom, defaultMarginInsets.right);
    return UIEdgeInsetsZero;
}


- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize
{
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        for (UIView *subView in self.view.subviews) {
            subView.hidden = YES;
        }
        
        self.hintShowMoreLabel.hidden = NO;
        
        self.preferredContentSize = maxSize;
        
    } else {
        for (UIView *subView in self.view.subviews) {
            subView.hidden = NO;
        }
        
        self.hintShowMoreLabel.hidden = YES;
        
        [self updateViewHeight];
    }
    
    
    
}

//#pragma mark
//- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
//{
//    
//    NSLog(@"%d", self.traitCollection.horizontalSizeClass);
//    NSLog(@"%d", self.traitCollection.verticalSizeClass);
//
//}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
