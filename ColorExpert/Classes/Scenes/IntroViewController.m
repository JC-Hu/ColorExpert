//
//  IntroViewController.m
//  ColorExpert
//
//  Created by JasonHu on 2017/8/8.
//  Copyright © 2017年 Jason Hu. All rights reserved.
//

#import "IntroViewController.h"
#import <StoreKit/StoreKit.h>
#import "ImageCollectionCell.h"


@interface IntroViewController ()<SKStoreProductViewControllerDelegate>

@property (nonatomic, strong) NSArray *imageArray;

@property (weak, nonatomic) IBOutlet UIButton *bottomButton;

@property (nonatomic, strong) SKStoreProductViewController *storeVC;

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.view.layer.borderWidth = .5;
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"lanse_%02d", i+1]];
        [array addObject:image];
    }
    
    self.imageArray = array;
    
    self.bottomButton.layer.cornerRadius = 4;
    
    [self loadStoreVC];
}

- (void)loadStoreVC
{
    NSNumber *itemId = [ColorExpertHelper productType] == ColorExpertProductTypeNormal ? @(958918035):@(1080129732);

    SKStoreProductViewController *vc = [[SKStoreProductViewController alloc] init];
    self.storeVC = vc;
    vc.delegate = self;
    [vc loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:itemId, SKStoreProductParameterCampaignToken:@"ColorExpert-Intro"} completionBlock:^(BOOL result, NSError * _Nullable error) {
        if (!result) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissStoreVC];
            });
        }
    }];

}

- (void)presentStoreVC
{
    [self presentViewController:self.storeVC animated:YES completion:nil];
}

- (void)dismissStoreVC
{
    if (self.storeVC.view.superview) {
        [self.storeVC dismissViewControllerAnimated:YES completion:nil];
    }
    self.storeVC = nil;
    [self loadStoreVC];
}

#pragma mark - InterActions

- (IBAction)bottomButtonAction:(id)sender
{
    [self presentStoreVC];
}

#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissStoreVC];
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    
    cell.imageView.image = self.imageArray[indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self presentStoreVC];
}
@end
