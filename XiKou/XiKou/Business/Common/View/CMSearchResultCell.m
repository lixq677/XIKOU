//
//  CMSearchResultCell.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/9/20.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "CMSearchResultCell.h"

@implementation CMSearchResultCell
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.detailTextLabel];
        self.textLabel.textColor = HexRGB(0x444444, 1.0f);
        self.textLabel.font = [UIFont systemFontOfSize:12.0f];
        self.detailTextLabel.textColor = HexRGB(0xcccccc, 1.0f);
        self.detailTextLabel.font = [UIFont systemFontOfSize:10.0f];
        [self layout];
    }
    return self;
}


- (void)layout{
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(-100);
    }];
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textLabel.mas_right).offset(10.0f);
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(-15.0f);
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
        _detailTextLabel.textAlignment = NSTextAlignmentRight;
        _detailTextLabel.numberOfLines = 0;
    }
    return _detailTextLabel;
}

@end
