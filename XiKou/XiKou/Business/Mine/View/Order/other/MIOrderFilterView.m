//
//  MIOrderFilterView.m
//  XiKou
//
//  Created by L.O.U on 2019/7/11.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIOrderFilterView.h"

@interface MIOrderFilterView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *tagView;

@property (nonatomic, strong) UITextField *minField;

@property (nonatomic, strong) UITextField *maxField;

@end

@implementation MIOrderFilterView
{
    OrderTimeFilter _timeFiler;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self creatSubViews];
        [self creatTagsView];
    }
    return self;
}

- (void)creatSubViews{
   
    UILabel *firstTitleLabel = [UILabel new];
    firstTitleLabel.text = @"创建时间";
    firstTitleLabel.font = FontMedium(14.f);
    firstTitleLabel.textColor =  COLOR_TEXT_GRAY;
    
    _tagView = [UIView new];
    
    UILabel *secondTitleLabel = [UILabel new];
    secondTitleLabel.text = @"订单金额";
    secondTitleLabel.font = FontMedium(14.f);
    secondTitleLabel.textColor =  COLOR_TEXT_GRAY;
    
    _minField = [UITextField new];
    _minField.textColor = COLOR_TEXT_BLACK;
    _minField.font = Font(13.f);
    _minField.delegate  = self;
    _minField.backgroundColor = COLOR_VIEW_GRAY;
    _minField.layer.cornerRadius = 2;
    _minField.clipsToBounds = YES;
    _minField.placeholder = @"输入最低金额";
    _minField.keyboardType = UIKeyboardTypeNumberPad;
    _minField.textAlignment = NSTextAlignmentCenter;
    
    UILabel *middleLabel = [UILabel new];
    middleLabel.text = @"至";
    middleLabel.font = FontMedium(13.f);
    middleLabel.textColor =  COLOR_TEXT_BLACK;
    middleLabel.textAlignment = NSTextAlignmentCenter;
    
    _maxField = [UITextField new];
    _maxField.textColor = COLOR_TEXT_BLACK;
    _maxField.font = Font(13.f);
    _maxField.delegate  = self;
    _maxField.backgroundColor = COLOR_VIEW_GRAY;
    _maxField.layer.cornerRadius = 2;
    _maxField.clipsToBounds = YES;
    _maxField.placeholder = @"输入最高金额";
    _maxField.keyboardType = UIKeyboardTypeNumberPad;
    _maxField.textAlignment = NSTextAlignmentCenter;
    
    UIButton *reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reloadBtn.layer.masksToBounds = YES;
    reloadBtn.layer.cornerRadius  = 2.f;
    [reloadBtn setBackgroundColor:COLOR_TEXT_BROWN];
    [reloadBtn setTitle:@"重置" forState:UIControlStateNormal];
    [reloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reloadBtn.titleLabel setFont:FontMedium(14.f)];
    [reloadBtn addTarget:self action:@selector(reloadClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    endBtn.layer.masksToBounds = YES;
    endBtn.layer.cornerRadius  = 2.f;
    [endBtn setBackgroundColor:COLOR_TEXT_BLACK];
    [endBtn setTitle:@"完成" forState:UIControlStateNormal];
    [endBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [endBtn.titleLabel setFont:FontMedium(14.f)];
    [endBtn addTarget:self action:@selector(endClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self xk_addSubviews:@[firstTitleLabel,_tagView,secondTitleLabel,
                           _minField,middleLabel,_maxField,
                           reloadBtn,endBtn]];
    [firstTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(34);
        make.top.equalTo(self);
    }];
    [_tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(firstTitleLabel);
        make.top.equalTo(firstTitleLabel.mas_bottom);
    }];
    [secondTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(firstTitleLabel);
        make.top.equalTo(self.tagView.mas_bottom).offset(20);
    }];
    [_minField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(secondTitleLabel);
        make.top.equalTo(secondTitleLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(110, 35));
    }];
    [middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.minField);
        make.left.equalTo(self.minField.mas_right);
        make.width.mas_equalTo(39);
    }];
    [_maxField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(self.minField);
        make.left.equalTo(middleLabel.mas_right);
    }];
    [reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minField);
        make.top.equalTo(self.minField.mas_bottom).offset(50);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - 15*3)/2, 42));
    }];
    [endBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(reloadBtn);
        make.left.equalTo(reloadBtn.mas_right).offset(15);
    }];
}

- (void)creatTagsView{
    NSArray *titles = @[@"不限",@"最近一个月",@"最近三个月"];
    UIView *lastView;
    for (int i = 0; i<titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i + 100;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius  = 2.f;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTitleColor:COLOR_TEXT_BLACK forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:COLOR_VIEW_GRAY] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:COLOR_VIEW_GRAY] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageWithColor:COLOR_TEXT_BLACK] forState:UIControlStateSelected];
        [button.titleLabel setFont:Font(13.f)];
        [button addTarget:self action:@selector(tagClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.tagView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(35);
            make.top.equalTo(self.tagView);
            if (!lastView) {
                make.left.equalTo(self.tagView);
            }else{
                make.left.equalTo(lastView.mas_right).offset(10);
            }
            if (i == 0) {
                make.width.mas_equalTo(75);
            }else{
                make.width.mas_equalTo(90);
            }
        }];
        lastView = button;
    }
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tagView);
    }];
}


- (void)tagClick:(UIButton *)sender{
    for (UIButton *button in self.tagView.subviews) {
        button.selected = (button == sender);
    }
}

- (void)reloadClick{
    _minField.text = @"";
    _maxField.text = @"";
    _timeFiler = Unlimited;
    for (UIButton *btn in self.tagView.subviews) {
        btn.selected = NO;
    }
}

- (void)endClick{
    CGFloat value1 = [self.minField.text  doubleValue];
    CGFloat value2 = [self.maxField.text  doubleValue];
    if (value1 > value2) {
        XKShowToast(@"最低价不能大于最高价");
        return;
    }
    _filterBlock(_timeFiler,_minField.text,_maxField.text);
}
@end
