//
//  MIOrderGoodCell.h
//  XiKou
//
//  Created by L.O.U on 2019/7/1.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKBaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIOrderGoodCell : XKBaseTableCell

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *coverView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *desLabel;

@property (nonatomic, strong) UILabel *numLabel;

@end

@interface MIOrderDetailGoodCell : MIOrderGoodCell //用于订单详情改一下缩进

@end

@interface MIOrderPayAnotherGoodCell : MIOrderGoodCell //代付列表商品cell

@property (nonatomic, strong) UILabel *amountLabel;

@property (nonatomic, strong) UILabel *postageLabel;

@end
NS_ASSUME_NONNULL_END
