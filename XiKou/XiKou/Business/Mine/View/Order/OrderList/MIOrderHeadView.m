//
//  MIOrderHeadView.m
//  XiKou
//
//  Created by L.O.U on 2019/7/1.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIOrderHeadView.h"
#import "XKUIUnitls.h"

@implementation MIOrderHeadView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.needCorner = YES;
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.bottom.equalTo(self.contentView);
            make.right.mas_equalTo(-15);
        }];
        
        [_bgView xk_addSubviews:@[self.titleLabel,self.subLabel]];
        [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.bottom.equalTo(self.bgView);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.bottom.equalTo(self.bgView);
            make.right.equalTo(self.subLabel.mas_left).offset(-15);
        }];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.needCorner) {
        [self.bgView layoutIfNeeded];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(4, 4)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = _bgView.bounds;
        maskLayer.path = maskPath.CGPath;
        _bgView.layer.mask = maskLayer;
    }else{
        _bgView.layer.mask = nil;
    }
}

+ (NSString *)identify{
    return NSStringFromClass([self class]);
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.font = FontMedium(14.f);
    }
    return _titleLabel;
}

- (UILabel *)subLabel{
    if (!_subLabel) {
        _subLabel = [UILabel new];
        _subLabel.backgroundColor = [UIColor whiteColor];
        _subLabel.font = Font(12.f);
        _subLabel.textColor = COLOR_TEXT_GRAY;
        _subLabel.textAlignment = NSTextAlignmentRight;
    }
    return _subLabel;
}
@end

@implementation MIOrderDetailHeader
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.needCorner   = NO;
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
        }];
    }
    return self;
}

@end

#import "UIButton+Position.h"

@implementation MIOrderPayAnotherHeader
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleBtn.hidden = YES;
        [self.contentView addSubview:self.titleBtn];
        [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (UIButton *)titleBtn{
    if (!_titleBtn) {
        
        _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleBtn setTitleColor:COLOR_TEXT_BLACK forState:UIControlStateNormal];
        [_titleBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
        [_titleBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_titleBtn.titleLabel setFont:FontMedium(14.f)];
        [_titleBtn XK_imagePositionStyle:XKImagePositionStyleRight spacing:9.f];
    }
    return _titleBtn;
}

@end
