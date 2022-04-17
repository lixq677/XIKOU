//
//  XKProgressView.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/24.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKProgressView.h"
#import "XKUIUnitls.h"

@interface XKProgressView ()

@property  (nonatomic,strong)UIView *trackView;

@end

@implementation XKProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.trackView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.trackView.frame = CGRectMake(0, 0, self.progress*self.width, self.height);
    self.layer.cornerRadius = self.height/2.0f;
    self.trackView.layer.cornerRadius = self.height/2.0f;
}

- (UIView *)trackView{
    if (!_trackView) {
        _trackView = [[UIView alloc] init];
    }
    return _trackView;
}

- (void)setProgress:(float)progress{
    if (progress > 1.0f) {
        progress = 1.0f;
    }
    _progress = progress;
    _trackView.width = CGRectGetWidth(self.frame)*progress;
}

- (void)setProgress:(float)progress animate:(BOOL)animate{
    if (animate == NO) {
        [self setProgress:progress];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            [self setProgress:progress];
        }];
    }
}

- (void)setTrackColor:(UIColor *)trackColor{
    _trackColor = trackColor;
    [self.trackView setBackgroundColor:trackColor];
}


@end
