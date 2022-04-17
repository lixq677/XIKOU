//
//  XKCartButtonsView.h
//  XiKou
//
//  Created by L.O.U on 2019/7/9.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKCartButtonsView : UIView

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UIButton *payBtn;

@property (nonatomic, copy) void(^actionBlock)(void);

@end

NS_ASSUME_NONNULL_END
