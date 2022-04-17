//
//  MIOrderPayAnotherFooter.h
//  XiKou
//
//  Created by L.O.U on 2019/8/30.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKCountDownView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIOrderPayAnotherFooter : UITableViewHeaderFooterView

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic, strong) XKCountDownView *countDownView;

@property (nonatomic, strong) UIView *bgView;

- (void)reloadTime:(NSString *)creattime anDuration:(NSInteger)duration;

+ (NSString *)identify;
@end

NS_ASSUME_NONNULL_END
