//
//  ACTGoodBaseCell.h
//  XiKou
//
//  Created by L.O.U on 2019/7/4.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKBaseCollectionViewCell.h"
#import "XKUIUnitls.h"
#import "UILabel+NSMutableAttributedString.h"
#import "XKGoodModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ACTGoodBaseCell : XKBaseCollectionViewCell

@property (nonatomic, strong) UIImageView *coverView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic,strong) UILabel *sellOutLabel;

@property (nonatomic, strong) XKGoodListModel *model;


/**
 除了图片的其他部分的高度

 @return <#return value description#>
 */
+ (CGFloat)desheight;

@end


NS_ASSUME_NONNULL_END
