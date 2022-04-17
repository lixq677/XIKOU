//
//  ACTMultiGoodCell.h
//  XiKou
//
//  Created by L.O.U on 2019/7/6.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTGoodBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ACTDiscountGoodCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic,strong)UILabel *textLabel;

@property (nonatomic,strong)UILabel *salePriceLabel;

@property (nonatomic,strong)UILabel *marketPriceLabel;

@property (nonatomic,strong)UILabel *discountLabel;

- (void)setModel:(XKGoodListModel *)model;


+ (NSString *)identify;

@end

NS_ASSUME_NONNULL_END
