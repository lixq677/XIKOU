//
//  XKGradientView.m
//  XiKou
//
//  Created by 李笑清 on 2019/11/25.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKGradientView.h"

@implementation XKGradientView
@synthesize gradientLayer = _gradientLayer;


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.layer insertSublayer:self.gradientLayer atIndex:0];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.gradientLayer.frame = self.bounds;
}

- (CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
    }
    return _gradientLayer;
}

@end
