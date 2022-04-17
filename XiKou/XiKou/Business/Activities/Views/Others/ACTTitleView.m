//
//  ACTTitleView.m
//  XiKou
//
//  Created by L.O.U on 2019/7/5.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTTitleView.h"
#import "XKUIUnitls.h"
#import "XKCountDownView.h"

@interface ACTTitleView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *indicateView;

@property (nonatomic, strong) XKCountDownView *timeView;

@end

static const CGFloat space = 10.f;
@implementation ACTTitleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        _titleLabel = [UILabel new];
        _titleLabel.font = FontMedium(17.f);
        _titleLabel.textColor = COLOR_TEXT_BLACK;
        [self addSubview:_titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(space);
            make.right.bottom.equalTo(self).offset(-space);
        }];
        
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _titleLabel.text = title;
}

+ (NSString *)identify{
    return NSStringFromClass([self class]);
}

- (void)setNeedIndicate:(BOOL)needIndicate{
    
    if (_needIndicate != needIndicate) {
        [self addSubview:self.indicateView];
        [self.indicateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-space);
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(6);
        }];
    }
}

- (void)setNeedTimer:(BOOL)needTimer{
    if (_needTimer != needTimer) {
        _needTimer = needTimer;
        [self addSubview:self.timeView];
        [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-space);
            make.top.bottom.equalTo(self);
        }];
    }
}

- (void)hideCountTime:(BOOL)hidden{
    self.timeView.hidden = hidden;
}

- (void)setTime:(NSInteger)time{
    _time = time;
    self.timeView.time = time;
}

- (XKCountDownView *)timeView{
    if (!_timeView) {
        _timeView = [[XKCountDownView alloc] init];
    }
    return _timeView;
}

- (UIImageView *)indicateView{
    if (!_indicateView) {
        _indicateView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
        _indicateView.contentMode = UIViewContentModeRight;
    }
    return _indicateView;
}
@end
@interface ACTImageFootView ()
@property (nonatomic, strong) UIImageView *imageView;

@end
@implementation ACTImageFootView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
      
        
    }
    return self;
}
- (void)loadFootImageView:(NSString *)imageUrl {
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(space, space, space/2, space));
    }];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
}
+ (NSString *)identify{
    return NSStringFromClass([self class]);
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.image = [UIImage imageNamed:kPlaceholderImg];
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius  = 7.f;
    }
    return _imageView;
}

@end
