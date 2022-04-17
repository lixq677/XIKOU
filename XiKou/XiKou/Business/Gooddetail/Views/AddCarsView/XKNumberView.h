//
//  XKPhoneNumberView.h
//  XiKou
//
//  Created by L.O.U on 2019/7/9.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKNumberView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

+ (instancetype)numberButtonWithFrame:(CGRect)frame;

/** 加减按钮的Block回调*/
@property (nonatomic, copy) void(^resultBlock)(NSInteger number, BOOL increaseStatus/* 是否为加状态*/);

#pragma mark - 自定义样式属性设置
/** 是否开启抖动动画, default is NO*/
@property (nonatomic, assign ) IBInspectable BOOL shakeAnimation;
/** 为YES时,初始化时减号按钮隐藏(饿了么/百度外卖/美团外卖按钮模式),default is NO*/
@property (nonatomic, assign ) IBInspectable BOOL decreaseHide;
/** 是否可以使用键盘输入,default is YES*/
@property (nonatomic, assign, getter=isEditing) IBInspectable BOOL editing;

/** 设置边框的颜色,如果没有设置颜色,就没有边框 */
@property (nonatomic, strong ) IBInspectable UIColor *borderColor;

/** 输入框中的内容 */
@property (nonatomic, assign ) NSInteger currentNumber;
/** 输入框中的字体大小 */
@property (nonatomic, assign ) IBInspectable CGFloat inputFieldFont;

/** 长按加减的时间间隔,默认0.1s,设置为 CGFLOAT_MAX 则关闭长按加减功能*/
@property (nonatomic, assign ) IBInspectable CGFloat longPressSpaceTime;

/** 加减按钮的字体大小 */
@property (nonatomic, assign ) IBInspectable CGFloat buttonTitleFont;
/** 加按钮背景图片 */
@property (nonatomic, strong ) IBInspectable UIImage *increaseImage;
/** 减按钮背景图片 */
@property (nonatomic, strong ) IBInspectable UIImage *decreaseImage;
/** 加按钮标题 */
@property (nonatomic, copy   ) IBInspectable NSString *increaseTitle;
/** 减按钮标题 */
@property (nonatomic, copy   ) IBInspectable NSString *decreaseTitle;

/** 最小值, default is 1 */
@property (nonatomic, assign ) IBInspectable NSInteger minValue;
/** 最大值 */
@property (nonatomic, assign ) NSInteger maxValue;
@end

NS_ASSUME_NONNULL_END
