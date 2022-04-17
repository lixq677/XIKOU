//
//  XKGoodPropertyHeader.m
//  XiKou
//
//  Created by L.O.U on 2019/7/16.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKGoodPropertyHeader.h"

@implementation XKGoodPropertyHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self) {
        self = [super initWithFrame:frame];
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupViewCell];
    }
    return self;
}

- (void)setupViewCell {
    _titleLabel = [UILabel new];
    _titleLabel.textColor =COLOR_TEXT_GRAY;
    _titleLabel.font = Font(14.f);
    _titleLabel.numberOfLines = 0;
    _titleLabel.text = @"属性名字";
    [self addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
    }];
}
@end
