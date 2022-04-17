//
//  XKSuperSheet.h
//  XiKou
//用于继承，不能直接使用
//  Created by 陆陆科技 on 2019/7/6.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKSuperSheet : UIView

@property (nonatomic,assign)float titleHeight;

@property (nonatomic,strong,readonly)UILabel *titleLabel;

@property (nonatomic,strong,readonly)UIView *backgroundView;

- (void)show;

- (void)dismiss;

/*子类必须实现，为虚函数*/
- (CGFloat)sheetWidth;
/*子类必须实现，为虚函数*/
- (CGFloat)sheetHeight;

@end

NS_ASSUME_NONNULL_END
