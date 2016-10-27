//
//  TranslateInputAccessoryView.m
//  DishDict
//
//  Created by JC_Hu on 15/12/8.
//  Copyright © 2015年 Tubban. All rights reserved.
//

#import "TranslateInputAccessoryView.h"

#import "TranslateInputAccessoryCollectionViewCell.h"

@interface TranslateInputAccessoryView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *charArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLineImageViewHeight;
@end

@implementation TranslateInputAccessoryView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"TranslateInputAccessoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TranslateInputAccessoryCollectionViewCell"];
    
    self.topLineImageViewHeight.constant = .5;
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.charArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TranslateInputAccessoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TranslateInputAccessoryCollectionViewCell" forIndexPath:indexPath];
    
    NSString *charString = self.charArray[indexPath.row];
    
    cell.textLabel.text = charString;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *charString = self.charArray[indexPath.row];

    if (self.inputBlock) {
        self.inputBlock(charString);
    }
}

#pragma mark - Lazy Init
- (NSArray *)charArray
{
    if (!_charArray) {
        _charArray = @[@"A", @"B", @"C", @"D", @"E", @"F"];
//        _charArray = @[@"à", @"ä", @"è", @"é", @"ê", @"î", @"ï", @"ö", @"û", @"ü", @"œ"];
//        _charArray = @[@"Ä", @"Ö", @"Ü", @"ß", @"ä", @"ö", @"ü", @"Å", @"à", @"â", @"è", @"é", @"ê", @"î", @"ï", @"ô", @"ö", @"ù", @"û", @"ü", @"ç", @"œ", @"æ", @"À", @"Â", @"È", @"É", @"Ê", @"Ë", @"Î", @"Ï", @"Ô", @"Ö", @"Ù", @"Û", @"Ç", @"Œ", @"Æ", @"€"];

    }
    return _charArray;
}
@end
