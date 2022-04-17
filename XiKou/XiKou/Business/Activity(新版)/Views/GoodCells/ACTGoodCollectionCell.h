//
//  ACTGoodCollectionCell.h
//  XiKou
//
//  Created by L.O.U on 2019/8/16.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKUIUnitls.h"
#import "UILabel+NSMutableAttributedString.h"
#import "XKGoodModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    FontBig,
    FontSmall,
} FontStyle;
@interface ACTGoodCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *coverView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) XKGoodListModel *model;

@property (nonatomic, assign) FontStyle fontStyle;


/** 除图片以外的其他内容的高度  */
+ (CGFloat)desHeight;

@end

NS_ASSUME_NONNULL_END
