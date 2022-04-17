//
//  MIOrderDetailTableSectionHeader.m
//  XiKou
//
//  Created by L.O.U on 2019/7/25.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIOrderDetailSectionHeader.h"
#import "MIOrderUserDetailView.h"
@implementation MIOrderDetailSectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *titleBgView = [UIView new];
        titleBgView.backgroundColor = [UIColor whiteColor];
        [titleBgView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(titleBgView);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
        }];

        [self xk_addSubviews:@[self.topBgView,self.addressView,titleBgView,self.userView]];
        [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_greaterThanOrEqualTo(73);
        }];
        [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.addressView);
        }];
        [self.topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.bottom.equalTo(self.addressView).offset(-20);
        }];
        [titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self.addressView.mas_bottom).offset(10);
            make.height.mas_equalTo(40);
        }];
        self.addressView.layer.masksToBounds = YES;
        self.addressView.layer.cornerRadius  = 4.f;
        self.userView.layer.masksToBounds = YES;
        self.userView.layer.cornerRadius  = 4.f;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        self.addressView.userInteractionEnabled = YES;
        [self.addressView addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)tapAction:(UITapGestureRecognizer *)tapGesture{
    if ([self.delegate respondsToSelector:@selector(orderDetailSectionHeader:clickIt:)]) {
        [self.delegate orderDetailSectionHeader:self clickIt:tapGesture];
    }
}

- (void)showUserViewNamePhone:(NSString *)namePhone isBuyer:(BOOL)isBuyer userIcon:(NSString *)userIcon status:(NSString *)status {
    self.addressView.hidden = YES;
    self.userView.hidden = NO;
    [self.addressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(88);
    }];
    [self.userView reloadImageUrl:userIcon type:isBuyer namePhone:namePhone status:status];

}
- (MIAddressInfoView *)addressView{
    if (!_addressView) {
        _addressView = [[MIAddressInfoView alloc]init];
    }
    return _addressView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    }
    return _titleLabel;
}

- (UIView *)topBgView{
    if (!_topBgView) {
        _topBgView = [UIView new];
        _topBgView.backgroundColor = [UIColor clearColor];
    }
    return _topBgView;
}
- (MIOrderUserDetailView *)userView {
    if (!_userView) {
        _userView = [[MIOrderUserDetailView alloc] init];
        _userView.backgroundColor = [UIColor whiteColor];
        _userView.hidden = YES;
    }
    return _userView;
}
@end


@implementation MIAddressInfoView
@synthesize imageView = _imageView;
@synthesize hintLabel = _hintLabel;
@synthesize nameLabel = _nameLabel;
@synthesize phoneLabel = _phoneLabel;
@synthesize addressLabel = _addressLabel;
@synthesize icon = _icon;
@synthesize arrow = _arrow;


- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.icon];
        [self addSubview:self.nameLabel];
        [self addSubview:self.phoneLabel];
        [self addSubview:self.addressLabel];
        [self addSubview:self.arrow];
        [self addSubview:self.imageView];
        [self addSubview:self.hintLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.hasAddress) {
        self.imageView.hidden = YES;
        self.hintLabel.hidden = YES;
        self.icon.hidden = NO;
        self.nameLabel.hidden = NO;
        self.phoneLabel.hidden = NO;
        self.addressLabel.hidden = NO;
        self.arrow.frame = CGRectMake(self.width-30, self.height*0.5f-7.5f, 7, 15);
        self.icon.left = 15.0f;
        self.icon.top = 20.0f;
        [self.nameLabel sizeToFit];
        self.nameLabel.frame = CGRectMake(self.icon.right+10.0f, self.icon.y, self.nameLabel.width, 16);
        self.phoneLabel.frame = CGRectMake(self.nameLabel.right+10.0f, self.nameLabel.y, self.arrow.left-20-self.nameLabel.right, self.nameLabel.height);
        self.addressLabel.frame = CGRectMake(self.nameLabel.left, self.nameLabel.bottom, self.phoneLabel.right-self.nameLabel.left, 30.0f);
    }else{
        self.imageView.hidden = NO;
        self.hintLabel.hidden = NO;
        self.icon.hidden = YES;
        self.nameLabel.hidden = YES;
        self.phoneLabel.hidden = YES;
        self.addressLabel.hidden = YES;
        self.arrow.hidden = YES;
        self.imageView.frame = CGRectMake(0.5*(self.width-19.0f), 19.0f, 19.0, 19.0f);
        self.hintLabel.center = CGPointMake(self.imageView.centerX, self.imageView.bottom+17.0f);
    }
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = Font(15.f);
    }
    return _nameLabel;
}

- (UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel = [UILabel new];
        _phoneLabel.font = Font(15.f);
    }
    return _phoneLabel;
}

- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = Font(12.f);
        _addressLabel.textColor = COLOR_TEXT_GRAY;
        _addressLabel.numberOfLines = 0;
    }
    return _addressLabel;
}

- (UILabel *)hintLabel{
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.textColor = HexRGB(0x999999, 1.0f);
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.font = [UIFont systemFontOfSize:12.0f];
        _hintLabel.text = @"请添加收货地址";
        [_hintLabel sizeToFit];
    }
    return _hintLabel;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location"]];
    }
    return _icon;
}

- (UIImageView *)arrow{
    if (!_arrow) {
        _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_arrow"]];
    }
    return _arrow;
}


- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_add_el"]];
    }
    return _imageView;
}

@end
