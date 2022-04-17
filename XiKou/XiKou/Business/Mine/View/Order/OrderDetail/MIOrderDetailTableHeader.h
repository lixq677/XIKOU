//
//  MIOrderDetailTableHeader.h
//  XiKou
//
//  Created by L.O.U on 2019/7/25.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XKOrderDetailModel;
@interface MIOrderDetailTableHeader : UIView

@property (nonatomic, strong) UIImageView *statusImgView;

@property (nonatomic, strong) UILabel *statuslabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) XKOrderDetailModel *model;
@end

NS_ASSUME_NONNULL_END
