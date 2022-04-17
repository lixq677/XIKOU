//
//  XKGoodPropertyFooter.m
//  XiKou
//
//  Created by L.O.U on 2019/7/16.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKGoodPropertyFooter.h"

@implementation XKGoodPropertyFooter

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.textColor =COLOR_TEXT_GRAY;
        titleLabel.font = Font(14.f);
        titleLabel.numberOfLines = 0;
        titleLabel.text = @"数量";
        
        [self xk_addSubviews:@[self.numerView,self.desLabel,titleLabel]];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.mas_equalTo(34);
            make.top.right.mas_equalTo(10);
            make.left.equalTo(self).offset(15);
        }];
        [self.numerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(22);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(107, 31));
            make.bottom.mas_equalTo(-20);
        }];
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.numerView);
            make.left.equalTo(self.numerView.mas_right).offset(15);
        }];
    }
    return self;
}

- (XKNumberView *)numerView{
    if (!_numerView) {
        _numerView = [XKNumberView new];
        _numerView.editing       = NO;
        _numerView.increaseImage = [UIImage imageNamed:@"increase"];
        _numerView.decreaseImage = [UIImage imageNamed:@"decrease"];
        _numerView.minValue      = 1;
    }
    return _numerView;
}

- (UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel = [UILabel new];
        _desLabel.font = Font(10.f);
        _desLabel.textColor = COLOR_TEXT_GRAY;
    }
    return _desLabel;
}
@end
