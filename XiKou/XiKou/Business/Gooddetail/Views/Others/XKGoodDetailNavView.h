//
//  XKGoodDetailNavView.h
//  XiKou
//
//  Created by L.O.U on 2019/7/7.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    ActionBack,
    ActionCart,
    ActionShare,
} NavActionType;
@interface XKGoodDetailNavView : UIView

@property (nonatomic, strong) UILabel *titlelabel;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, strong) UIButton *carBtn;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) CGFloat currentAlpha;

@property (nonatomic, assign) NSInteger cartNum;

@property (nonatomic, copy) void(^actionBlock)(NavActionType type);

@end

NS_ASSUME_NONNULL_END
