//
//  XKCustomAlertView.h
//  XiKou
//
//  Created by L.O.U on 2019/7/3.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    CanleAndTitle, //default 有取消按钮和提示标题
    CanleNoTitle, // 有取消按钮无提示标题
    NoCancle,// 无取消按钮，有标题
    OnlyContent, //只有内容提示和底部按钮
} AlertType;

typedef NS_ENUM(int, AlertBtnStyle) {
    AlertBtnStyleDefault,
    AlertBtnStyle1,
};


@interface XKCustomAlertView : UIView

- (instancetype)initWithType:(AlertType)type
                    andTitle:(NSString *__nullable)title
                  andContent:(NSString *)content
                 andBtnTitle:(NSString *)btnTitle;

- (instancetype)initWithType:(AlertType)type
                    andTitle:(NSString *)title
         andAttributeContent:(NSAttributedString *)content
                 andBtnTitle:(NSString *)btnTitle;

- (instancetype)initWithType:(AlertType)type
                    andTitle:(NSString *__nullable)title
                  andContent:(NSString *)content
                 andBtnTitle:(NSString *)btnTitle
               otherBtnTitle:(NSString *__nullable)otherBtnTitle;

- (instancetype)initWithType:(AlertType)type
                    andTitle:(NSString *)title
         andAttributeContent:(NSAttributedString *)content
                 andBtnTitle:(NSString *)btnTitle
               otherBtnTitle:(NSString *__nullable)otherBtnTitle;


- (void)show;
@property (nonatomic, copy) void(^sureBlock)(void);
@property (nonatomic, copy) void(^otherBlock)(void);

@property (nonatomic,assign)AlertBtnStyle btnStyle;

@property (nonatomic, strong,readonly) UILabel *contentLabel;

@end

NS_ASSUME_NONNULL_END
