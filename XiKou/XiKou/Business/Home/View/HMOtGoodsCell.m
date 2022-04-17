//
//  HMOtGoodsCell.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/2.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "HMOtGoodsCell.h"
#import "XKUIUnitls.h"

@implementation HMOtGoodsCell
@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize priceLabel = _priceLabel;
@synthesize transmitLabel = _transmitLabel;
@synthesize originalLabel = _originalLabel;
@synthesize dashView = _dashView;
@synthesize rankBgView = _rankBgView;
@synthesize rankLabel = _rankLabel;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self setup];
        [self autoLayout];
    }
    return self;
}

- (void)setup{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.detailTextLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.originalLabel];
    [self.contentView addSubview:self.transmitLabel];
    [self.contentView addSubview:self.dashView];
    [self.contentView addSubview:self.rankBgView];
    [self.contentView addSubview:self.rankLabel];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    self.contentView.layer.cornerRadius = 5.0f;
    self.contentView.layer.masksToBounds = YES;
//    self.contentView.layer.backgroundColor = COLOR_TEXT_RED.CGColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)autoLayout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.imageView.mas_height);
        make.left.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    [self.rankBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imageView);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(22.0f);
        make.left.mas_equalTo(0);
    }];
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.rankBgView);
        make.left.mas_equalTo(9.0f);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(10);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(13);
    }];
    [self.transmitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-15);
        make.height.mas_equalTo(12);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(10);
        make.height.mas_equalTo(15);
        make.centerY.equalTo(self.transmitLabel);
    }];
    if (IS_IPHONE_MIN) {
        [self.originalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.priceLabel);
            make.bottom.equalTo(self.priceLabel.mas_top).offset(-10);
            make.height.mas_equalTo(15);
        }];
        [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.originalLabel);
            make.bottom.equalTo(self.originalLabel.mas_top).offset(-5);
            make.height.mas_equalTo(15);
        }];
    }else{
        [self.originalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.priceLabel);
            make.left.equalTo(self.priceLabel.mas_right).offset(5);
        }];
        [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.priceLabel);
            make.bottom.equalTo(self.priceLabel.mas_top).offset(-10);
            make.height.mas_equalTo(15);
        }];
    }
    
    [self.dashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.height.equalTo(self.detailTextLabel);
    }];
    self.dashView.hidden = YES;
}

#pragma mark getter or setter
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius  = 2.0f;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.font = [UIFont systemFontOfSize:14.0f];
        _textLabel.numberOfLines = 2;
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
        _priceLabel.textColor = COLOR_TEXT_RED;
    }
    return _priceLabel;
}

- (UILabel *)transmitLabel{
    if (!_transmitLabel) {
        _transmitLabel = [[UILabel alloc] init];
        _transmitLabel.textColor = COLOR_TEXT_GRAY;
        _transmitLabel.font = Font(12.f);
//        _transmitLabel.numberOfLines = 0;
    }
    return _transmitLabel;
}

- (UILabel *)originalLabel{
    if (!_originalLabel) {
        _originalLabel = [UILabel new];
        _originalLabel.font = Font(10.f);
        _originalLabel.textColor = COLOR_PRICE_GRAY;
    }
    return _originalLabel;
}

- (ACTDashedView *)dashView{
    if (!_dashView) {
        _dashView = [[ACTDashedView alloc]init];
    }
    return _dashView;
}

- (UILabel *)rankLabel{
    if (!_rankLabel) {
        _rankLabel = [UILabel new];
        _rankLabel.font = FontSemibold(12.f);
        //_rankLabel.textAlignment = NSTextAlignmentCenter;
        _rankLabel.textColor = [UIColor whiteColor];
    }
    return _rankLabel;
}

- (UIImageView *)rankBgView{
    if (!_rankBgView) {
        _rankBgView = [UIImageView new];
        _rankBgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _rankBgView;
}
@end
