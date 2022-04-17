//
//  UITextField+XKUnitls.h
//  XiKou
//
//  Created by 李笑清 on 2019/6/7.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKTextEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (XKUnitls)

/**
 *  @author 李笑清, 16-02-29 11:02:55
 *
 *  @brief 限制输入的最大字数
 */
@property (nonatomic, assign) NSUInteger  xk_maximum;


/**
 监听，设置YES 监听
 */
@property (nonatomic, assign) BOOL xk_monitor;


/**
 设置空格分开
 */
@property (nonatomic, assign) XKTextFormatter xk_textFormatter;

/**
 自定义支持输入的字符
 */
@property (nonatomic, strong) NSString *xk_supportWords;


/**
 支持输入类型
 */
@property (nonatomic, assign) XKTextSupportContent xk_supportContent;

/**
 输入字符后调用
 */
@property (nonatomic,copy)void(^xk_textDidChangeBlock)(NSString *text);

/**
 输入字符后调用
 */
@property (nonatomic,copy)NSString *(^xk_textMapBlock)(NSString *text);

- (void)xk_setText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
