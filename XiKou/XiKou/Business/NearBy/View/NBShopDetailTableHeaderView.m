//
//  NBShopDetailTableHeaderView.m
//  XiKou
//
//  Created by L.O.U on 2019/7/11.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "NBShopDetailTableHeaderView.h"
#import "UIButton+Position.h"

@interface NBShopDetailTableHeaderView ()

@end

@implementation NBShopDetailTableHeaderView
@synthesize coverView = _coverView;
@synthesize titleLabel = _titleLabel;
@synthesize addressLabel = _addressLabel;
@synthesize classLabel = _classLabel;
@synthesize distanceLabel = _distanceLabel;
@synthesize timeLabel = _timeLabel;
@synthesize detailAddressLabel = _detailAddressLabel;
@synthesize fansNumLabel = _fansNumLabel;
@synthesize viewedNumLabel = _viewedNumLabel;

- (instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, 240)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self creatSubViews];
    }
    return self;
}


- (void)qrcodeClick{
    
}

- (void)creatSubViews{

    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius  = 5.f;
    
    UIButton *codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [codeBtn setImage:[UIImage imageNamed:@"qrcode"] forState:UIControlStateNormal];
    [codeBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    [codeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [codeBtn addTarget:self action:@selector(qrcodeClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *middleLine = [UIView new];
    middleLine.backgroundColor = COLOR_LINE_GRAY;
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = COLOR_LINE_GRAY;
    
    [contentView xk_addSubviews:@[codeBtn,self.titleLabel,self.addressLabel,
                                  self.classLabel,self.distanceLabel,self.timeLabel,
                                  self.detailAddressLabel,middleLine,bottomLine,
                                  self.fansNumLabel,self.viewedNumLabel]];
    [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(35);
        make.right.top.equalTo(contentView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(43);
        make.height.mas_equalTo(16);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(7);
        make.width.mas_lessThanOrEqualTo(150.0f);
    }];
    [self.classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addressLabel.mas_left).offset(-10);
        make.top.bottom.equalTo(self.addressLabel);
    }];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressLabel.mas_right).offset(10);
        make.top.bottom.equalTo(self.addressLabel);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.height.mas_equalTo(18);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(12);
    }];
    [self.detailAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(11);
    }];
    [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailAddressLabel.mas_bottom).offset(23);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(1.0/[UIScreen mainScreen].scale);
    }];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1.0/[UIScreen mainScreen].scale);
        make.centerX.equalTo(contentView);
        make.top.equalTo(middleLine.mas_bottom).offset(18);
        make.height.mas_equalTo(9);
    }];
    [self.fansNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomLine.mas_left).offset(-15);
        make.left.equalTo(middleLine);
        make.centerY.equalTo(bottomLine);
    }];
    [self.viewedNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomLine.mas_right).offset(15);
        make.right.equalTo(middleLine);
        make.centerY.equalTo(bottomLine);
    }];
    
    [self xk_addSubviews:@[contentView,self.coverView]];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(22);
        make.bottom.mas_equalTo(-10);
        make.right.mas_equalTo(-22);
        make.top.mas_equalTo(30);
    }];
    [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.width.height.mas_equalTo(60);
    }];
}

- (UIImageView *)coverView{
    if (!_coverView) {
        _coverView = [UIImageView new];
        _coverView.contentMode  = UIViewContentModeScaleAspectFill;
        _coverView.layer.masksToBounds = YES;
        _coverView.layer.cornerRadius  = 30.f;
        _coverView.layer.borderColor   = [UIColor whiteColor].CGColor;
        _coverView.layer.borderWidth   = 2.f;
    }
    return _coverView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = FontMedium(16.f);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = COLOR_TEXT_BLACK;
    }
    return _titleLabel;
}
- (AddressLabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [AddressLabel new];
        _addressLabel.font = Font(10.f);
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        _addressLabel.textColor = COLOR_TEXT_GRAY;
        _addressLabel.numberOfLines = 0;
    }
    return _addressLabel;
}
- (UILabel *)classLabel{
    if (!_classLabel) {
        _classLabel = [UILabel new];
        _classLabel.font = Font(10.f);
        _classLabel.textColor = COLOR_TEXT_GRAY;
    }
    return _classLabel;
}
- (UILabel *)distanceLabel{
    if (!_distanceLabel) {
        _distanceLabel = [UILabel new];
        _distanceLabel.font = Font(10.f);
        _distanceLabel.textColor = COLOR_TEXT_GRAY;
    }
    return _distanceLabel;
}
- (BusinessHoursLabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [BusinessHoursLabel new];
    }
    return _timeLabel;
}
- (UIButton *)detailAddressLabel{
    if (!_detailAddressLabel) {
        _detailAddressLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_detailAddressLabel setTitleColor:COLOR_TEXT_BLACK forState:UIControlStateNormal];
        [_detailAddressLabel.titleLabel setFont:Font(10.f)];
        [_detailAddressLabel setImage:[UIImage imageNamed:@"locationGray"] forState:UIControlStateNormal];
    }
    return _detailAddressLabel;
}
- (UILabel *)fansNumLabel{
    if (!_fansNumLabel) {
        _fansNumLabel = [UILabel new];
        _fansNumLabel.textAlignment = NSTextAlignmentRight;
        _fansNumLabel.textColor = COLOR_TEXT_BLACK;
        _fansNumLabel.font      = Font(12.f);
    }
    return _fansNumLabel;
}
- (UILabel *)viewedNumLabel{
    if (!_viewedNumLabel) {
        _viewedNumLabel = [UILabel new];
        _viewedNumLabel.textAlignment = NSTextAlignmentLeft;
        _viewedNumLabel.textColor = COLOR_TEXT_BLACK;
        _viewedNumLabel.font      = Font(12.f);
    }
    return _viewedNumLabel;
}
@end

@implementation AddressLabel

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [COLOR_LINE_GRAY setStroke];
    CGContextSetLineWidth(context, 1.0/[UIScreen mainScreen].scale);
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y+5);
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y+12);
    CGContextMoveToPoint(context, rect.size.width+rect.origin.x-1.0/[UIScreen mainScreen].scale, rect.origin.y+5);
    CGContextAddLineToPoint(context, rect.size.width+rect.origin.x-1.0/[UIScreen mainScreen].scale, rect.origin.y+12);
    CGContextStrokePath(context);
}

@end

@implementation BusinessHoursLabel
{
    UILabel *_valueLabel;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = COLOR_TEXT_BROWN.CGColor;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius  = 1.f;
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = Font(10.f);
        titleLabel.backgroundColor = COLOR_TEXT_BROWN;
        titleLabel.textAlignment   = NSTextAlignmentCenter;
        titleLabel.textColor       = [UIColor whiteColor];
        titleLabel.text            = @"营业时间";
        
        _valueLabel = [UILabel new];
        _valueLabel.font = Font(10.f);
        _valueLabel.textColor       = COLOR_TEXT_BROWN;
        _valueLabel.textAlignment   = NSTextAlignmentCenter;
        _valueLabel.backgroundColor = [UIColor whiteColor];
        _valueLabel.text            = @"0:00-24:00";
        
        [self xk_addSubviews:@[_valueLabel,titleLabel]];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.width.mas_equalTo(50);
        }];
        [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self);
            make.width.mas_equalTo(66);
            make.left.equalTo(titleLabel.mas_right);
        }];
    }
    return self;
}

- (void)setValue:(NSString *)value{
    _valueLabel.text = value;
}
@end
