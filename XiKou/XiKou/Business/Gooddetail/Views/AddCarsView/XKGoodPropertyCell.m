 //
//  XKGoodPropertyCell.m
//  XiKou
//
//  Created by L.O.U on 2019/7/16.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKGoodPropertyCell.h"

@implementation XKGoodPropertyCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self) {
        self = [super initWithFrame:frame];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self setupViewCell];
    }
    return self;
}

- (void)setupViewCell {
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius  = 2.f;
    self.layer.borderWidth   = 1;

    [self.contentView addSubview:self.propertyLabel];
    
    [_propertyLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(self.contentView);
    }];
}

- (UILabel *)propertyLabel{
    if (!_propertyLabel) {
        _propertyLabel = [UILabel new];
        _propertyLabel.textColor = [UIColor blackColor];
        _propertyLabel.font = FontMedium(13.f);
        _propertyLabel.numberOfLines = 0;
        _propertyLabel.text = @"属性";
    }
    return _propertyLabel;
}

@end
