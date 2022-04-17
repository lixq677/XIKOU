//
//  XKCustomAlertView.m
//  XiKou
//
//  Created by L.O.U on 2019/7/3.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKCustomAlertView.h"
#import "XKUIUnitls.h"


@interface XKCustomAlertView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) UIButton *cancleBtn;

//@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *otherBtn;

@property (nonatomic, strong) UIView *bgContentView;

@property (nonatomic, strong) CAGradientLayer *gl;
@end

@implementation XKCustomAlertView{
    AlertType _type;
}
@synthesize contentLabel = _contentLabel;

- (instancetype)initWithType:(AlertType)type
                    andTitle:(NSString *__nullable)title
                  andContent:(NSString *)content
                 andBtnTitle:(NSString *)btnTitle
               otherBtnTitle:(NSString *__nullable)otherBtnTitle{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (self) {
        _type = type;
        self.backgroundColor = COLOR_RGB(0, 0, 0, 0.6);
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        if (otherBtnTitle) {
            [self.otherBtn setTitle:otherBtnTitle forState:UIControlStateNormal];
        }
        [self.sureBtn setTitle:btnTitle forState:UIControlStateNormal];
        [self.contentLabel setText:content];
        [self.titleLabel setText:title];
        [self creatSubviews];
        [self show];
    }
    return self;
}

- (instancetype)initWithType:(AlertType)type
                    andTitle:(NSString *)title
                  andContent:(NSString *)content
                 andBtnTitle:(NSString *)btnTitle{
    return [self initWithType:type andTitle:title andContent:content andBtnTitle:btnTitle otherBtnTitle:nil];
}

- (instancetype)initWithType:(AlertType)type
   andTitle:(NSString *)title
 andAttributeContent:(NSAttributedString *)content
                 andBtnTitle:(NSString *)btnTitle otherBtnTitle:(nullable NSString *)otherBtnTitle{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (self) {
        _type = type;
        self.backgroundColor = COLOR_RGB(0, 0, 0, 0.6);
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        if (otherBtnTitle) {
            [self.otherBtn setTitle:otherBtnTitle forState:UIControlStateNormal];
        }
        [self.sureBtn setTitle:btnTitle forState:UIControlStateNormal];
        [self.contentLabel setAttributedText:content];
        [self.titleLabel setText:title];
        [self creatSubviews];
        [self show];
    }
    return self;
}

- (instancetype)initWithType:(AlertType)type
                    andTitle:(NSString *)title
                  andAttributeContent:(NSAttributedString *)content
                 andBtnTitle:(NSString *)btnTitle{
    return [self initWithType:type andTitle:title andAttributeContent:content andBtnTitle:btnTitle otherBtnTitle:nil];
}

- (void)creatSubviews{
    [self addSubview:self.bgContentView];
    [self.bgContentView addSubview:self.contentView];
    [self.contentView xk_addSubviews:@[self.contentLabel,self.sureBtn]];
    if (_otherBtn) {
        [self.contentView addSubview:self.otherBtn];
    }
    switch (_type) {
        case CanleAndTitle:{
            [self.bgContentView addSubview:self.cancleBtn];
            [self.contentView addSubview:self.titleLabel];
        }
            break;
        case CanleNoTitle:{
            [self.bgContentView addSubview:self.cancleBtn];
        }
            break;
        case NoCancle:{
            [self.contentView addSubview:self.titleLabel];
        }
            break;
        case OnlyContent:{
        }
            break;
        default:
            break;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame)-106;
    
    switch (_type) {
           case CanleAndTitle:{
               self.cancleBtn.frame = CGRectMake(width-32, 0, 32, 32);
               self.titleLabel.frame = CGRectMake(15, 0, width-30.0f, 46);
               CGSize size = [self.contentLabel sizeThatFits:CGSizeMake(width-66, MAXFLOAT)];
               self.contentLabel.frame = CGRectMake(33.0f, self.titleLabel.bottom+25, width-66, size.height);
               if (_otherBtn) {
                   self.otherBtn.frame = CGRectMake(self.contentLabel.x, self.contentLabel.bottom+18, 0.5*(self.contentLabel.width-20), 42);
                   self.sureBtn.frame = CGRectMake(self.otherBtn.right+20, self.contentLabel.bottom+18, 0.5*(self.contentLabel.width-20), 42);
               }else{
                   self.sureBtn.frame = CGRectMake(self.contentLabel.x, self.contentLabel.bottom+18, self.contentLabel.width, 42);
               }
               self.contentView.frame = CGRectMake(0, self.cancleBtn.bottom+19, width, self.sureBtn.bottom+25.0f - self.titleLabel.y);
               self.bgContentView.frame = CGRectMake(53.0f, self.middleY-40-0.5*self.contentView.bottom, width, self.contentView.bottom);
           }
               break;
           case CanleNoTitle:{
               CGSize size = [self.contentLabel sizeThatFits:CGSizeMake(width-66, MAXFLOAT)];
               self.cancleBtn.frame = CGRectMake(width-32, 0, 32, 32);
               self.contentLabel.frame = CGRectMake(33.0f,25, width-66, size.height);
               if (_otherBtn) {
                   self.otherBtn.frame = CGRectMake(self.contentLabel.x, self.contentLabel.bottom+18, 0.5*(self.contentLabel.width-20), 42);
                   self.sureBtn.frame = CGRectMake(self.otherBtn.right+20, self.contentLabel.bottom+18, 0.5*(self.contentLabel.width-20), 42);
               }else{
                   self.sureBtn.frame = CGRectMake(self.contentLabel.x, self.contentLabel.bottom+18, self.contentLabel.width, 42);
               }
               self.contentView.frame = CGRectMake(0, self.cancleBtn.bottom+19, width, self.sureBtn.bottom+25.0f);
               self.bgContentView.frame = CGRectMake(53.0f, self.middleY-40-0.5*self.contentView.bottom, width, self.contentView.bottom);
           }
               break;
           case NoCancle:{
               self.titleLabel.frame = CGRectMake(15, 0, width-30.0f, 46);
               CGSize size = [self.contentLabel sizeThatFits:CGSizeMake(width-66, MAXFLOAT)];
               self.contentLabel.frame = CGRectMake(33.0f, self.titleLabel.bottom+25, width-66, size.height);
               if (_otherBtn) {
                   self.otherBtn.frame = CGRectMake(self.contentLabel.x, self.contentLabel.bottom+18, 0.5*(self.contentLabel.width-20), 42);
                   self.sureBtn.frame = CGRectMake(self.otherBtn.right+20, self.contentLabel.bottom+18, 0.5*(self.contentLabel.width-20), 42);
               }else{
                   self.sureBtn.frame = CGRectMake(self.contentLabel.x, self.contentLabel.bottom+18, self.contentLabel.width, 42);
               }
               self.contentView.frame = CGRectMake(0, self.titleLabel.y, width, self.sureBtn.bottom+25.0f - self.titleLabel.y);
               self.bgContentView.frame = CGRectMake(53.0f, self.middleY-40-0.5*self.contentView.bottom, width, self.contentView.bottom);
           }
               break;
           case OnlyContent:{
               CGSize size = [self.contentLabel sizeThatFits:CGSizeMake(width-66, MAXFLOAT)];
               self.contentLabel.frame = CGRectMake(33.0f, 40, width-66, size.height);
               if (_otherBtn) {
                   self.otherBtn.frame = CGRectMake(self.contentLabel.x, self.contentLabel.bottom+18, 0.5*(self.contentLabel.width-20), 42);
                   self.sureBtn.frame = CGRectMake(self.otherBtn.right+20, self.contentLabel.bottom+18, 0.5*(self.contentLabel.width-20), 42);
               }else{
                   self.sureBtn.frame = CGRectMake(self.contentLabel.x, self.contentLabel.bottom+18, self.contentLabel.width, 42);
               }
               self.contentView.frame = CGRectMake(0, 0, width, self.sureBtn.bottom+25.0f);
               self.bgContentView.frame = CGRectMake(53.0f, self.middleY-40-0.5*self.contentView.bottom, width, self.contentView.bottom);
           }
               break;
           default:
               break;
       }
    if (self.btnStyle == AlertBtnStyle1) {
           self.gl.frame = self.sureBtn.bounds;
    }
    if (_type == CanleNoTitle || _type == CanleAndTitle) {

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
    if (self.sureBlock) {
        self.sureBlock();
    }
}

- (void)otherAction{
    [self dismiss];
    if (self.otherBlock) {
        self.otherBlock();
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
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.4f;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.bgContentView.layer addAnimation:animation forKey:nil];

}

- (void)dismiss {
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [UIView animateWithDuration:0.2 animations:^{
        self.bgContentView.transform = (CGAffineTransformMakeScale(1.5, 1.5));
        self.backgroundColor = COLOR_RGB(0, 0, 0, 0.1);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
//    [UIView animateWithDuration:0.3 animations:^{
//        self.bgContentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
////        self.bgContentView.transform = CGAffineTransformIdentity;
//    } completion:^(BOOL finished) {
//        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//        [self removeFromSuperview];
//    }];
//    [UIView animateWithDuration:.3 animations:^{
//        [self.bgContentView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).offset(kScreenHeight);
//        }];
//        self.backgroundColor = COLOR_RGB(0, 0, 0, 0);
//        [self layoutIfNeeded];
//    } completion:^(BOOL finished) {
//        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//        [self removeFromSuperview];
//    }];
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius  = 5.f;
    }
    return _contentView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = FontMedium(16.f);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"提示";
        _titleLabel.backgroundColor     = [UIColor whiteColor];
        _titleLabel.layer.shadowColor   = COLOR_RGB(228, 228, 228, 1).CGColor;
        _titleLabel.layer.shadowOffset  = CGSizeMake(0,0.5);
        _titleLabel.layer.shadowOpacity = 1;
        _titleLabel.layer.shadowRadius  = 0;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.font = Font(13.f);
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (void)setBtnStyle:(AlertBtnStyle)btnStyle{
    _btnStyle = btnStyle;
    if (btnStyle == AlertBtnStyleDefault) {
        [self.sureBtn setBackgroundColor:COLOR_HEX(0x444444)];
//        if (_gl) {
//            [self.gl removeFromSuperlayer];
//        }
    }else{
        [self.sureBtn.layer insertSublayer:self.gl atIndex:0];
    }
}

- (CAGradientLayer *)gl{
    if (!_gl) {
        _gl = [CAGradientLayer layer];
        _gl.frame = CGRectMake(0,0,310.0,40.0f);
        _gl.startPoint = CGPointMake(1.0f, 1.0f);
        _gl.endPoint = CGPointMake(0, 0.33);
        _gl.colors = @[(__bridge id)[UIColor colorWithRed:227/255.0 green:194/255.0 blue:157/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:187/255.0 green:148/255.0 blue:69/255.0 alpha:1.0].CGColor];
        _gl.locations = @[@(0), @(1.0f)];
    }
    return _gl;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.layer.cornerRadius  = 2.f;
        [_sureBtn setBackgroundColor:COLOR_HEX(0x444444)];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn.titleLabel setFont:FontMedium(14.f)];
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UIButton *)otherBtn{
    if (!_otherBtn) {
        _otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _otherBtn.layer.masksToBounds = YES;
        _otherBtn.layer.cornerRadius  = 2.f;
        _otherBtn.layer.borderWidth = 1.0f;
        _otherBtn.layer.borderColor = [HexRGB(0x444444, 1.0f) CGColor];
        [_otherBtn setTitleColor:HexRGB(0x444444, 1.0f) forState:UIControlStateNormal];
        [_otherBtn.titleLabel setFont:FontMedium(14.f)];
        [_otherBtn addTarget:self action:@selector(otherAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _otherBtn;
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
@end
