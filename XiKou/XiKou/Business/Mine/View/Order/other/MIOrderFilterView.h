//
//  MIOrderFilterView.h
//  XiKou
//
//  Created by L.O.U on 2019/7/11.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    Unlimited,
    OneMonth,
    ThreeMonth,
} OrderTimeFilter;
@interface MIOrderFilterView : UIView

@property (nonatomic,copy) void(^filterBlock)(OrderTimeFilter filter,NSString *minPrice,NSString *maxprice);

@end

NS_ASSUME_NONNULL_END
