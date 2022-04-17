//
//  HMQualityView.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/9/4.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "HMQualityView.h"

@interface HMQualityView ()

@property (nonatomic,strong)UILabel *textLabel;

@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic,strong)UIImageView *arrowImageView;

@end

@implementation HMQualityView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.textLabel];
        [self addSubview:self.imageView];
        [self addSubview:self.arrowImageView];
        self.textLabel.hidden = YES;
        self.arrowImageView.hidden = YES;
        [self layout];
    }
    return self;
}


- (void)layout{
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(scalef(14.0f));
        make.width.mas_equalTo(scalef(7.0f));
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-5.0f);
        make.width.mas_equalTo(60.0f);
        make.height.mas_equalTo(14.0f);
        make.centerY.mas_equalTo(self);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = @"查看详情";
        _textLabel.textColor = HexRGB(0xbb9445, 1.0f);
        _textLabel.font = [UIFont systemFontOfSize:13.0f];
        _textLabel.textAlignment = NSTextAlignmentRight;
    }
    return _textLabel;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_header_1"]];
        _imageView.contentMode  = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_arrow"]];
    }
    return _arrowImageView;
}

@end
