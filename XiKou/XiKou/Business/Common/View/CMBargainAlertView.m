//
//  CMBargainAlertView.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/10/29.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "CMBargainAlertView.h"

@interface CMBargainAlertViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic,strong)UILabel *textLabel;

@property (nonatomic,strong)UILabel *detailTextLabel;

@end

@implementation CMBargainAlertViewCell
@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.detailTextLabel];
        [self autoLayout];
    }
    return self;
}

- (void)autoLayout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(35.0f);
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(15.0f);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(self.imageView.mas_right).offset(10.0f);
    }];
    
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(-15.0f);
    }];
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = 17.5f;
    }
    return _imageView;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.numberOfLines = 0;
        _textLabel.font = [UIFont systemFontOfSize:15.0f];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.numberOfLines = 0;
        _detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        _detailTextLabel.textColor = HexRGB(0xF94119, 1.0f);
    }
    return _detailTextLabel;
}


@end

@interface CMBargainAlertView () <UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) UIButton *cancleBtn;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *bgContentView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) CAShapeLayer *lineLayer;

@end

@implementation CMBargainAlertView

- (instancetype)init{
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)]) {
        self.backgroundColor = COLOR_RGB(0, 0, 0, 0.6);
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.contentLabel setText:@"现金红包已发放至帮您砍价的好友账户"];
        [self.titleLabel setText:@"恭喜您完成砍价购买"];
        [self creatSubviews];
        [self.tableView registerClass:[CMBargainAlertViewCell class] forCellReuseIdentifier:@"CMBargainAlertViewCell"];
    }
    return self;
}

- (void)creatSubviews{
    [self addSubview:self.bgContentView];
    [self.bgContentView addSubview:self.contentView];
    [self.contentView xk_addSubviews:@[self.contentLabel,self.sureBtn]];
    [self.bgContentView addSubview:self.cancleBtn];
    [self.contentView addSubview:self.titleLabel];
    [self.bgContentView.layer addSublayer:self.lineLayer];
    [self.contentView addSubview:self.tableView];
   
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame)-106;
    
    self.cancleBtn.frame = CGRectMake(width-32, 0, 32, 32);
    self.titleLabel.frame = CGRectMake(15, 0, width-30.0f, 46);
    
    self.contentLabel.frame = CGRectMake(0.f, self.titleLabel.bottom+15, width, 20);
    self.tableView.frame = CGRectMake(0, self.contentLabel.bottom+15, width, 240);
    self.sureBtn.frame = CGRectMake(self.contentLabel.x+33, self.tableView.bottom+18, self.contentLabel.width-66, 42);
    self.contentView.frame = CGRectMake(0, self.cancleBtn.bottom+19, width, self.sureBtn.bottom+25.0f - self.titleLabel.y);
    self.bgContentView.frame = CGRectMake(53.0f, self.middleY-40-0.5*self.contentView.bottom, width, self.contentView.bottom);
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(self.cancleBtn.centerX, self.cancleBtn.bottom)];
    [linePath addLineToPoint:CGPointMake(self.cancleBtn.centerX, self.contentView.top)];
    self.lineLayer.path = linePath.CGPath;
   
}

#pragma mark - Action
- (void)sureAction{
    [self dismiss];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.scheduleDatas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CMBargainAlertViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CMBargainAlertViewCell" forIndexPath:indexPath];
    XKBargainScheduleData *data = [self.scheduleDatas objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:data.assistUserHeadImageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    cell.textLabel.text = data.assistUserName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f元",data.bargainPrice.doubleValue/100.00f];
    return cell;
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
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = HexRGB(0x444444, 1.0f);
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

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.rowHeight = 60;
        _tableView.estimatedRowHeight = 60;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
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
