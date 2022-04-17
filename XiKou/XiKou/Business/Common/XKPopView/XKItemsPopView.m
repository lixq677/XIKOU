//
//  XKItemsPopView.m
//  XiKou
//
//  Created by L.O.U on 2019/7/11.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKItemsPopView.h"

@interface XKItemsPopView ()

@property (nonatomic, strong) UIView *itemView;

@property (nonatomic, assign) NSInteger selectIndex;
@end

@implementation XKItemsPopView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self layoutByContentHeight:378];
        [self addSubview:self.itemView];
        [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(16);
            make.right.equalTo(self).offset(-16);
            make.bottom.equalTo(self.sureBtn.mas_top).offset(-10);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
        }];
    }
    return self;
}

- (void)showWithTitle:(NSString *)title andItems:(nonnull NSArray<NSString *> *)items andSelectIndex:(NSInteger)selectIndex andComplete:(nonnull void (^)(NSInteger))complete{
    
    _selectIndex = selectIndex;
    self.titleLabel.text = title;
    [self.itemView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView *lastView;
    CGFloat space  = 10;
    CGFloat insert = 16;
    CGFloat height = 40;
    CGFloat width  = (kScreenWidth - insert*2 - space*2)/3;
    for (int i = 0; i< items.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.borderColor   = COLOR_LINE_GRAY.CGColor;
        button.layer.borderWidth   = 0.5;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius  = 2.f;
        button.tag = i;
        button.selected = (_selectIndex == i);
        [button setTitle:items[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTitleColor:COLOR_TEXT_BLACK forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageWithColor:COLOR_TEXT_BLACK] forState:UIControlStateSelected];
        [button.titleLabel setFont:FontMedium(13.f)];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.itemView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
            make.width.mas_equalTo(width);
            if (!lastView) {
                make.top.equalTo(self.itemView);
                make.left.equalTo(self.itemView);
            }else{
                if (i%3 == 0) {
                    make.top.equalTo(lastView.mas_bottom).offset(space);
                    make.left.equalTo(self.itemView);
                }else{
                    make.left.equalTo(lastView.mas_right).offset(space);
                    make.top.equalTo(lastView);
                }
            }
        }];
        lastView = button;
    }
    
    [self show];
    @weakify(self);
    self.sureBlock  = ^{
        @strongify(self);
        if (items.count == 0) {
            [self dismiss];
            return ;
        }
        [UIView animateWithDuration:.3 animations:^{
            [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(kScreenHeight);
            }];
            self.backgroundColor = COLOR_RGB(0, 0, 0, 0);
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            complete(self.selectIndex);
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self removeFromSuperview];
        }];
    };
}

- (void)buttonAction:(UIButton *)sender{
    for (UIButton *button in self.itemView.subviews) {
        button.selected = (sender == button);
    }
    _selectIndex = sender.tag;
}

- (UIView *)itemView{
    if (!_itemView) {
        _itemView = [UIView new];
    }
    return _itemView;
}
@end
