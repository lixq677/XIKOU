//
//  XKSortButton.m
//  XiKou
//
//  Created by L.O.U on 2019/7/7.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKSortButton.h"

@interface XKSortButton ()

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation XKSortButton

- (instancetype)init{
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI搭建

- (void)setupUI {

    self.backgroundColor = [UIColor whiteColor];
    
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    contentView.userInteractionEnabled = NO;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.centerX.mas_equalTo(self);
        make.left.mas_greaterThanOrEqualTo(self).mas_offset(3);
        make.right.mas_lessThanOrEqualTo(self).mas_offset(-3);
    }];

    self.textLabel = [UILabel new];
    self.textLabel.font = Font(13.f);
    self.textLabel.textColor = COLOR_TEXT_BLACK;
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    
    self.imgView  = [UIImageView new];
    self.imgView.image = [UIImage imageNamed:@"arrow_dw"];
    self.imgView.contentMode = UIViewContentModeCenter;
    
    [contentView xk_addSubviews:@[self.textLabel,self.imgView]];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.mas_offset(0);
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.mas_equalTo(contentView);
        make.left.mas_equalTo(self.textLabel.mas_right);
        make.right.mas_equalTo(contentView);
    }];
}

#pragma mark - 赋值选中状态

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.textLabel.textColor = COLOR_TEXT_BLACK;
        if (super.selected) {
            // 那么就切换筛选状态
            _ascending = !_ascending;
            if (_ascending) {
                // 升序
                self.imgView.image = [UIImage imageNamed:@"arrow_pu"];
            } else {
                // 降序
                self.imgView.image = [UIImage imageNamed:@"arrow_dw"];
            }
        } else {
            // 那么设置成选中的默认排序状态：升序
            _ascending = YES;
            self.imgView.image = [UIImage imageNamed:@"arrow_pu"];
        }
    } else {
        // 非选中状态
        self.imgView.image = [UIImage imageNamed:@"arrow_default"];
        self.textLabel.textColor = COLOR_TEXT_GRAY;
    }
    
    // 最后再赋值
    [super setSelected:selected];
}

#pragma mark - 赋值文本

- (void)setTitle:(NSString *)title {
    _title = title;
    self.textLabel.text = title;
}


@end
