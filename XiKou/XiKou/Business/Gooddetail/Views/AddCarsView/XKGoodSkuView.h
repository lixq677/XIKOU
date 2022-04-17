//
//  XKGoodAddCarView.h
//  XiKou
//
//  Created by L.O.U on 2019/7/9.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKActivityData.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(int,XKSKUFrom) {
    XKSKUFromUnknow     =   0,
    XKSKUFromBargainBuy =   1,
};

@interface XKGoodSkuView : UIView

- (void)showWithData:(ACTGoodDetailModel *)data andComplete:(void(^)(XKGoodSKUModel *skuModel,NSInteger number))complete;

- (void)dismiss;

@property (nonatomic,assign)BOOL swt;//开关

@property (nonatomic,assign)XKSKUFrom from;

@end

NS_ASSUME_NONNULL_END
