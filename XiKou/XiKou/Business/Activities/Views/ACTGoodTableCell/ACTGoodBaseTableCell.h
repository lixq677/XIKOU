//
//  ACTGoodBaseTableCell.h
//  XiKou
//
//  Created by L.O.U on 2019/8/23.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKBaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@class XKGoodListModel;
@interface ACTGoodBaseTableCell : XKBaseTableCell

@property (nonatomic, strong) UIImageView *coverView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *originLabel;

@property (nonatomic, strong) UILabel *subTextLabel;

@property (nonatomic, strong) XKGoodListModel *model;

@end

NS_ASSUME_NONNULL_END
