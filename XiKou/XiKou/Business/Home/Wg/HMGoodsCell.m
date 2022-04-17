//
//  XKGoodsCell.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/1.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "HMCommonGoodsCell.h"
#import "XKUIUnitls.h"

@implementation HMCommonGoodsCell
@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize priceLabel = _priceLabel;
@synthesize buyBtn = _buyBtn;

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
    [self.contentView addSubview:self.buyBtn];
}

- (void)autoLayout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.mas_equalTo(15.0f);
        make.width.height.mas_equalTo(110.0f);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_equalTo(-15.0f);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(10.0f);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15.0f);
        make.height.mas_equalTo(40.0f);
        make.top.mas_equalTo(18.0f);
    }];
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel);
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(31.0f);
        make.height.mas_equalTo(14.0f);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailTextLabel);
        make.top.mas_equalTo(self.detailTextLabel.mas_bottom).offset(6.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.textLabel);
        make.bottom.equalTo(self.contentView).offset(-15.0f);
        make.width.mas_equalTo(70.0f);
        make.height.mas_equalTo(29.0f);
    }];
    
}



#pragma mark getter or setter
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        
    }
    return _imageView;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.font = [UIFont systemFontOfSize:14.0f];
        _textLabel.numberOfLines = 0;
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.textColor = HexRGB(0xf94119, 1.0f);
        _detailTextLabel.font = [UIFont systemFontOfSize:9.0f];
        _detailTextLabel.layer.cornerRadius = 1.0f;
        _detailTextLabel.layer.borderColor = [HexRGB(0xef421c, 1.0f) CGColor];
        _detailTextLabel.layer.borderWidth = 0.5f;
        
    }
    return _detailTextLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
    }
    return _priceLabel;
}


- (UIButton *)buyBtn{
    if (!_buyBtn) {
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyBtn.backgroundColor = HexRGB(0x444444, 1.0f);
        _buyBtn.layer.cornerRadius = 2.0f;
        [_buyBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
        [_buyBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    }
    return _buyBtn;
}

@end
