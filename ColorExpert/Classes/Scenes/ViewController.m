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

#import "UIImage+Color.h"
#import <UnityAds/UnityAds.h>

@import GoogleMobileAds;

#define kTextFieldPreferWidth 44
#define kTextFieldPreferSpace 26

#define kBannerAdViewHeight 50


@interface ViewController ()<UnityAdsDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *formSegmentedControl;

@property (weak, nonatomic) IBOutlet UITextField *leftTF;
@property (weak, nonatomic) IBOutlet UITextField *middleTF;
@property (weak, nonatomic) IBOutlet UITextField *rightTF;
@property (weak, nonatomic) IBOutlet UITextField *fourthTF;

@property (strong, nonatomic) NSArray *textFieldArray;

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

@property (weak, nonatomic) IBOutlet UIButton *clearButton;

// Nav
@property (strong, nonatomic) IBOutlet UIButton *switchButton;
@property (nonatomic, strong) UIBarButtonItem *removeAdBarButton;


// banner Ad
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerAdViewHeight;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerAdView;

// lanse intro
@property (weak, nonatomic) IBOutlet UIView *introContainerView;

@property (weak, nonatomic) IBOutlet UIButton *introCloseButton;

// reward video
@property (nonatomic, strong) UIAlertView *loadingAlertView;


@end

@implementation ViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.middleTFWidth.constant = kTextFieldPreferWidth;
    self.fourthTFWidth.constant = kTextFieldPreferWidth;
}

- (BOOL)shouldShowAd
{
    return [[JCHUAdHelper shareInstance] shouldShowAd];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any aditional setup after loading the view.
    
    [self setupNav];
    
    
    // ad
    [self adjustAdBannerHidden:![self shouldShowAd]];
    
    if ([self shouldShowAd]) {
        // banner
        [self requestBannerAd];
        // reward video
        [UnityAds initialize:@"1088169" delegate:self];
    }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:AdRemovedNotificationName object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        [self adjustAdBannerHidden:YES];
    }];
    
    // colorView
    self.colorView.layer.cornerRadius = 5;
    self.colorView.layer.borderWidth = .5;
    self.colorView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.color = [UIColor blackColor];
    
    // textfields
    for (UITextField *tf in self.textFieldArray) {
        
        tf.keyboardType = UIKeyboardTypeNumberPad;
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:tf queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            
            [self textChanged];
            
        }];
    }
    
    [self.formSegmentedControl setSelectedSegmentIndex:[ColorExpertHelper productType] ? ([ColorExpertHelper productType] - 1): 0];
    [self formSegmentedControlChanged:nil];
    
    [self colorUpdated];
    
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setupNav
{
    // More
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"More" style:UIBarButtonItemStylePlain target:self action:@selector(moreBarButtonAction:)];
    
    // Switch
    self.switchButton.layer.borderColor = self.switchButton.tintColor.CGColor;
    self.switchButton.layer.borderWidth = 1;
    self.switchButton.layer.cornerRadius = 4;
}

- (void)requestBannerAd
{
    if (![[JCHUAdHelper shareInstance] shouldShowAd]) {
        return;
    }
    
    self.bannerAdView.adUnitID = @"ca-app-pub-5587951421072030/5194074794";
    self.bannerAdView.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    
    request.testDevices = @[
                            @"31efa905b1be4e75b2c50a2de06e83de"
                            ];
    [self.bannerAdView loadRequest:request];
}

#pragma mark - Interaction
/// 格式切换
- (IBAction)formSegmentedControlChanged:(id)sender
{
    if (sender) {
        [[JCHUAdHelper shareInstance] showInterstitialAd];
    }
    
    [self.view layoutIfNeeded];

    ColorFormType type = self.formSegmentedControl.selectedSegmentIndex;

    self.navigationItem.titleView = self.switchButton;
    [self.switchButton setTitle:[self formNameForType: type] forState:UIControlStateNormal];
    
    for (UITextField *tf in self.textFieldArray) {
        tf.text = @"";
        tf.inputAccessoryView = nil;
    }
    
    
    
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

- (IBAction)clearButtonAction:(id)sender
{
    for (UITextField *tf in self.textFieldArray) {
        tf.text = nil;
    }
    if (self.leftTF.hidden == NO) {
        [self.leftTF becomeFirstResponder];
    }
}

- (IBAction)switchButtonAction:(id)sender
{
    [self.navigationItem setTitleView:self.formSegmentedControl];
    
}

- (void)removeAdBarButtonAction:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Remove Ad"
                          message:@"#Download pro version - No ad, more feature\n#Watch a video - Remove ad for 24hours"
                          delegate:self
                          cancelButtonTitle:@"Later"
                          otherButtonTitles:@"Download pro",@"Watch a video", nil];
    alert.delegate = self;
    [alert show];
}

- (void)moreBarButtonAction:(id)sender
{
    
    
}

- (IBAction)closeButtonAction:(id)sender {
    
    [self.introCloseButton removeFromSuperview];
    [self.introContainerView removeFromSuperview];
}
#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.loadingAlertView) {
        
        [self.loadingAlertView dismissWithClickedButtonIndex:0 animated:YES];
        self.loadingAlertView = nil;
        return;
    }
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Download pro"]) {
        
        // 专业版
        NSString *str = @"https://itunes.apple.com/app/apple-store/id1090866804?pt=117317585&ct=download_pro_version&mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
        
    } else if ([title isEqualToString:@"Watch a video"]) {
        // 激励广告
        [self tryToWatchVideo];
    }
}

// 激励广告
- (void)tryToWatchVideo
{
    
    if ([UnityAds isReady:@"rewardedVideo"]) {
        [UnityAds show:self placementId:@"rewardedVideo"];
        
    } else if ([UnityAds getPlacementState:@"rewardedVideo"] == kUnityAdsPlacementStateWaiting || [UnityAds getPlacementState:@"rewardedVideo"] == kUnityAdsPlacementStateNotAvailable){
        self.loadingAlertView = [[UIAlertView alloc] initWithTitle:@"Loading..." message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
        
        [self.loadingAlertView show];
        [self.view endEditing:YES];
        
    } else {
        [[[UIAlertView alloc]
          initWithTitle:@"Video Loading Failed"
          message:@"Please try again later"
          delegate:self
          cancelButtonTitle:@"Done"
          otherButtonTitles:nil] show];
    }
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
    
    self.clearButton.hidden = YES;
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
    
    self.clearButton.hidden = NO;
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
    
    self.clearButton.hidden = NO;
}
#pragma mark - update
- (void)textChanged
{
    // 防止溢出
    // 智能切换输入框
    
    ColorFormType type = self.formSegmentedControl.selectedSegmentIndex;

    switch (type) {
        case ColorFormRGB:{
            
            for (UITextField *tf in self.textFieldArray) {
                [self textFieldMaxValue:tf limit:255];
                if ([tf isFirstResponder]) {
                    if ([self textFieldShouldAutoSwitch:tf limit:255]) {
                        // 切换输入框
                        [self switchToNextTextField];
                    }
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
            if (self.middleTF.text.length > 6) {
                self.middleTF.text = [self.middleTF.text substringToIndex:6];
            }
            break;
        }
        case ColorFormHSB:{
            for (UITextField *tf in self.textFieldArray) {
                [self textFieldMaxValue:tf limit:100];
                if ([tf isFirstResponder]) {
                    if ([self textFieldShouldAutoSwitch:tf limit:100]) {
                        // 切换输入框
                        [self switchToNextTextField];
                    }
                }
            }
            break;
        }
        case ColorFormCMYK:{
            for (UITextField *tf in self.textFieldArray) {
                [self textFieldMaxValue:tf limit:100];
                if ([tf isFirstResponder]) {
                    if ([self textFieldShouldAutoSwitch:tf limit:100]) {
                        // 切换输入框
                        [self switchToNextTextField];
                    }
                }
            }
            break;
        }
    }

    
    [self updateColorFromTextField];
}

- (void)textFieldMaxValue:(UITextField *)tf limit:(NSInteger)limit
{
    // 防止溢出
    if ([tf.text integerValue] > limit) {
        tf.text = [@(limit) stringValue];
    }
}

- (BOOL)textFieldShouldAutoSwitch:(UITextField *)tf limit:(NSInteger)limit
{
    // 智能切换TF
    if ([tf.text integerValue]*10 > limit) {
        return YES;
    }
    return NO;
}

- (void)switchToNextTextField
{
    NSInteger curentIndex = -1;
    for (UITextField *tf in self.textFieldArray) {
        if ([tf isFirstResponder]) {
            curentIndex = [self.textFieldArray indexOfObject:tf];
            break;
        }
    }
    
    if (curentIndex != -1) {
        NSInteger i = curentIndex +1;
        while (1) {
            if (i > self.textFieldArray.count - 1) {
                break;
            }
            
            UITextField *tf = self.textFieldArray[i];
            if (tf.hidden == NO) {
                [tf becomeFirstResponder];
                break;
            }
            i++;
        }
    }
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

- (NSString *)formNameForType:(ColorFormType)type
{
    return [@[@"RGB", @"HEX", @"HSB", @"CMYK"] objectAtIndex:type];
}

#pragma mark - AD
- (void)adjustAdBannerHidden:(BOOL)hidden
{
    self.bannerAdView.hidden = hidden;
    self.bannerAdViewHeight.constant = hidden? 10:50;
    
    self.navigationItem.rightBarButtonItem = hidden ? nil : self.removeAdBarButton;
}

#pragma mark UnityAds
- (void)unityAdsReady:(NSString *)placementId
{
    if ([placementId isEqualToString:@"rewardedVideo"]) {
        if (self.loadingAlertView) {
            [self.loadingAlertView dismissWithClickedButtonIndex:0 animated:NO];
            self.loadingAlertView = nil;
            [self tryToWatchVideo];
        }
    }
}

- (void)unityAdsDidError:(UnityAdsError)error withMessage:(NSString *)message
{
    if (self.loadingAlertView) {
        [self.loadingAlertView dismissWithClickedButtonIndex:0 animated:NO];
        self.loadingAlertView = nil;
        [[[UIAlertView alloc]
          initWithTitle:@"Video Loading Failed"
          message:@"Please try again later"
          delegate:self
          cancelButtonTitle:@"Done"
          otherButtonTitles:nil] show];
    }
}

- (void)unityAdsDidStart:(NSString *)placementId
{
   
}

- (void)unityAdsDidFinish:(NSString *)placementId withFinishState:(UnityAdsFinishState)state
{
    if (state != kUnityAdsFinishStateSkipped) {
        // Reward
        
        [[[UIAlertView alloc] initWithTitle:@"Reward Received" message:@"Remove Ad For 24hours" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        // remove ad for 24hours
        [[JCHUAdHelper shareInstance] removeAdForMinutes:60 * 24];

    }
}


#pragma mark - Lazy Init
- (TranslateInputAccessoryView *)hexAccessoryView
{
    if (!_hexAccessoryView) {
        _hexAccessoryView = [[[NSBundle mainBundle] loadNibNamed:@"TranslateInputAccessoryView" owner:nil options:nil] lastObject];
        _hexAccessoryView.size = CGSizeMake(kWidthOfScreen, 44);
        
        __weak typeof (self)weakSelf = self;
        [self.hexAccessoryView setInputBlock:^(NSString *text) {
            
            weakSelf.middleTF.text = [weakSelf.middleTF.text stringByAppendingString:text];
            [weakSelf textChanged];
        }];
        
        
    }
    return _hexAccessoryView;
}

- (NSArray *)textFieldArray
{
    if (!_textFieldArray) {
        _textFieldArray = @[self.leftTF, self.middleTF, self.rightTF, self.fourthTF];
    }
    return _textFieldArray;
}

- (UIBarButtonItem *)removeAdBarButton
{
    if (!_removeAdBarButton) {
        _removeAdBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"remove_ad"] style:UIBarButtonItemStylePlain target:self action:@selector(removeAdBarButtonAction:)];
    }
    return _removeAdBarButton;
}

@end
