//
//  ViewController.m
//  ColorExpert
//
//  Created by JC_Hu on 16/3/28.
//  Copyright © 2016年 Jason Hu. All rights reserved.
//

#import "ViewController.h"
#import "TranslateInputAccessoryView.h"
#import "IQKeyboardManager.h"
#import "JCHUAdHelper.h"

#import <CoreSpotlight/CoreSpotlight.h>
#import "UIImage+Color.h"

#define kTextFieldPreferWidth 44
#define kTextFieldPreferSpace 26



@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *formSegmentedControl;

@property (weak, nonatomic) IBOutlet UITextField *leftTF;
@property (weak, nonatomic) IBOutlet UITextField *middleTF;
@property (weak, nonatomic) IBOutlet UITextField *rightTF;
@property (weak, nonatomic) IBOutlet UITextField *fourthTF;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleTFWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceBetweenRightAndFourthTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourthTFWidth;

@property (weak, nonatomic) IBOutlet UILabel *hexLabel;
@property (weak, nonatomic) IBOutlet UILabel *rgbLabel;
@property (weak, nonatomic) IBOutlet UILabel *hsbLabel;
@property (weak, nonatomic) IBOutlet UILabel *cmykLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardPlaceHolderImageViewHeight;

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (nonatomic, strong) UIColor *color;

@property (nonatomic, strong) TranslateInputAccessoryView *hexAccessoryView;


@end

@implementation ViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.middleTFWidth.constant = kTextFieldPreferWidth;
    self.fourthTFWidth.constant = kTextFieldPreferWidth;
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (UITextField *tf in self.textFieldArray) {
        
        tf.keyboardType = UIKeyboardTypeNumberPad;
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:tf queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            
            [self textChanged];
            
        }];
    }
    
    self.color = [UIColor blackColor];
    
    [self.formSegmentedControl setSelectedSegmentIndex:[ColorExpertHelper productType] ? ([ColorExpertHelper productType] - 1): 0];
    [self formSegmentedControlChanged:nil];
    
    [self colorUpdated];
//    [self changeToThreeTF];
    
    [self prepareSearchAPI];
}


#pragma mark - Interaction
/// 格式切换
- (IBAction)formSegmentedControlChanged:(id)sender
{
    if (sender) {
        [[JCHUAdHelper shareInstance] showInterstitialAd];
    }
    
    [self.view layoutIfNeeded];

    
    for (UITextField *tf in self.textFieldArray) {
        tf.text = @"";
        tf.inputAccessoryView = nil;
    }
    
    ColorFormType type = self.formSegmentedControl.selectedSegmentIndex;
    
    
    switch (type) {
        case ColorFormRGB:{
            [self changeToThreeTF];
            [self.leftTF becomeFirstResponder];
            break;
        }
        case ColorFormHex:{
            [self changeToOneTF];
            self.middleTF.inputAccessoryView = self.hexAccessoryView;
            [self.middleTF becomeFirstResponder];
            break;
        }
        case ColorFormHSB:{
            [self changeToThreeTF];
            [self.leftTF becomeFirstResponder];
            break;
        }
        case ColorFormCMYK:{
            [self changeToFourTF];
            [self.leftTF becomeFirstResponder];
            break;
        }
        default:
            break;
    }
    
    [UIView animateWithDuration:.381 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:.5 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - textField count change
- (void)changeToFourTF
{
    for (UITextField *tf in self.textFieldArray) {
        tf.hidden = NO;
    }
    
    self.middleTFWidth.constant = kTextFieldPreferWidth;
    self.fourthTFWidth.constant = kTextFieldPreferWidth;
    
    self.spaceBetweenRightAndFourthTF.constant = kTextFieldPreferSpace;
}

- (void)changeToThreeTF
{
    for (UITextField *tf in self.textFieldArray) {
        
        if (tf == self.fourthTF) {
            tf.hidden = YES;
        } else {
            tf.hidden = NO;
        }
    }
    
    self.middleTFWidth.constant = kTextFieldPreferWidth;
    self.fourthTFWidth.constant = 0;
    
    self.spaceBetweenRightAndFourthTF.constant = 0;
}

- (void)changeToOneTF
{
    for (UITextField *tf in self.textFieldArray) {
        
        if (tf == self.middleTF) {
            tf.hidden = NO;
        } else {
            tf.hidden = YES;
        }
    }
    
    self.middleTFWidth.constant = kTextFieldPreferWidth*3;
    self.fourthTFWidth.constant = 0;
    
    self.spaceBetweenRightAndFourthTF.constant = 0;
    
}

#pragma mark - update
- (void)textChanged
{
    // 防止溢出
    
    ColorFormType type = self.formSegmentedControl.selectedSegmentIndex;

    switch (type) {
        case ColorFormRGB:{
            
            for (UITextField *tf in self.textFieldArray) {
                
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
            for (UITextField *tf in self.textFieldArray) {
                
                if ([tf.text integerValue] > 100) {
                    tf.text = @"100";
                }
            }
            break;
        }
        case ColorFormCMYK:{
            for (UITextField *tf in self.textFieldArray) {
                
                if ([tf.text integerValue] > 100) {
                    tf.text = @"100";
                }
            }
            break;
        }
            
    }

    
    [self updateColorFromTextField];
}

- (void)updateColorFromTextField
{
    ColorFormType type = self.formSegmentedControl.selectedSegmentIndex;
    
    switch (type) {
        case ColorFormRGB:{
            self.color = RGBACOLOR(self.leftTF.text.integerValue, self.middleTF.text.integerValue, self.rightTF.text.integerValue, 1);
            break;
        }
        case ColorFormHex:{
            if (self.middleTF.text.length != 6) {
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


- (void)colorUpdated
{
    if (!self.color) {
        return;
    }
    
    self.colorView.backgroundColor = self.color;
    
    
    self.hexLabel.text = [NSString stringWithFormat:@"Hex:    %@", [self.color HexInfo].hex];
    
    ColorRGBInfo *rgb = [self.color RGBInfo];
    self.rgbLabel.text = [NSString stringWithFormat:@"R: %@    G: %@    B: %@", rgb.red, rgb.green, rgb.blue];
    
    ColorHSBInfo *hsb = [self.color HSBInfo];
    self.hsbLabel.text = [NSString stringWithFormat:@"H: %@    S: %@    B: %@", hsb.hInfo, hsb.sInfo, hsb.bInfo];

    ColorCMYKInfo *cmyk = [self.color CMYKInfo];
    self.cmykLabel.text = [NSString stringWithFormat:@"C: %@    M: %@    Y: %@    K: %@", cmyk.cInfo, cmyk.mInfo, cmyk.yInfo, cmyk.kInfo];
}


#pragma mark -
- (void)showColorWithInfoDict:(NSDictionary *)infoDict
{
//    NSDictionary *dict = @{
//                           @"event": @"color",
//                           @"formType":@(self.selectedType),
//                           @"value":[self.color stringForColorType:self.selectedType]
//                           
//                           };
    
    ColorFormType formType = [infoDict[@"formType"] integerValue];
    
    NSString *colorString = infoDict[@"value"];
    
    self.formSegmentedControl.selectedSegmentIndex = formType;
    [self formSegmentedControlChanged:nil];

    self.color = [UIColor colorWithString:colorString formType:formType];
    
    [self colorUpdated];
    
    [self.view endEditing:YES];
}


#pragma mark -
- (void)prepareSearchAPI
{
    
    // 效果并不理想
    
//    NSMutableArray *allTypesColorsInfoArray = [NSMutableArray array];

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        // RGB
//        for (int r = 0; r < 256; r++) {
//            for (int g = 0; g < 256; g++) {
//                for (int b = 0; b < 256; b++) {
//                    
//                    @autoreleasepool {
//                        
//                        CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"views"];
//                        attributeSet.title = [NSString stringWithFormat:@"R: %@ G: %@ B: %@", @(r), @(g), @(b)];
//                        attributeSet.contentDescription = [NSString stringWithFormat:@"contentDescription"];
//                        UIImage *thumbImage = [UIImage imageWithColor:RGBACOLOR(r, g, b, 1)];
//                        attributeSet.thumbnailData = UIImagePNGRepresentation(thumbImage);//beta 1 there is a bug
//                        CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:attributeSet.title                                                                                                                                    domainIdentifier:@"com.jchu.ColorExpert"                                                                                                        attributeSet:attributeSet];
//                        
//                        [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item]
//                                                                       completionHandler:^(NSError * __nullable error) {
//                                                                       }];
//                    }
//                }
//            }
//        }
//    
//        // HEX
//        
//        // HSB
//        
//        // CMYK
//        
//    });
    
    
}




- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Lazy Init
- (TranslateInputAccessoryView *)hexAccessoryView
{
    if (!_hexAccessoryView) {
        _hexAccessoryView = [[[NSBundle mainBundle] loadNibNamed:@"TranslateInputAccessoryView" owner:nil options:nil] lastObject];
        _hexAccessoryView.size = CGSizeMake(kWidthOfScreen, 36);
        
        __weak typeof (self)weakSelf = self;
        [self.hexAccessoryView setInputBlock:^(NSString *text) {
            
            weakSelf.middleTF.text = [weakSelf.middleTF.text stringByAppendingString:text];
            [weakSelf textChanged];
        }];
        
        
    }
    return _hexAccessoryView;
}

@end
