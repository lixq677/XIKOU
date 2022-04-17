//
//  XKPopBaseView.m
//  XiKou
//  仅仅弹在底部
//  Created by L.O.U on 2019/7/11.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKPopBaseView.h"

@interface XKPopBaseView ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat contentH;

@end

@implementation XKPopBaseView

- (instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (self) {
        
        self.backgroundColor = COLOR_RGB(0, 0, 0, 0.6);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        [self xk_addSubviews:@[self.contentView,self.cancleBtn]];
    }
    return self;
}

- (void)layoutByContentHeight:(CGFloat)contentH{
    _contentH = contentH;
    [self.cancleBtn setImage:[UIImage imageNamed:@"car_cancel"] forState:UIControlStateNormal];
    [_cancleBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_cancleBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];

    _contentH    = contentH + [XKUIUnitls safeBottom];

    UIView *line = [UIView new];
    line.backgroundColor = COLOR_LINE_GRAY;
    
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(self.contentH);
        make.top.equalTo(self).offset(kScreenHeight);
    }];
    [self.contentView xk_addSubviews:@[self.titleLabel,self.cancleBtn,self.sureBtn,line]];
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.contentView);
        make.width.height.mas_equalTo(27);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.height.mas_equalTo(50);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.titleLabel);
        make.height.mas_equalTo(1.0/[UIScreen mainScreen].scale);
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.bottom.equalTo(self.contentView).offset(-29);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.contentView]) {
        return NO;
    }
    return YES;
}

- (void)sureAction{
    self.sureBlock();
}

- (void)show {
    [self layoutIfNeeded];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.3 animations:^{
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(kScreenHeight - self.contentH);
        }];
        self.backgroundColor = COLOR_RGB(0, 0, 0, 0.6);
        [self layoutIfNeeded];
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:.3 animations:^{
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(kScreenHeight);
        }];
        self.backgroundColor = COLOR_RGB(0, 0, 0, 0);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

#pragma mark lazy ------------
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = FontMedium(16.f);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"提示";
    }
    return _titleLabel;
}

- (UIButton *)cancleBtn{
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleBtn setImage:[UIImage imageNamed:@"car_cancel"] forState:UIControlStateNormal];
        [_cancleBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_cancleBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
        [_cancleBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.layer.cornerRadius  = 2.f;
        [_sureBtn setBackgroundColor:COLOR_HEX(0x444444)];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn.titleLabel setFont:FontMedium(14.f)];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

@end
