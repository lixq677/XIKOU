//
//  MIOrderHeadView.h
//  XiKou
//
//  Created by L.O.U on 2019/7/1.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIOrderHeadView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subLabel;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, assign) BOOL needCorner;

+ (NSString *)identify;
@end

@interface MIOrderDetailHeader : MIOrderHeadView //用于订单详情改一下缩进

@end

@interface MIOrderPayAnotherHeader : MIOrderHeadView

@property (nonatomic, strong) UIButton *titleBtn;

@end

NS_ASSUME_NONNULL_END
