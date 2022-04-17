//
//  NBShopDetailDesCell.m
//  XiKou
//
//  Created by L.O.U on 2019/7/11.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "NBShopDetailDesCell.h"
#import "UILabel+NSMutableAttributedString.h"
#import "NSString+Common.h"

@interface NBShopDetailDesCell ()

@property (nonatomic, strong) UIButton *expandBtn;

@end

@implementation NBShopDetailDesCell
@synthesize contentLabel = _contentLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *line = [UIView new];
        line.backgroundColor = COLOR_LINE_GRAY;
        [self.contentView xk_addSubviews:@[self.expandBtn,self.contentLabel,line]];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.top.equalTo(self.contentView);
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.expandBtn);
            make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(1.0/[UIScreen mainScreen].scale);
        }];
        [self.expandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.top.mas_equalTo(line.mas_bottom);
            make.left.equalTo(self.contentView).offset(25);
            make.right.equalTo(self.contentView).offset(-25);
            make.height.mas_equalTo(42);
        }];
    }
    return self;
}

- (void)setIsExpand:(BOOL)isExpand{
//    [self.contentLabel sizeToFit];
//    CGFloat height = [self.contentLabel.text getSpaceLabelHeightwithSpace:8.5 withFont:self.contentLabel.font andMaxW:kScreenWidth - 40];
//    NSInteger number = height/(self.contentLabel.font.lineHeight+8.5);
    if (isExpand) {
        self.contentLabel.numberOfLines = 0;
    }else{
        self.contentLabel.numberOfLines = 3;
    }
    _expandBtn.selected = isExpand;
}
- (void)expandAction{
    if (_expandBlock) {
        _expandBlock(_expandBtn.isSelected);
    }
    
}
- (UIButton *)expandBtn{
    if (!_expandBtn) {
        _expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_expandBtn setTitle:@"查看全部" forState:UIControlStateNormal];
        [_expandBtn setTitle:@"收起" forState:UIControlStateSelected];
        [_expandBtn setTitleColor:COLOR_TEXT_GRAY forState:UIControlStateNormal];
        [_expandBtn.titleLabel setFont:Font(12.f)];
        [_expandBtn addTarget:self action:@selector(expandAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _expandBtn;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.font = Font(12.f);
        _contentLabel.textColor = COLOR_TEXT_BLACK;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
@end
