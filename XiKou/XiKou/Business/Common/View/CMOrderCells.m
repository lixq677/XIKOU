//
//  CMOrderCells.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/9.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "CMOrderCells.h"

@implementation CMOrderAddrCell
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize imageView = _imageView;
@synthesize hintLabel = _hintLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.detailTextLabel];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.hintLabel];
        [self layout];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.hasAddress) {
        self.textLabel.hidden = NO;
        self.detailTextLabel.hidden = NO;
        self.imageView.hidden = YES;
        self.hintLabel.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        self.textLabel.hidden = YES;
        self.detailTextLabel.hidden = YES;
        self.imageView.hidden = NO;
        self.hintLabel.hidden = NO;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopLeft |UIRectCornerTopRight) cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = bezierPath.CGPath;
    layer.fillColor = [UIColor whiteColor].CGColor;
    [self.layer insertSublayer:layer atIndex:0];
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
}

- (void)layout{
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25.0f);
        make.left.mas_equalTo(15.0f);
        make.height.mas_greaterThanOrEqualTo(15.0f);
    }];
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(8.0f);
        make.left.equalTo(self.textLabel);
        make.right.equalTo(self.contentView).offset(-40.0f);
        make.bottom.equalTo(self.contentView).offset(-20.0f);
        make.height.mas_greaterThanOrEqualTo(12.0f);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(25.0f);
        make.top.mas_equalTo(19.0f);
        make.centerX.equalTo(self.contentView);
    }];
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(7.0f);
        make.centerX.equalTo(self.imageView);
    }];
    
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = FontMedium(15.f);
        _textLabel.textColor = COLOR_TEXT_BLACK;
        _textLabel.numberOfLines = 0;
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.font = Font(12.f);
        _detailTextLabel.textColor = COLOR_TEXT_GRAY;
        _detailTextLabel.numberOfLines = 0;
    }
    return _detailTextLabel;
}

- (UILabel *)hintLabel{
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.textColor = HexRGB(0x999999, 1.0f);
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.font = [UIFont systemFontOfSize:12.0f];
        _hintLabel.text = @"请添加收货地址";
    }
    return _hintLabel;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_add_el"]];
    }
    return _imageView;
}

@end

@implementation CMOrderGoodCell
@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize priceLabel = _priceLabel;
@synthesize countLabel = _countLabel;
@synthesize discountLabel = _discountLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        [self autoLayout];
    }
    return self;
}

- (void)setup{
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.detailTextLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.discountLabel];
}

- (void)autoLayout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.width.height.mas_equalTo(70.0f);
        make.bottom.equalTo(self.contentView).mas_offset(-15.0f);
        make.top.equalTo(self.contentView).mas_offset(15.0f);
    }];
    
    [self.priceLabel setContentCompressionResistancePriority:MASLayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15.0f);
        make.top.mas_equalTo(20.0f);
        make.height.mas_equalTo(10.0f);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(10.0f);
        make.right.mas_equalTo(self.priceLabel.mas_left).offset(-30.0f);
        make.top.mas_equalTo(13.0f);
    }];
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel);
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(5.0f);
        make.height.mas_equalTo(10.0f);
    }];
    [self.countLabel setContentHuggingPriority:MASLayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(38.0f);
        make.right.equalTo(self.priceLabel);
        make.height.mas_equalTo(10.0f);
    }];
    [self.discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(15);
        make.left.equalTo(self.textLabel);
        make.bottom.equalTo(self.imageView).offset(-5);
    }];
    self.discountLabel.hidden = YES;
}

#pragma mark getter or setter
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius  = 2.0f;
    }
    return _imageView;
}
- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.font = [UIFont systemFontOfSize:12.0f];
        _textLabel.numberOfLines = 2;
    }
    return _textLabel;
}
- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.textColor = HexRGB(0x999999, 1.0f);
        _detailTextLabel.font = [UIFont systemFontOfSize:10.0f];
    }
    return _detailTextLabel;
}
- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = HexRGB(0x444444, 1.0f);
        _priceLabel.font = [UIFont systemFontOfSize:12.0f];
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}
- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = HexRGB(0x999999, 1.0f);
        _countLabel.font = [UIFont systemFontOfSize:12.0f];
        _countLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countLabel;
}
- (UILabel *)discountLabel{
    if (!_discountLabel) {
        _discountLabel = [[UILabel alloc] init];
        _discountLabel.textColor = COLOR_TEXT_RED;
        _discountLabel.font = Font(10.f);
        _discountLabel.textAlignment = NSTextAlignmentCenter;
        _discountLabel.layer.borderColor = COLOR_TEXT_RED.CGColor;
        _discountLabel.layer.borderWidth = 0.5/[UIScreen mainScreen].scale;
        _discountLabel.layer.masksToBounds = YES;
        _discountLabel.layer.cornerRadius = 1.f;
    }
    return _discountLabel;
}

@end

@implementation CMOrderDeliveryCell
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.detailTextLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15.0f);
            make.top.mas_equalTo(17.0f);
            make.width.mas_equalTo(100);
            make.centerY.equalTo(self.contentView);
        }];
        [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15.0f);
            make.centerY.equalTo(self.textLabel);
            make.left.mas_equalTo(self.textLabel.mas_right).offset(30);
        }];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.bottomCell) {
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerBottomLeft |UIRectCornerBottomRight) cornerRadii:CGSizeMake(4, 4)];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = bezierPath.CGPath;
        layer.fillColor = [UIColor whiteColor].CGColor;
        [self.layer insertSublayer:layer atIndex:0];
        self.backgroundColor = [UIColor clearColor];
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:13.0f];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.numberOfLines = 0;
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        _detailTextLabel.textColor = HexRGB(0x999999, 1.0f);
        //_detailTextLabel.numberOfLines = 0;
        _detailTextLabel.textAlignment = NSTextAlignmentRight;
    }
    return _detailTextLabel;
}

@end

@interface CMOrderPaidByOtherCell ()

@property (nonatomic,strong)UIButton *button;
@property (nonatomic,strong)UILabel *subTitleLabel;

@end

@implementation CMOrderPaidByOtherCell
@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setup];
        [self autoLayout];
    }
    return self;
}

- (void)setup{
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.button];
    
}

- (void)autoLayout{
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.button.mas_right).offset(15);
        make.width.height.mas_equalTo(25.0f);
        make.centerY.equalTo(self.button);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(10.0f);
        make.centerY.equalTo(self.contentView);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(scalef(-35));
        make.centerY.equalTo(self);
    }];
}

- (void)setPaidSelect:(BOOL)paidSelect{
    [self.button setSelected:paidSelect];
}

- (BOOL)paidSelect{
    return [self.button isSelected];
}
- (void)setPayStyle:(BOOL)friendPay friendPhone:(nonnull NSString *)phone {
    if (friendPay) {
        self.subTitleLabel.hidden = NO;
        self.subTitleLabel.text = phone;
    }else{
        self.subTitleLabel.hidden = YES;
    }
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_paid_others"]];
        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = 2.0f;
    }
    return _imageView;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.font = [UIFont systemFontOfSize:13.0f];
        _textLabel.text = @"请合伙人代付";
    }
    return _textLabel;
}
- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = HexRGB(0x9b9b9b, 1.0f);
        _subTitleLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    return _subTitleLabel;
}
- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setImage:[UIImage imageNamed:@"Oval_deselect"] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"Oval_select"] forState:UIControlStateSelected];
        _button.userInteractionEnabled = NO;
        [_button sizeToFit];
    }
    return _button;
}

@end

@implementation CMOrderDetailCell
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.detailTextLabel];
        self.backgroundColor = [UIColor whiteColor];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.width.mas_equalTo(80);
            make.centerY.equalTo(self.contentView);
        }];
        [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-20);
            make.left.equalTo(self.textLabel.mas_right).offset(20);
            make.top.mas_equalTo(12);
            make.bottom.mas_equalTo(-12);
            make.height.mas_greaterThanOrEqualTo(26);
        }];
    }
    return self;
}


- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = Font(13.f);
        _textLabel.textColor = COLOR_TEXT_BLACK;
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.font = Font(13.f);
        _detailTextLabel.textColor = COLOR_TEXT_GRAY;
        _detailTextLabel.textAlignment = NSTextAlignmentRight;
        _detailTextLabel.numberOfLines = 0;
    }
    return _detailTextLabel;
}

@end

@interface CMOrderPaymentCell ()

@property (nonatomic,strong)UIButton *button;

@end

@implementation CMOrderPaymentCell
@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setup];
        [self autoLayout];
    }
    return self;
}

- (void)setup{
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.textLabel];
    self.accessoryView = self.button;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)autoLayout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.width.height.mas_equalTo(25.0f);
        make.centerY.equalTo(self.contentView);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(10.0f);
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(50.0f);
        make.top.bottom.mas_equalTo(0);
    }];
}

- (void)setPaidSelect:(BOOL)paidSelect{
    [self.button setSelected:paidSelect];
}

- (BOOL)paidSelect{
    return [self.button isSelected];
}


- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    return _textLabel;
}

- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setImage:[UIImage imageNamed:@"Oval_deselect"] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"Oval_select"] forState:UIControlStateSelected];
        _button.userInteractionEnabled = NO;
        [_button sizeToFit];
    }
    return _button;
}

@end
