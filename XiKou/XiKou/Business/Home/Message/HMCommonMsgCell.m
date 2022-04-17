//
//  HMCommonMsgCell.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/8.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "HMCommonMsgCell.h"

@implementation HMCommonMsgCell
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize timeLabel = _timeLabel;
@synthesize seeDetailLabel = _seeDetailLabel;
@synthesize line = _line;
@synthesize arrowImageView = _arrowImageView;
@synthesize stateLabel = _stateLabel;
@synthesize imageView = _imageView;
@synthesize hasImage = _hasImage;
@synthesize contentV = _contentV;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentV addSubview:self.textLabel];
        [self.contentV addSubview:self.detailTextLabel];
        [self.contentV addSubview:self.line];
        [self.contentV addSubview:self.timeLabel];
        [self.contentV addSubview:self.seeDetailLabel];
        [self.contentV addSubview:self.arrowImageView];
        [self.contentV addSubview:self.stateLabel];
        [self.contentV addSubview:self.imageView];
        self.backgroundColor = [UIColor clearColor];
        self.contentV.backgroundColor = HexRGB(0xffffff, 1.0f);
        self.contentV.layer.cornerRadius = 5.0f;
        [self addSubview:self.contentV];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layout];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.msgState == HMMsgStateUnread) {
        self.stateLabel.text = @"未读";
        self.stateLabel.textColor = HexRGB(0xf94119, 1.0f);
        self.stateLabel.backgroundColor = HexRGB(0xfdeeea, 1.0f);
        self.stateLabel.hidden = NO;
    }else if (self.msgState == HMMsgStateRead){
        self.stateLabel.text = @"已读";
        self.stateLabel.textColor = HexRGB(0x999999, 1.0f);
        self.stateLabel.backgroundColor = HexRGB(0xeeeeee, 1.0f);
        self.stateLabel.hidden = NO;
    }else{
        self.stateLabel.hidden = YES;
    }
}

- (void)layout{
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.top.mas_equalTo(22.0f);
        make.right.mas_equalTo(-50.0f);
    }];
    
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.right.mas_equalTo(-20.0f);
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(10.0f);
    }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(15.0f);
        make.width.mas_equalTo(28.0f);
        make.top.mas_equalTo(22.0f);
        make.right.equalTo(self.contentV).offset(-20.0f);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentV);
        make.left.mas_equalTo(30.0f);
        make.right.equalTo(self.contentV).offset(-30.0f);
        make.top.mas_equalTo(self.detailTextLabel.mas_bottom).offset(10.0f);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentV).offset(20.0f);
        make.right.equalTo(self.contentV).offset(-20.0f);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(11.0f);
        make.height.mas_equalTo(1.0/[UIScreen mainScreen].scale);
        make.bottom.mas_equalTo(-40.0f);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line);
        make.top.mas_equalTo(self.line.mas_bottom).offset(15.0f);
        make.height.mas_equalTo(10.0f);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.line);
        make.height.mas_equalTo(10.0f);
        make.width.mas_equalTo(7.0f);
        make.top.mas_equalTo(self.line.mas_bottom).offset(15.0f);
    }];
    
    [self.seeDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-5.0f);
        make.centerY.equalTo(self.arrowImageView);
        make.height.mas_equalTo(12.0f);
    }];
    [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(9.0f);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)setHasImage:(BOOL)hasImage{
    _hasImage = hasImage;
    if (hasImage) {
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.imageView.mas_width).multipliedBy(0.75);
        }];
//        [self.detailTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_lessThanOrEqualTo(40.0f);
//        }];
    }else{
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
//        [self.detailTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_lessThanOrEqualTo(120.0f);
//        }];
    }
        
}


#pragma mark getter
- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:15.0f];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.numberOfLines = 0;
        _textLabel.clipsToBounds = NO;
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        _detailTextLabel.textColor = HexRGB(0x999999, 1.0f);
        _detailTextLabel.numberOfLines = 0;
    }
    return _detailTextLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:10.0f];
        _timeLabel.textColor = HexRGB(0xcccccc, 1.0f);
    }
    return _timeLabel;
}

- (UILabel *)seeDetailLabel{
    if (!_seeDetailLabel) {
        _seeDetailLabel = [[UILabel alloc] init];
        _seeDetailLabel.textColor = COLOR_TEXT_BROWN;
        _seeDetailLabel.textAlignment = NSTextAlignmentRight;
        _seeDetailLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _seeDetailLabel.text = @"查看详情";
    }
    return _seeDetailLabel;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HexRGB(0xe4e4e4, 1.0f);
    }
    return _line;
}

- (UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    }
    return _arrowImageView;
}

- (UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = [UIFont systemFontOfSize:9.0f];
        _stateLabel.layer.cornerRadius = 1.0f;
        _stateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _stateLabel;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius  = 2.0f;
    }
    return _imageView;
}

- (UIView *)contentV{
    if (!_contentV) {
        _contentV = [UIView new];
    }
    return _contentV;
}

@end
