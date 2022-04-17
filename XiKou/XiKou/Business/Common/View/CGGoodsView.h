//
//  CGGoodsView.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/8/20.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKEnum.h"
#import "ACTDashedView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMGradientView : UIView

@property (nonatomic,strong,readonly)CAGradientLayer * _Nonnull gradientLayer;

@end

@interface CGMoreGoodsCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@end

@interface CGBrandCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *textLabel;

@end



/*抽象类，供继承用，不可直接使用*/
@interface CGGoodsCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic,strong,readonly) UILabel *sellOutLabel;

@end


@interface CGWgCell : CGGoodsCell

@end

@interface CGBrainCell : CGGoodsCell

@end

@interface CGZeroBuyCell : CGBrainCell

@end

@interface CGGlobleBuyerCell : CGGoodsCell

@property (nonatomic, strong) ACTDashedView *couponLabel;//优惠券价格

@end

@interface CGMultiDiscountCell : CGGoodsCell

@property (nonatomic, strong) UILabel *discountLabel;//折扣

@property (nonatomic, strong) UILabel *saleNumLabel;//销量

@end

@interface CGNewUserCell : CGGoodsCell

@end

@interface CGWgNCell : CGGoodsCell


@end

@interface CGBrainNCell : CGGoodsCell

@end

@interface CGGlobleBuyerNCell : CGGoodsCell

@property (nonatomic, strong) ACTDashedView *couponLabel;//优惠券价格

@end

@interface CGSearchGoodsCell : CGGoodsCell

@end

@class XKGoodListModel;
@interface CGGoodsListCell : UITableViewCell

@property (nonatomic, strong) XKGoodListModel *model;

@end

NS_ASSUME_NONNULL_END
