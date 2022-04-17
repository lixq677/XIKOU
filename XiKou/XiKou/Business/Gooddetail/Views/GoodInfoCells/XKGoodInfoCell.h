//
//  XKGoodInfoCell.h
//  XiKou
//
//  Created by L.O.U on 2019/7/8.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKTagsView.h"
#import "XKAccountManager.h"
#import "XKEnum.h"
#import "XKActivityData.h"
#import "UILabel+NSMutableAttributedString.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKGoodInfoCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;           //名字

@property (nonatomic, strong) UILabel *priceLabel;          //价格

@property (nonatomic, strong) UILabel *originalPriceLabel;  //原价

@property (nonatomic, strong) XKTagsView *tagView;          //标签

@property (nonatomic, strong) UIView *joinVipView;          //加入vip

@property (nonatomic, strong) ACTGoodDetailModel *detailModel;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

NS_ASSUME_NONNULL_END
