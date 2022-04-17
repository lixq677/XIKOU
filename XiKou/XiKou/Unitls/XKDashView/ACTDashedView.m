//
//  ACTDashedView.m
//  XiKou
//
//  Created by L.O.U on 2019/7/4.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTDashedView.h"
#import "XKUIUnitls.h"
#import "NSString+Common.h"
static CGFloat const dashHeight = 1;

@implementation ACTDashedView
{
    UILabel *_tipLabel;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _tipLabel = [UILabel new];
        _tipLabel.font = Font(9.);
        _tipLabel.textColor = COLOR_TEXT_RED;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = @"券";
        _tipLabel.backgroundColor = [UIColor clearColor];
        
        _valueLabel = [UILabel new];
        _valueLabel.font = Font(9.);
        _valueLabel.textColor = COLOR_TEXT_RED;
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        _valueLabel.backgroundColor = COLOR_HEX(0xFFECE8);
        [self xk_addSubviews:@[_tipLabel,_valueLabel]];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(dashHeight);
            make.bottom.equalTo(self).offset(-dashHeight);
            make.width.mas_equalTo(20);
        }];
        [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(dashHeight);
            make.bottom.right.equalTo(self).offset(-dashHeight);
            make.left.equalTo(_tipLabel.mas_right).offset(dashHeight);
        }];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //设置虚线颜色
    CGContextSetStrokeColorWithColor(currentContext, COLOR_TEXT_RED.CGColor);
    //设置虚线宽度
    CGContextSetLineWidth(currentContext, dashHeight);
    //设置虚线绘制起点
    CGContextMoveToPoint(currentContext, dashHeight, dashHeight);
    //设置虚线绘制终点
    CGContextAddLineToPoint(currentContext, self.frame.size.width-dashHeight, dashHeight);
    CGContextAddLineToPoint(currentContext, self.frame.size.width-dashHeight, self.frame.size.height-dashHeight);
    CGContextAddLineToPoint(currentContext, dashHeight, self.frame.size.height-dashHeight);
    CGContextAddLineToPoint(currentContext, dashHeight, dashHeight);
    CGContextMoveToPoint(currentContext, _tipLabel.right + dashHeight, dashHeight);
    CGContextAddLineToPoint(currentContext, _tipLabel.right + dashHeight, _tipLabel.bottom);
    
    //设置虚线排列的宽度间隔:下面的arr中的数字表示先绘制3个点再绘制1个点
    CGFloat arr[] = {1,1};
    //下面最后一个参数“2”代表排列的个数。
    CGContextSetLineDash(currentContext, 0, arr, 2);
    CGContextDrawPath(currentContext, kCGPathStroke);
}

- (void)setValue:(CGFloat)value{
    _valueLabel.text = [NSString stringWithFormat:@"%.2f    ",value];
    CGSize valueSize = [_valueLabel.text sizeWithFont:Font(12)];
    CGRect valueFrame = _valueLabel.frame;
    _valueLabel.frame = CGRectMake(valueFrame.origin.x, valueFrame.origin.y, valueSize.width, valueSize.height);
    [self setNeedsDisplay];
}
@end
