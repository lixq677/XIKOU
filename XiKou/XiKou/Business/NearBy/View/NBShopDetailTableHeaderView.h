//
//  NBShopDetailTableHeaderView.h
//  XiKou
//
//  Created by L.O.U on 2019/7/11.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressLabel : UILabel

@end

@interface BusinessHoursLabel : UIView

@property (nonatomic, copy) NSString *value;

@end

@interface NBShopDetailTableHeaderView : UIView

@property (nonatomic, strong,readonly) UIImageView *coverView;
@property (nonatomic, strong,readonly) UILabel *titleLabel;
@property (nonatomic, strong,readonly) AddressLabel *addressLabel;
@property (nonatomic, strong,readonly) UILabel *classLabel;
@property (nonatomic, strong,readonly) UILabel *distanceLabel;
@property (nonatomic, strong,readonly) BusinessHoursLabel *timeLabel;
@property (nonatomic, strong,readonly) UIButton *detailAddressLabel;//不点击，，带图片当label 用
@property (nonatomic, strong,readonly) UILabel *fansNumLabel;
@property (nonatomic, strong,readonly) UILabel *viewedNumLabel;

@end

NS_ASSUME_NONNULL_END
