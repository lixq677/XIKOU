//
//  MIConsignIngSctionFooter.m
//  XiKou
//
//  Created by L.O.U on 2019/7/28.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIConsignIngSctionFooter.h"
@interface MIConsignIngSctionFooter()
@property (nonatomic,strong) NSMutableArray *mutableArray;
@end
@implementation MIConsignIngSctionFooter

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius  = 4.f;
        [self.contentView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(-9);
        }];
        
    }
    return self;
}
- (void)buttonAction:(UIButton *)button {
    if (self.buttonAction) {
        self.buttonAction(button.titleLabel.text);
    }
}
- (void)dealloc{
    NSLog(@"释放：%s",__func__);
}
- (void)setButtonsTitle:(NSArray *)titles {
    for (UIView *button in _bgView.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button removeFromSuperview];
        }
    }
    [self.mutableArray removeAllObjects];
    for (NSString *title in titles) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:title forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius  = 29/2.0;
        [button.titleLabel setFont:Font(12.f)];
        [button setTitleColor:HexRGB(0x444444, 1.0f) forState:UIControlStateNormal];
        if ([title isEqualToString:@"发货"]) {
            [self setBtnBackStyle:button];
        }else{
            [self setBtnLightStyle:button];
        }
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:button];
        [self.mutableArray addObject:button];
    }
    CGFloat leadSpac = kScreenWidth - 120*titles.count;
    if(self.mutableArray.count >= 2){
        [self.mutableArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:leadSpac tailSpacing:10];
        [self.mutableArray mas_makeConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(self.bgView);
               make.height.mas_equalTo(29);
           }];
    }else{
        [self.mutableArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView);
            make.height.mas_equalTo(29);
            make.trailing.mas_equalTo(-10.0f);
            make.width.mas_equalTo(90);
        }];
    }
}

- (NSMutableArray *)mutableArray {
    if (!_mutableArray) {
        _mutableArray = [[NSMutableArray alloc] init];
    }
    return _mutableArray;
}
- (void)setBtnBackStyle:(UIButton *)btn{
    [btn setBackgroundColor:COLOR_TEXT_BLACK];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.borderColor = nil;
    btn.layer.borderWidth = 0;
}

- (void)setBtnLightStyle:(UIButton *)btn{
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:COLOR_TEXT_BLACK forState:UIControlStateNormal];
    btn.layer.borderColor = [COLOR_TEXT_BLACK CGColor];
    btn.layer.borderWidth = 1;
}

@end
