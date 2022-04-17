//
//  XKPlaceholdTableCell.m
//  XiKou
//
//  Created by L.O.U on 2019/8/19.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKPlaceholdTableCell.h"

@implementation XKPlaceholdBaseCell

+ (CGFloat)cellHeight{
    return 0;
}

@end


@interface XKPlaceholdGoodCell ()

@property (nonatomic,strong) UIImageView *imgView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *firstLabel;

@property (nonatomic,strong) UILabel *secondLabel;


@end

@implementation XKPlaceholdGoodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.contentView xk_addSubviews:@[self.imgView,self.titleLabel,self.firstLabel,self.secondLabel]];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(15);
            make.bottom.mas_equalTo(-15);
            make.width.equalTo(self.imgView.mas_height);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgView.mas_right).offset(10);
            make.top.equalTo(self.imgView);
            make.right.mas_equalTo(-15);
        }];
        
        [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
            make.width.equalTo(self.titleLabel).multipliedBy(2/3.f);
        }];
        
        [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.bottom.equalTo(self.imgView.mas_bottom);
            make.width.equalTo(self.titleLabel).multipliedBy(1/3.f);
        }];
        
        self.contentView.layer.cornerRadius  = 5.f;
        self.contentView.layer.masksToBounds = YES;
        self.imgView.layer.cornerRadius = 2.f;
        self.titleLabel.layer.cornerRadius = 5.f;
        self.firstLabel.layer.cornerRadius = 5.f;
        self.secondLabel.layer.cornerRadius = 5.f;
    }
    return self;
}

+ (CGFloat)cellHeight{
    return 140;
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [UIImageView new];
    }
    return _imgView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)firstLabel{
    if (!_firstLabel) {
        _firstLabel = [[UILabel alloc] init];
        _firstLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _firstLabel;
}

- (UILabel *)secondLabel{
    if (!_secondLabel) {
        _secondLabel = [[UILabel alloc] init];
        _secondLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _secondLabel;
}
@end

@interface XKPlaceholdTextCell ()

@property (nonatomic,strong) UIImageView *imgView;

@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation XKPlaceholdTextCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView xk_addSubviews:@[self.imgView,self.titleLabel]];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.equalTo(self.contentView);
            make.width.height.mas_equalTo(20);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(15);
            make.centerY.equalTo(self.imgView);
            make.left.equalTo(self.imgView.mas_right).offset(10);
        }];
        self.imgView.layer.cornerRadius = 2.f;
        self.titleLabel.layer.cornerRadius = 5.f;
    }
    return self;
}

+ (CGFloat)cellHeight{
    return 40;
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [UIImageView new];
    }
    return _imgView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _titleLabel;
}

@end

@interface XKPlaceholdGoodInfoCell ()

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIView *firstLabel;

@property (nonatomic,strong) UILabel *secondLabel;

@property (nonatomic,strong) UILabel *thirdLabel;

@property (nonatomic,strong) UILabel *fourthLabel;

@end

@implementation XKPlaceholdGoodInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView xk_addSubviews:@[self.titleLabel,self.firstLabel,self.secondLabel,self.thirdLabel,self.fourthLabel]];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(19);
            make.height.mas_equalTo(30);
        }];
        [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(15);
        }];
        [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.firstLabel);
            make.top.equalTo(self.firstLabel.mas_bottom).offset(20);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(15);
        }];
        [self.thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.secondLabel.mas_right).offset(20);
            make.top.bottom.width.equalTo(self.secondLabel);
        }];
        [self.fourthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.thirdLabel.mas_right).offset(20);
            make.top.bottom.width.equalTo(self.secondLabel);
        }];
        
        self.titleLabel.layer.cornerRadius  = 5.f;
        self.firstLabel.layer.cornerRadius  = 5.f;
        self.secondLabel.layer.cornerRadius = 5.f;
        self.thirdLabel.layer.cornerRadius  = 5.f;
        self.fourthLabel.layer.cornerRadius = 5.f;
    }
    return self;
}

+ (CGFloat)cellHeight{
    return 130;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UIView *)firstLabel{
    if (!_firstLabel) {
        _firstLabel = [[UIView alloc] init];
//        _firstLabel.backgroundColor = COLOR_TEXT_RED;
//        _firstLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _firstLabel;
}

- (UILabel *)secondLabel{
    if (!_secondLabel) {
        _secondLabel = [[UILabel alloc] init];
        _secondLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _secondLabel;
}

- (UILabel *)thirdLabel{
    if (!_thirdLabel) {
        _thirdLabel = [[UILabel alloc] init];
        _thirdLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _thirdLabel;
}

- (UILabel *)fourthLabel{
    if (!_fourthLabel) {
        _fourthLabel = [[UILabel alloc] init];
        _fourthLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _fourthLabel;
}

@end
