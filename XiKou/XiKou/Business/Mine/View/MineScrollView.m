//
//  XKMineScrollView.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/8.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MineScrollView.h"
#import "XKUIUnitls.h"

@interface MineScrollView ()



@end

@implementation MineScrollView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGFloat y = [XKUIUnitls safeTop];
    CGRect invalidArea = CGRectMake(0, 0, CGRectGetWidth(self.bounds), y+199.0f);
    if (CGRectContainsPoint(invalidArea, point)) {
        return NO;
    }else{
        return YES;
    }
}

@end
