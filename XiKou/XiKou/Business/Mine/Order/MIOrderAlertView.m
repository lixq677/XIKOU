//
//  MIOrderAlertView.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/10/10.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIOrderAlertView.h"
#import "XKUIUnitls.h"

@interface MIOrderAlertView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) UIButton *cancleBtn;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *bgContentView;

@property (nonatomic, strong) UIButton *checkBox1;
@property (nonatomic, strong) UILabel *textLabel1;
@property (nonatomic, strong) UILabel *detailTextLabel1;

@property (nonatomic, strong) UIButton *checkBox2;
@property (nonatomic, strong) UILabel *textLabel2;
@property (nonatomic, strong) UILabel *detailTextLabel2;

@property (nonatomic, strong) CAShapeLayer *lineLayer;

@end

@implementation MIOrderAlertView
@synthesize lineLayer = _lineLayer;

- (instancetype)init{
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)]) {
        self.backgroundColor = COLOR_RGB(0, 0, 0, 0.6);
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.contentLabel setText:@"商品寄卖后不能再提货"];
        [self.titleLabel setText:@"请选择寄卖方式"];
        [self creatSubviews];
    }
    return self;
}

- (void)setDefaultSelect{
    if (self.disableWg == NO) {
        [self.checkBox1 setSelected:YES];
    }else if (self.disableShare == NO){
        [self.checkBox2 setSelected:YES];
    }
}

- (void)creatSubviews{
    [self addSubview:self.bgContentView];
    [self.bgContentView addSubview:self.contentView];
    [self.contentView xk_addSubviews:@[self.contentLabel,self.sureBtn]];
    [self.bgContentView addSubview:self.cancleBtn];
    [self.contentView addSubview:self.titleLabel];
    [self.bgContentView.layer addSublayer:self.lineLayer];
    [self.contentView addSubview:self.checkBox1];
    [self.contentView addSubview:self.textLabel1];
    [self.contentView addSubview:self.detailTextLabel1];
    
    [self.contentView addSubview:self.checkBox2];
    [self.contentView addSubview:self.textLabel2];
    [self.contentView addSubview:self.detailTextLabel2];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame)-106;
    
    self.cancleBtn.frame = CGRectMake(width-32, 0, 32, 32);
    self.titleLabel.frame = CGRectMake(15, 0, width-30.0f, 46);
    
    self.checkBox1.frame = CGRectMake(15.0f, self.titleLabel.bottom+15.0f, 18.0f, 28.0f);
    
    CGSize size = [self.textLabel1 sizeThatFits:CGSizeMake(width-66, MAXFLOAT)];
    
    self.textLabel1.frame = CGRectMake(self.checkBox1.right + 5, self.checkBox1.y, width-66, size.height);
    
    size = [self.detailTextLabel1 sizeThatFits:CGSizeMake(width-66, MAXFLOAT)];
    
    self.detailTextLabel1.frame = CGRectMake(self.textLabel1.left, self.textLabel1.bottom+3.0f, width-66, size.height);
    
    
    self.checkBox2.frame = CGRectMake(15.0f, self.detailTextLabel1.bottom+15.0f, 18.0f, 28.0f);
    
    size = [self.textLabel2 sizeThatFits:CGSizeMake(width-66, MAXFLOAT)];
    
    self.textLabel2.frame = CGRectMake(self.checkBox2.right + 5, self.checkBox2.y, width-66, size.height);
    
    size = [self.detailTextLabel2 sizeThatFits:CGSizeMake(width-66, MAXFLOAT)];
    
    self.detailTextLabel2.frame = CGRectMake(self.textLabel2.left, self.textLabel2.bottom+3.0f, width-66, size.height);
    
    self.contentLabel.frame = CGRectMake(33.0f, self.detailTextLabel2.bottom+10, width-66, size.height);
    self.sureBtn.frame = CGRectMake(self.contentLabel.x, self.contentLabel.bottom+18, self.contentLabel.width, 42);
    self.contentView.frame = CGRectMake(0, self.cancleBtn.bottom+19, width, self.sureBtn.bottom+25.0f - self.titleLabel.y);
    self.bgContentView.frame = CGRectMake(53.0f, self.middleY-40-0.5*self.contentView.bottom, width, self.contentView.bottom);
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(self.cancleBtn.centerX, self.cancleBtn.bottom)];
    [linePath addLineToPoint:CGPointMake(self.cancleBtn.centerX, self.contentView.top)];
    self.lineLayer.path = linePath.CGPath;
    if (self.alwaysSelect1) {
        [self.checkBox1 setImage:[UIImage imageNamed:@"Oval_dis_select"] forState:UIControlStateSelected];
        [self.checkBox1 setSelected:YES];
    }
    if (self.disableWg) {
        self.checkBox1.enabled = NO;
        self.textLabel1.textColor = HexRGB(0x9b9b9b, 1.0f);
    }else{
        self.checkBox1.enabled = YES;
        self.textLabel1.textColor = HexRGB(0x444444, 1.0f);
    }
    if (self.disableShare) {
        self.checkBox2.enabled = NO;
        self.textLabel2.textColor = HexRGB(0x9b9b9b, 1.0f);
    }else{
        self.checkBox2.enabled = YES;
        self.textLabel2.textColor = HexRGB(0x444444, 1.0f);
    }
    
   // [self.checkBox1 setSelected:YES];
    if (self.checkBox1.selected == NO && self.checkBox2.selected == NO) {
        self.sureBtn.enabled = NO;
    }else{
        self.sureBtn.enabled = YES;
    }
}

#pragma mark - Action
- (void)sureAction{
    [self dismiss];
    if (self.sureBlock) {
        self.sureBlock(self.checkBox1.selected,self.checkBox2.selected);
    }
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.contentView]) {
        return NO;
    }
    return YES;
}

- (void)show {

    [[UIApplication sharedApplication].keyWindow addSubview:self];
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.4f;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.bgContentView.layer addAnimation:animation forKey:nil];

}

- (void)dismiss {
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [UIView animateWithDuration:0.2 animations:^{
        self.bgContentView.transform = (CGAffineTransformMakeScale(1.5, 1.5));
        self.backgroundColor = COLOR_RGB(0, 0, 0, 0.1);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)clickIt1{
    if (self.alwaysSelect1)return;
    self.checkBox1.selected = !self.checkBox1.selected;
    if(self.checkBox2.selected){
          self.checkBox2.selected = !self.checkBox2.selected;
    }
  
    if (self.checkBox1.selected == NO && self.checkBox2.selected == NO) {
        self.sureBtn.enabled = NO;
    }else{
        self.sureBtn.enabled = YES;
    }
}

- (void)clickIt2{
    if(self.checkBox1.selected){
        self.checkBox1.selected = !self.checkBox1.selected;
    }
    self.checkBox2.selected = !self.checkBox2.selected;
    if (self.checkBox1.selected == NO && self.checkBox2.selected == NO) {
        self.sureBtn.enabled = NO;
    }else{
        self.sureBtn.enabled = YES;
    }
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius  = 5.f;
    }
    return _contentView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = FontMedium(16.f);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"提示";
        _titleLabel.backgroundColor     = [UIColor whiteColor];
        _titleLabel.layer.shadowColor   = COLOR_RGB(228, 228, 228, 1).CGColor;
        _titleLabel.layer.shadowOffset  = CGSizeMake(0,0.5);
        _titleLabel.layer.shadowOpacity = 1;
        _titleLabel.layer.shadowRadius  = 0;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.font = Font(13.f);
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = HexRGB(0xBB9445, 1.0f);
    }
    return _contentLabel;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.layer.cornerRadius  = 2.f;
        [_sureBtn setBackgroundImage:[UIImage imageWithColor:HexRGB(0xcccccc, 1.0f)] forState:UIControlStateDisabled];
        [_sureBtn setBackgroundImage:[UIImage imageWithColor:HexRGB(0x444444, 1.0f)] forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn.titleLabel setFont:FontMedium(14.f)];
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UIButton *)cancleBtn{
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleBtn setImage:[UIImage imageNamed:@"cancle"] forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}

- (UIView *)bgContentView{
    if (!_bgContentView) {
        _bgContentView = [UIView new];
    }
    return _bgContentView;
}

- (UIButton *)checkBox1{
    if (!_checkBox1) {
        _checkBox1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBox1 setImage:[UIImage imageNamed:@"Oval_deselect"] forState:UIControlStateNormal];
        [_checkBox1 setImage:[UIImage imageNamed:@"Oval_select"] forState:UIControlStateSelected];
        [_checkBox1 addTarget:self action:@selector(clickIt1) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkBox1;
}

- (UIButton *)checkBox2{
    if (!_checkBox2) {
        _checkBox2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBox2 setImage:[UIImage imageNamed:@"Oval_deselect"] forState:UIControlStateNormal];
        [_checkBox2 setImage:[UIImage imageNamed:@"Oval_select"] forState:UIControlStateSelected];
        [_checkBox2 addTarget:self action:@selector(clickIt2) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkBox2;
}

- (UILabel *)textLabel1{
    if (!_textLabel1) {
        _textLabel1 = [[UILabel alloc] init];
        _textLabel1.textColor = HexRGB(0x444444, 1.0f);
        _textLabel1.font = [UIFont systemFontOfSize:13.0f];
        _textLabel1.text = @"寄卖到吾G商城";
        _textLabel1.numberOfLines = 0;
    }
    return _textLabel1;
}

- (UILabel *)detailTextLabel1{
    if (!_detailTextLabel1) {
        _detailTextLabel1 = [[UILabel alloc] init];
        _detailTextLabel1.textColor = HexRGB(0x9b9b9b, 1.0f);
        _detailTextLabel1.font = [UIFont systemFontOfSize:10.0f];
        _detailTextLabel1.text = @"将商品寄卖到吾G商城，不选择此项，商品不会出现在吾G商城哦！";
        _detailTextLabel1.numberOfLines = 0;
    }
    return _detailTextLabel1;
}

- (UILabel *)textLabel2{
    if (!_textLabel2) {
        _textLabel2 = [[UILabel alloc] init];
        _textLabel2.textColor = HexRGB(0x444444, 1.0f);
        _textLabel2.font = [UIFont systemFontOfSize:13.0f];
        _textLabel2.text = @"分享给好友购买";
        _textLabel2.numberOfLines = 0;
    }
    return _textLabel2;
}

- (UILabel *)detailTextLabel2{
    if (!_detailTextLabel2) {
        _detailTextLabel2 = [[UILabel alloc] init];
        _detailTextLabel2.textColor = HexRGB(0x9b9b9b, 1.0f);
        _detailTextLabel2.font = [UIFont systemFontOfSize:10.0f];
        _detailTextLabel2.text = @"将购买链接发送给微信好友、微信群或者朋友圈，让好友购买";//@"将购买链接发送给微信好友、微信群，或分享到朋友圈，让好友购买。";
        _detailTextLabel2.numberOfLines = 0;
    }
    return _detailTextLabel2;
}


- (CALayer *)lineLayer{
    if (!_lineLayer) {
        _lineLayer = [CAShapeLayer layer];
        _lineLayer.lineWidth = 0.5;
        _lineLayer.strokeColor = COLOR_HEX(0xE3E3E3).CGColor;
    }
    return _lineLayer;
}

@end
