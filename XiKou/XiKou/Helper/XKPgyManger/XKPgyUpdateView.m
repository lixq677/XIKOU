//
//  XKPgyUpdateView.m
//  XiKou
//
//  Created by L.O.U on 2019/8/8.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKPgyUpdateView.h"
#import "UILabel+NSMutableAttributedString.h"

@interface XKPgyUpdateView ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat contentH;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *cancleBtn;

@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIView *bgContentView;

@property (nonatomic, assign) BOOL forceUpdate;

@end

@implementation XKPgyUpdateView

- (instancetype)initWithContent:(NSString *)content forceUpdate:(BOOL)forceUpdate{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (self) {
        _forceUpdate = forceUpdate;
        self.backgroundColor = COLOR_RGB(0, 0, 0, 0.6);
        self.userInteractionEnabled = YES;
        
        self.contentLabel.text = [NSString stringWithFormat:@"更新内容\n%@",content];
        [self.contentLabel setAttributedStringWithSubString:@"更新内容" color:COLOR_TEXT_BLACK font:FontMedium(13.f)];
        [self.contentLabel setLineSpace:12.f];
        [self creatSubviews];
        if (forceUpdate) {
            self.cancleBtn.hidden = YES;
        }else{
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
            tap.delegate = self;
            [self addGestureRecognizer:tap];
        }
    }
    return self;
}

- (void)creatSubviews{
    [self addSubview:self.bgContentView];
    [self.bgContentView xk_addSubviews:@[self.contentView,self.cancleBtn]];
    [self.contentView xk_addSubviews:@[self.imageView,self.contentLabel,self.sureBtn]];
    [self.bgContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(53);
        make.right.equalTo(self).offset(-53);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-40);
    }];
    
    [self.contentLabel setContentHuggingPriority:MASLayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.top.right.equalTo(self.bgContentView);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.bgContentView);
        make.top.equalTo(self.cancleBtn.mas_bottom).offset(19);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo((kScreenWidth - 106)/2.7);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(21);
        make.right.equalTo(self.contentView).offset(-21);
        make.top.equalTo(self.imageView.mas_bottom).offset(20);
    }];

    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-35);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(20);
        make.bottom.equalTo(self.contentView).offset(-25);
        make.height.mas_equalTo(47);
    }];
    [self layoutIfNeeded];
    self.bgContentView.transform = CGAffineTransformMakeScale(CGFLOAT_MIN, CGFLOAT_MIN);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (!self.forceUpdate) {
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        [linePath moveToPoint:CGPointMake(self.cancleBtn.centerX, self.cancleBtn.bottom)];
        [linePath addLineToPoint:CGPointMake(self.cancleBtn.centerX, self.contentView.top)];
        
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        lineLayer.lineWidth = 0.5;
        lineLayer.strokeColor = COLOR_HEX(0xE3E3E3).CGColor;
        lineLayer.path = linePath.CGPath;
        
        [self.bgContentView.layer addSublayer:lineLayer];
    }
}

#pragma mark - Action
- (void)sureAction{
    [self dismiss];
    if (_sureBlock) {
        _sureBlock();
    }
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.contentView]) {
        return NO;
    }
    return YES;
}

- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.bgContentView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];

}

- (void)dismiss {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = COLOR_RGB(0, 0, 0, 0.1);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius  = 7.f;
    }
    return _contentView;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.font = Font(12.f);
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = COLOR_TEXT_GRAY;
    }
    return _contentLabel;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.layer.cornerRadius  = 35/2.f;
       // [_sureBtn setBackgroundColor:COLOR_HEX(0x444444)];
        [_sureBtn setBackgroundImage:[UIImage imageNamed:@"ic_update_button"] forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn.titleLabel setFont:FontMedium(14.f)];
        [_sureBtn setTitle:@"立即更新" forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UIButton *)cancleBtn{
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleBtn setImage:[UIImage imageNamed:@"cancle"] forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}

- (UIView *)bgContentView{
    if (!_bgContentView) {
        _bgContentView = [UIView new];
    }
    return _bgContentView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.image = [UIImage imageNamed:@"update"];
    }
    return _imageView;
}
@end
