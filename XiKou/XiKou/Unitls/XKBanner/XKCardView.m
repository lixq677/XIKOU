//
//  XKCardView.m
//  XiKou
//
//  Created by L.O.U on 2019/7/5.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKCardView.h"
#import "XKUIUnitls.h"

@interface XKCardView ()

@property (nonatomic, strong) UIImageView *firstImageView;

@property (nonatomic, strong) UIImageView *secondImageView;

@property (nonatomic, assign) NSInteger currentIndex;

@end

#define xOffsetPadding 0
#define yOffset 0
#define internalViewHeight 225
#define kStartRotation          60
#define kHorizontalEdgeOffset   190
#define kRotationFactor         0.25f

@implementation XKCardView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.masksToBounds  = YES;
        self.layer.cornerRadius   = 2.f;
        self.currentIndex   = 0;
        self.firstImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.firstImageView.backgroundColor   = [UIColor whiteColor];
        self.firstImageView.layer.shadowColor = COLOR_VIEW_GRAY.CGColor;
        self.firstImageView.layer.shadowOffset = CGSizeMake(-0.5,-2);
        self.firstImageView.layer.shadowOpacity = 1;
        self.firstImageView.layer.shadowRadius = 2.5;
        self.firstImageView.image = [UIImage imageNamed:kPlaceholderImg];
        self.firstImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addTapAction:self.firstImageView action:@selector(gesAction:)];
        
        self.secondImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.secondImageView.backgroundColor = [UIColor whiteColor];
        self.secondImageView.layer.shadowOffset = CGSizeMake(-0.5,-2);
        self.secondImageView.layer.shadowColor  = COLOR_VIEW_GRAY.CGColor;
        self.secondImageView.layer.shadowOpacity = 1;
        self.secondImageView.layer.shadowRadius = 2.5;
        self.secondImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addTapAction:self.secondImageView action:@selector(gesAction:)];
        
        [self addSubview:self.secondImageView];
        [self addSubview:self.firstImageView];
        [self scale:self.secondImageView];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)gesAction:(UIGestureRecognizer *)ges{
    if ([ges isKindOfClass:[UITapGestureRecognizer class]]) {
        if (_delegate && [_delegate respondsToSelector:@selector(xkCardView:ClickIndex:)]) {
            [_delegate xkCardView:self ClickIndex:self.currentIndex];
        }
    }
    if ([ges isKindOfClass:[UISwipeGestureRecognizer class]]) {
        [self handleSwipeFrom:(UISwipeGestureRecognizer *)ges];
    }
}

- (void)scale:(UIImageView *)view{
    if (_delegate && [_delegate respondsToSelector:@selector(xkCardView:scrollIndex:)]) {
        [_delegate xkCardView:self scrollIndex:self.currentIndex];
    }
    view.width  = self.width * 0.9;
    view.height = self.height * 0.9;
    view.center = self.center;
    [self insertSubview:view atIndex:0];

    if (_currentIndex < _dataSouce.count-1) {
        if ([[_dataSouce objectAtIndex:0]isKindOfClass:[NSString class]]) {
            [view sd_setImageWithURL:[NSURL URLWithString:_dataSouce[_currentIndex+1]] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
        }else{
            view.image = self.dataSouce[_currentIndex+1];
        }
    }else{
        if ([[_dataSouce objectAtIndex:0]isKindOfClass:[NSString class]]) {
            [view sd_setImageWithURL:[NSURL URLWithString:_dataSouce[0]] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
        }else{
            view.image = self.dataSouce[0];
        }
    }
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    UIImageView *currentView= self.subviews.lastObject;
    UIImageView *nextView= self.subviews.firstObject;
    [UIView animateWithDuration:0.4f animations:^{

        if (recognizer.direction==UISwipeGestureRecognizerDirectionLeft)
        {
            CGPoint demoShift = CGPointMake(-kHorizontalEdgeOffset,currentView.center.y);
            currentView.center = demoShift;
            currentView.transform = CGAffineTransformMakeRotation(-kStartRotation * M_PI * kRotationFactor/180);
        }
        else if (recognizer.direction==UISwipeGestureRecognizerDirectionRight)
        {
            CGPoint demoShift = CGPointMake(2*kScreenWidth-kHorizontalEdgeOffset, currentView.center.y);
            currentView.center = demoShift;
            currentView.transform = CGAffineTransformMakeRotation(kStartRotation * M_PI * kRotationFactor/180);
        }
        nextView.width  = self.width;
        nextView.height = self.height;
        nextView.center = self.center;
        
    } completion: ^(BOOL finished) {
        
        currentView.transform = CGAffineTransformIdentity;
        if (recognizer.direction==UISwipeGestureRecognizerDirectionLeft)
        {
            if (self.currentIndex == self.dataSouce.count - 1) {
                self.currentIndex = 0;
            }else{
                self.currentIndex ++ ;
            }
        }
        else if (recognizer.direction==UISwipeGestureRecognizerDirectionRight)
        {
            if (self.currentIndex == 0) {
                self.currentIndex = self.dataSouce.count - 1;
            }else{
                self.currentIndex -- ;
            }
        }
        [self scale:currentView];
    }];
}

- (void)setImages:(NSArray <UIImage *>*)images{
    self.dataSouce = images;
}

- (void)setImageUrls:(NSArray <NSString *>*)imageUrls{
    self.dataSouce = imageUrls.copy;
}

- (void)setDataSouce:(NSArray*)dataSouce{
    _dataSouce = dataSouce;
    UIImageView *lastView = self.subviews.lastObject;
    UIImageView *firstView = self.subviews.firstObject;
    if (_dataSouce.count >= 1) {
        self.userInteractionEnabled = YES;
        if ([[_dataSouce objectAtIndex:0]isKindOfClass:[NSString class]]) {
            [lastView sd_setImageWithURL:[NSURL URLWithString:_dataSouce[0]] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
            if (dataSouce.count >=2) {
                [firstView sd_setImageWithURL:[NSURL URLWithString:_dataSouce[1]] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
            }
        }else{
            lastView.image = _dataSouce[0];
            if (dataSouce.count >=2) {
                firstView.image = _dataSouce[1];
            }
        }
        
    }else{
        self.userInteractionEnabled = NO;
    }
}
-(void)addTapAction:(UIView *)view action:(SEL)action{
    
    view.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:action];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [view addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:action];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [view addGestureRecognizer:recognizer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:action];
    [view addGestureRecognizer:tap];
    
}

@end
