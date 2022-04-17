//
//  UIView+XKXib.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/29.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "UIView+XKXib.h"

@implementation UIView (XKXib)
@dynamic cornerRadius;
@dynamic borderColor;
@dynamic borderWidth;

- (void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (CGFloat)cornerRadius{
    return self.layer.cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth{
    return self.layer.borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = [borderColor CGColor];
}

- (UIColor *)borderColor{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

@end
