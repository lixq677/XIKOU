//
//  MIOrderMutilStoreCell.h
//  XiKou
//
//  Created by L.O.U on 2019/7/2.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface MIOrderDiscountStoreCell : UITableViewCell

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *coverView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *desLabel;

@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subLabel;

@property (nonatomic, assign) BOOL needCorner;

@end

NS_ASSUME_NONNULL_END
