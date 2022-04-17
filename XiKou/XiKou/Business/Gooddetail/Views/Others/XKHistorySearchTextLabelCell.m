//
//  XKHistorySearchTextLabelCell.m
//  XiKou
//
//  Created by majia on 2019/11/4.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKHistorySearchTextLabelCell.h"

@implementation XKHistorySearchTextLabelCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = COLOR_HEX(0xcccccc).CGColor;
        self.layer.borderWidth = 0.5;
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = COLOR_TEXT_BLACK;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = Font(15);
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.centerX.equalTo(self);
            make.left.equalTo(self).offset(5);
            make.right.equalTo(self).offset(-5);
        }];
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.textColor = COLOR_TEXT_BLACK;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = Font(12);
        [self addSubview:self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.centerX.equalTo(self);
            make.left.equalTo(self).offset(5);
            make.right.equalTo(self).offset(-5);
        }];
    }
    return self;
}

@end
