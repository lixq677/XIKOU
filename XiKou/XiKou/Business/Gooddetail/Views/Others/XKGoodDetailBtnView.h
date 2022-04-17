//
//  XKGoodDetailBtnView.h
//  XiKou
//
//  Created by L.O.U on 2019/7/8.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    ActionHomeBtn,
    ActionServiceBtn,
    ActionBlackBtn,
    ActionBrownBtn,
} DetailActionType;
NS_ASSUME_NONNULL_BEGIN

@interface XKGoodDetailBtnView : UIView

@property (nonatomic, assign) BOOL needBrownBtn;

@property (nonatomic, copy) void(^actionBlock)(DetailActionType type);

- (void)reloadBlackBtnStatus:(void(^)(UIButton *button))block;

- (void)reloadBrownBtnTitle:(void(^)(UIButton *button))block;

@end

NS_ASSUME_NONNULL_END
