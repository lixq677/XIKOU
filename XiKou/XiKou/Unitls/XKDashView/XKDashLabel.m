//
//  XKDashLabel.m
//  XiKou
//
//  Created by L.O.U on 2019/7/8.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKDashLabel.h"

@implementation XKDashLabel

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //设置虚线颜色
    CGContextSetStrokeColorWithColor(currentContext, COLOR_TEXT_RED.CGColor);
    //设置虚线宽度
    CGContextSetLineWidth(currentContext, 1);
    //设置虚线绘制起点
    CGContextMoveToPoint(currentContext, 0, 0);
    //设置虚线绘制终点
    CGContextAddLineToPoint(currentContext, self.frame.size.width, 0);
    CGContextAddLineToPoint(currentContext, self.frame.size.width, self.frame.size.height);
    CGContextAddLineToPoint(currentContext, 0, self.frame.size.height);
    CGContextAddLineToPoint(currentContext, 0, 1);
    
    //设置虚线排列的宽度间隔:下面的arr中的数字表示先绘制3个点再绘制1个点
    CGFloat arr[] = {1,1};
    //下面最后一个参数“2”代表排列的个数。
    CGContextSetLineDash(currentContext, 0, arr, 2);
    CGContextDrawPath(currentContext, kCGPathStroke);
}


@end
