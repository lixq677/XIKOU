//
//  MIPaySheet.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/10/21.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIPaySheet.h"
#import "XKUIUnitls.h"
#import <AFViewShaker.h>

@interface MIPaySheet ()

@property (nonatomic,strong)UIButton *confirmBtn;

@property (nonatomic,strong)UILabel *textLabel;

@property (nonatomic,strong)UILabel *textLabel1;

@property (nonatomic,strong)UILabel *detailTextLabel1;

@property (nonatomic,strong)UILabel *textLabel2;

@property (nonatomic,strong)UILabel *detailTextLabel2;

@end

@implementation MIPaySheet

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleHeight = 45.0f;
        self.titleLabel.text = @"确认付款";
        [self setup];
        [self autoLayout];
    }
    return self;
}

- (void)setup{
    [self addSubview:self.confirmBtn];
    self.backgroundColor = HexRGB(0xffffff, 1.0f);
    [self.confirmBtn addTarget:self action:@selector(confirAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.textLabel];
    [self addSubview:self.textLabel1];
    [self addSubview:self.textLabel2];
    [self addSubview:self.detailTextLabel1];
    [self addSubview:self.detailTextLabel2];
   
}

- (void)autoLayout{
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(80);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(300);
    }];
    
    [self.textLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(158);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(15.0f);
    }];
    
    [self.detailTextLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.textLabel1);
        make.right.mas_equalTo(-20.0f);
    }];
    
    [self.textLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(193);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(15.0f);
    }];
    
     [self.detailTextLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.textLabel2);
        make.right.mas_equalTo(-20.0f);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(20.0f);
        make.right.equalTo(self).mas_offset(-20.0f);
        make.height.mas_equalTo(40.0f);
        make.bottom.equalTo(self).offset(-30.0f-[XKUIUnitls safeBottom]);
    }];
    
}


- (void)setContent:(NSString *)text{
    self.textLabel.text = text;
}

- (void)confirAction:(id)sender{
    if (self.sureBlock) {
        self.sureBlock();
    }
    [self dismiss];
}


- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        _confirmBtn.backgroundColor = HexRGB(0x444444, 1.0f);
        [_confirmBtn setTitle:@"立即付款" forState:UIControlStateNormal];
        [_confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    }
    return _confirmBtn;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.font = [UIFont boldSystemFontOfSize:25.0f];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return  _textLabel;
}

- (UILabel *)textLabel1{
    if (!_textLabel1) {
        _textLabel1 = [[UILabel alloc] init];
        _textLabel1.textColor = HexRGB(0x444444, 1.0f);
        _textLabel1.font = [UIFont systemFontOfSize:13.0f];
        _textLabel1.textAlignment = NSTextAlignmentLeft;
        _textLabel1.text = @"订单信息";
    }
    return  _textLabel1;
}

- (UILabel *)detailTextLabel1{
    if (!_detailTextLabel1) {
        _detailTextLabel1 = [[UILabel alloc] init];
        _detailTextLabel1.textColor = HexRGB(0x999999, 1.0f);
        _detailTextLabel1.font = [UIFont systemFontOfSize:13.0f];
        _detailTextLabel1.textAlignment = NSTextAlignmentRight;
        _detailTextLabel1.text = @"转账";
    }
    return _detailTextLabel1;
}


- (UILabel *)textLabel2{
    if (!_textLabel2) {
        _textLabel2 = [[UILabel alloc] init];
        _textLabel2.textColor = HexRGB(0x444444, 1.0f);
        _textLabel2.font = [UIFont systemFontOfSize:13.0f];
        _textLabel2.textAlignment = NSTextAlignmentLeft;
        _textLabel2.text = @"付款方式";
    }
    return  _textLabel2;
}

- (UILabel *)detailTextLabel2{
    if (!_detailTextLabel2) {
        _detailTextLabel2 = [[UILabel alloc] init];
        _detailTextLabel2.textColor = HexRGB(0x999999, 1.0f);
        _detailTextLabel2.font = [UIFont systemFontOfSize:13.0f];
        _detailTextLabel2.textAlignment = NSTextAlignmentRight;
        _detailTextLabel2.text = @"余额";
    }
    return _detailTextLabel2;
}


- (CGFloat)sheetWidth{
    return kScreenWidth;
}

- (CGFloat)sheetHeight{
    return  368.0f+[XKUIUnitls safeBottom];
}



@end

