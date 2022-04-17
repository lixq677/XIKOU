//
//  MIOrderUserDetailView.m
//  XiKou
//
//  Created by majia on 2019/11/4.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIOrderUserDetailView.h"
@interface MIOrderUserDetailView ()
@property (nonatomic,strong) UIImageView *userIcon;
@property (nonatomic,strong) UILabel *userTypeLabel;
@property (nonatomic,strong) UILabel *userDetailLabel;
@property (nonatomic,strong) UILabel *statusLabel;
@end
@implementation MIOrderUserDetailView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setDefaultUI];
    }
    return self;
}


#pragma mark - private method

- (void)setDefaultUI {
    [self addSubview:self.userIcon];
    [self addSubview:self.userTypeLabel];
    [self addSubview:self.userDetailLabel];
    [self addSubview:self.statusLabel];
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(9.5);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    [self.userTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userIcon);
        make.left.equalTo(self.userIcon.mas_right).offset(10);
    }];
    [self.userDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userTypeLabel.mas_bottom).offset(7.5);
        make.left.equalTo(self.userTypeLabel);
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userDetailLabel);
        make.bottom.equalTo(self.userIcon);
    }];
}


#pragma mark - public method
- (void)reloadImageUrl:(NSString *)imageUrl type:(BOOL)type namePhone:(NSString *)namePhone status:(NSString *)status {
    self.statusLabel.text = status;
    self.userDetailLabel.text = namePhone;
    self.userTypeLabel.text = type ? @"买家" : @"卖家";
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
}


#pragma mark - lazy

- (UIImageView *)userIcon {
    if (!_userIcon) {
        _userIcon = [[UIImageView alloc] init];
        _userIcon.layer.cornerRadius = 30;
        _userIcon.layer.masksToBounds = YES;
    }
    return _userIcon;
}
- (UILabel *)userTypeLabel {
    if (!_userTypeLabel) {
        _userTypeLabel = [[UILabel alloc] init];
        _userTypeLabel.textColor = COLOR_HEX(0x9B9B9B);
        _userTypeLabel.textAlignment = NSTextAlignmentLeft;
        _userTypeLabel.font = Font(12);
    }
    return _userTypeLabel;
}
- (UILabel *)userDetailLabel {
    if (!_userDetailLabel) {
        _userDetailLabel = [[UILabel alloc] init];
        _userDetailLabel.textColor = COLOR_TEXT_BLACK;
        _userDetailLabel.textAlignment = NSTextAlignmentLeft;
        _userDetailLabel.font = Font(15);
    }
    return _userDetailLabel;
}
- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = COLOR_HEX(0x9B9B9B);
        _statusLabel.textAlignment = NSTextAlignmentLeft;
        _statusLabel.font = Font(12);
    }
    return _statusLabel;
}
@end
