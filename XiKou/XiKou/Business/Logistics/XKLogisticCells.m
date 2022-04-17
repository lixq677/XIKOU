//
//  XKLogisticCells.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/9/11.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKLogisticCells.h"

static const int left = 21.0f;

@implementation XKLogisticContentView
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentMode = UIViewContentModeRedraw;
        [self setupUI];
    }
    return self;
}

- (void)setCurrentTextColor:(UIColor *)currentTextColor {
    self.textLabel.textColor = currentTextColor;
}

- (void)setTextColor:(UIColor *)textColor {
    self.textLabel.textColor = textColor;
}

- (void)setCurrented:(BOOL)currented {
    _currented = currented;
    if (currented) {
        self.textLabel.textColor = HexRGB(0x4a4a4a, 1.0f);
    } else {
        self.textLabel.textColor = HexRGB(0xcccccc, 1.0f);
    }
}

- (void)setupUI {
    
    self.backgroundColor = [UIColor whiteColor];
    if (self.currented) {
        self.textLabel.textColor = HexRGB(0x4a4a4a, 1.0f);
    } else {
        self.textLabel.textColor = HexRGB(0xcccccc, 1.0f);
    }
    [self addSubview:self.textLabel];
    [self addSubview:self.detailTextLabel];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(58.0f);
        make.right.mas_equalTo(self).offset(-12.0f);
    }];
    
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.textLabel);
        make.bottom.mas_equalTo(self).offset(-22);
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(4);
    }];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGFloat height = self.bounds.size.height;
    CGFloat cicleWith = self.currented?14:6;
    //    CGFloat shadowWith = cicleWith/3.0;
    
    if (self.hasUpLine) {
        UIBezierPath *topBezier = [UIBezierPath bezierPath];
        [topBezier moveToPoint:CGPointMake(left, 0)];
        [topBezier addLineToPoint:CGPointMake(left, height/2.0 - cicleWith/2.0 - cicleWith/6.0)];
        
        topBezier.lineWidth = 1.0;
        UIColor *stroke = HexRGB(0xcccccc, 1.0f);
        [stroke set];
        [topBezier stroke];
    }
    
    if (self.currented) {
        UIImage *image = [UIImage imageNamed:@"ic_qianshou"];
        [image drawInRect:CGRectMake(left - cicleWith/2.0, height/2.0 - cicleWith/2.0, cicleWith, cicleWith)];
//        UIBezierPath *cicle = [UIBezierPath bezierPathWithOvalInRect:];
//        
//        cicle.lineWidth = cicleWith/3.0;
//        UIColor *cColor =HexRGB(0xff2233, 1.0f);
//        [cColor set];
//        [cicle fill];
//        
//        UIColor *shadowColor = HexRGB(0xff2233, 1.0f);
//        [shadowColor set];
//        
//        
//        [cicle stroke];
    } else {
        
        UIBezierPath *cicle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(left-cicleWith/2.0, height/2.0 - cicleWith/2.0, cicleWith, cicleWith)];
        UIColor *cColor = HexRGB(0xcccccc, 1.0f);
        [cColor set];
        [cicle fill];
        [cicle stroke];
    }
    
    if (self.hasDownLine) {
        UIBezierPath *downBezier = [UIBezierPath bezierPath];
        [downBezier moveToPoint:CGPointMake(21.0f, height/2.0 + cicleWith/2.0 + cicleWith/6.0)];
        [downBezier addLineToPoint:CGPointMake(left, height)];
        
        downBezier.lineWidth = 1.0;
        UIColor *stroke = HexRGB(0xcccccc, 1.0f);
        [stroke set];
        [downBezier stroke];
    }
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.numberOfLines = 0;
        _textLabel.font = [UIFont systemFontOfSize:12.0f];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.numberOfLines = 0;
        _detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        _detailTextLabel.textColor = HexRGB(0xcccccc, 1.0f);
    }
    return _detailTextLabel;
}


@end

@interface XKLogisticCell ()

@property (strong, nonatomic)XKLogisticContentView *customView;

@end

@implementation XKLogisticCell
@dynamic textLabel;
@dynamic detailTextLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.customView.backgroundColor = HexRGB(0xffffff, 1.0f);
    }
    
    return self;
}


- (void)setHasUpLine:(BOOL)hasUpLine {
    self.customView.hasUpLine = hasUpLine;
}

- (void)setHasDownLine:(BOOL)hasDownLine {
    self.customView.hasDownLine = hasDownLine;
}

- (void)setCurrented:(BOOL)currented {
    self.customView.currented = currented;
}

- (UILabel *)textLabel{
    return [self.customView textLabel];
}

- (UILabel *)detailTextLabel{
    return [self.customView detailTextLabel];
}

- (void)setupUI {
    
    [self.contentView addSubview:self.customView];
    
    self.customView.currented = NO;
    self.customView.hasUpLine = YES;
    self.customView.hasDownLine = YES;
    [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(0.0f);
        make.bottom.mas_equalTo(0.0f);
    }];
}

- (XKLogisticContentView *)customView{
    if (!_customView) {
        _customView = [[XKLogisticContentView alloc] init];
    }
    return _customView;
}

@end

@interface XKLogisticConsigneeCell ()

@property (nonatomic,strong,readonly)UIView *contentV;

@end

@implementation XKLogisticConsigneeCell
@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize contentV = _contentV;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentV addSubview:self.imageView];
        [self.contentV addSubview:self.textLabel];
        [self.contentV addSubview:self.detailTextLabel];
        [self.contentView addSubview:self.contentV];
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentV.backgroundColor = HexRGB(0xffffff, 1.0f);
        [self layout];
        self.contentV.clipsToBounds = YES;
        self.contentV.layer.cornerRadius = 4.0f;
    }
    return self;
}

- (void)layout{
    [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(10.0f);
        make.bottom.mas_equalTo(0.0f);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.mas_equalTo(20.0f);
        make.width.mas_equalTo(15.0f);
        make.height.mas_equalTo(17.0f);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(10.0f);
        make.top.bottom.equalTo(self.imageView);
        make.right.mas_equalTo(-15.0f);
    }];
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.textLabel);
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(6.0f);
        make.bottom.mas_equalTo(-15.0f);
    }];
}


- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location"]];
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
        _detailTextLabel.textColor = HexRGB(0x999999, 1.0f);
    }
    return _detailTextLabel;
}

- (UIView *)contentV{
    if (!_contentV) {
        _contentV = [UIView new];
    }
    return _contentV;
}

@end

@implementation XKLogisticSectionHeaderView
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize contentV = _contentV;
@synthesize copyBtn = _copyBtn;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.contentV];
        [self.contentV addSubview:self.textLabel];
        [self.contentV addSubview:self.detailTextLabel];
        [self.contentV addSubview:self.copyBtn];
        self.contentV.backgroundColor = HexRGB(0xffffff, 1.0f);
        [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15.0f);
            make.right.mas_equalTo(-15.0f);
            make.top.bottom.mas_equalTo(0);
        }];
        
        [self.copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 20));
            make.centerY.equalTo(self.textLabel);
            make.right.mas_equalTo(-11.0f);
        }];
        
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15.0f);
            make.top.mas_equalTo(21.0f);
        }];
        [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.textLabel.mas_right).offset(21.0f);
            make.centerY.equalTo(self.textLabel);
            make.right.mas_equalTo(-15.0f);
        }];
        [self.textLabel setContentHuggingPriority:UILayoutPriorityRequired  forAxis:UILayoutConstraintAxisHorizontal];
        
    }
    return self;
}

- (void)clipBoardAction{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.detailTextLabel.text;
    XKShowToast(@"复制快递单号成功");
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
        _detailTextLabel.font = [UIFont systemFontOfSize:15.0f];
        _detailTextLabel.textColor = HexRGB(0x444444, 1.0f);
    }
    return _detailTextLabel;
}

- (UIButton *)copyBtn{
    if (!_copyBtn) {
        UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        copyBtn.layer.masksToBounds = YES;
        copyBtn.layer.cornerRadius  = 2.f;
        [copyBtn setBackgroundColor:COLOR_TEXT_BLACK];
        [copyBtn setTitle:@"复制" forState:UIControlStateNormal];
        [copyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [copyBtn addTarget:self action:@selector(clipBoardAction) forControlEvents:UIControlEventTouchUpInside];
        [copyBtn.titleLabel setFont:Font(12.f)];
        _copyBtn = copyBtn;
    }
    return _copyBtn;
}

- (UIView *)contentV{
    if (!_contentV) {
        _contentV = [UIView new];
        _contentV.layer.cornerRadius = 4.0f;
    }
    return _contentV;
}

@end

