//
//  XKBargainPersonCell.m
//  XiKou
//
//  Created by L.O.U on 2019/7/9.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKBargainPersonCell.h"

@implementation XKBargainPersonCell

- (instancetype)initWithPersonCellStyle:(BargainPersonCellType)style reuseIdentifier:(NSString *)reuseIdentifier;{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView xk_addSubviews:@[self.firstLabel,self.secondLabel,self.thirdLabel,self.lastLabel]];
    
        if (style == BargainPersonCellDefault) {
            UIView *line = [UIView new];
            line.backgroundColor = COLOR_LINE_GRAY;
            [self addSubview:line];
            
            CGFloat insert = 20;
            CGFloat space  = 10;
            CGFloat secondWidth = 27;
            
            CGFloat width  = (kScreenWidth - insert*2 - space *3 - secondWidth)/3;
            
            [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(20);
                make.width.mas_equalTo(width);
                make.top.bottom.equalTo(self.contentView);
                make.height.mas_equalTo(45);
            }];
            [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.firstLabel.mas_right).offset(space);
                make.width.mas_equalTo(secondWidth);
                make.top.bottom.equalTo(self.firstLabel);
            }];
            [self.lastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-insert);
                make.width.mas_equalTo(width);
                make.top.bottom.equalTo(self.firstLabel);
                make.left.equalTo(self.thirdLabel.mas_right).offset(space);
            }];
            [self.thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.secondLabel.mas_right).offset(space);
                make.right.equalTo(self.lastLabel.mas_left).offset(-space);
                make.top.bottom.equalTo(self.firstLabel);
            }];
            
        }else{
            
            self.firstLabel.font = Font(13.f);
            self.secondLabel.font = Font(13.f);
            self.firstLabel.font = Font(13.f);
            self.firstLabel.font = Font(13.f);
            [self.contentView addSubview:self.imgView];
            CGFloat insert = 15;
            CGFloat space  = 10;
            CGFloat secondWidth = 27;
            
            CGFloat width  = (kScreenWidth - insert*4 - space *3 - secondWidth)/3;
            [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(17);
                make.centerY.equalTo(self.contentView);
                make.left.mas_equalTo(insert);
            }];
            [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.imgView.mas_right).offset(5);
                make.width.mas_equalTo(width);
                make.top.bottom.equalTo(self.contentView);
                make.height.mas_equalTo(55);
            }];
            [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.firstLabel.mas_right).offset(space);
                make.width.mas_equalTo(secondWidth);
                make.top.bottom.equalTo(self.firstLabel);
            }];
            [self.lastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-insert);
                make.width.mas_equalTo(width);
                make.top.bottom.equalTo(self.firstLabel);
                make.left.equalTo(self.thirdLabel.mas_right).offset(space);
            }];
            [self.thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.secondLabel.mas_right).offset(space);
                make.right.equalTo(self.lastLabel.mas_left).offset(-space);
                make.top.bottom.equalTo(self.firstLabel);
            }];
        }
        
    }
    return self;
}

- (void)setTextColor:(UIColor *)textColor{
    self.firstLabel.textColor = textColor;
    self.secondLabel.textColor = textColor;
    self.thirdLabel.textColor = textColor;
    self.lastLabel.textColor = textColor;
}

- (UILabel *)firstLabel{
    if (!_firstLabel) {
        _firstLabel = [UILabel new];
        _firstLabel.font = Font(12.f);
        _firstLabel.textColor = COLOR_TEXT_GRAY;
        _firstLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _firstLabel;
}

- (UILabel *)secondLabel{
    if (!_secondLabel) {
        _secondLabel = [UILabel new];
        _secondLabel.font = Font(12.f);
        _secondLabel.textColor = COLOR_TEXT_GRAY;
        _secondLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _secondLabel;
}

- (UILabel *)thirdLabel{
    if (!_thirdLabel) {
        _thirdLabel = [UILabel new];
        _thirdLabel.font = Font(12.f);
        _thirdLabel.textColor = COLOR_TEXT_GRAY;
        _thirdLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _thirdLabel;
}

- (UILabel *)lastLabel{
    if (!_lastLabel) {
        _lastLabel = [UILabel new];
        _lastLabel.font = Font(12.f);
        _lastLabel.textColor = COLOR_TEXT_RED;
        _lastLabel.textAlignment = NSTextAlignmentRight;
    }
    return _lastLabel;
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgView;
}
@end
