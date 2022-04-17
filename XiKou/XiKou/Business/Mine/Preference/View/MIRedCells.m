//
//  MIRedCells.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/7.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIRedCells.h"
#import "XKUIUnitls.h"


@implementation MIRedCell
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize timeLabel = _timeLabel;
@synthesize amountLabel = _amountLabel;
@synthesize imageView = _imageView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.detailTextLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.amountLabel];
        [self.contentView addSubview:self.imageView];
        self.separatorInset = UIEdgeInsetsMake(0, 65.0f, 0, 0);
        [self layout];
    }
    return self;
}


- (void)layout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.top.mas_equalTo(18.0f);
        make.height.width.mas_equalTo(30.0f);
        make.bottom.equalTo(self.contentView).mas_offset(-48.0f);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20.0f);
        make.left.mas_equalTo(self.imageView.mas_right).offset(15.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(5.0f);
        make.left.equalTo(self.textLabel);
        make.height.mas_equalTo(12.0f);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detailTextLabel.mas_bottom).offset(11.0f);
        make.left.equalTo(self.detailTextLabel);
        make.height.mas_equalTo(12.0f);
    }];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20.0f);
        make.right.equalTo(self.contentView).offset(-20.0f);
    }];
}


#pragma mark getter or setter

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:15.0f];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        _detailTextLabel.textColor = HexRGB(0x999999, 1.0f);
    }
    return _detailTextLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12.0f];
        _timeLabel.textColor = HexRGB(0x999999, 1.0f);
    }
    return _timeLabel;
}

- (UILabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.textColor = HexRGB(0xf94119, 1.0f);
        _amountLabel.textAlignment = NSTextAlignmentRight;
        _amountLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        
    }
    return _amountLabel;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.cornerRadius = 15.0f;
    }
    return _imageView;
}

@end


@implementation MIRedRecordHeaderView
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.detailTextLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.mas_equalTo(20.0f);
            make.top.equalTo(self.contentView).offset(16.0f);
            make.bottom.equalTo(self.contentView).offset(-16.0f);
            make.height.mas_equalTo(15.0f);
        }];
        [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.mas_equalTo(-20.0f);
        }];
    }
    return self;
}


- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:15.0f];
        _textLabel.textColor = HexRGB(0x999999, 1.0f);
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.font = [UIFont systemFontOfSize:10.0f];
        _detailTextLabel.textColor = HexRGB(0x999999, 1.0f);
        _detailTextLabel.textAlignment = NSTextAlignmentRight;
    }
    return _detailTextLabel;
}


@end

@implementation MIRedTableViewCell
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.detailTextLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.mas_equalTo(20.0f);
            make.top.bottom.equalTo(self.contentView);
        }];
        [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.mas_equalTo(-20.0f);
            make.left.mas_equalTo(self.textLabel.mas_right).offset(40);
        }];

    }
    return self;
}


- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:15.0f];
        _textLabel.textColor = HexRGB(0x999999, 1.0f);
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.font = [UIFont systemFontOfSize:10.0f];
        _detailTextLabel.textColor = HexRGB(0x999999, 1.0f);
        _detailTextLabel.textAlignment = NSTextAlignmentRight;
    }
    return _detailTextLabel;
}



@end
