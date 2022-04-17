//
//  XKPopBaseView.h
//  XiKou
//
//  Created by L.O.U on 2019/7/11.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^sureBlock)(void);

@interface XKPopBaseView : UIView

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *cancleBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) sureBlock sureBlock;

- (void)layoutByContentHeight:(CGFloat)contentH;

- (void)dismiss;

- (void)show;
@end

NS_ASSUME_NONNULL_END
