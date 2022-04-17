//
//  XKEmptyView.h
//  XiKou
//
//  Created by L.O.U on 2019/7/22.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "LYEmptyView.h"
#import "LYEmptyViewHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKEmptyView : LYEmptyView

+(instancetype)goodListNoDataView;

+(instancetype)orderListNoDataView;

+(instancetype)networkErrorViewWithTarget:(id)target andSel:(SEL)sel;

+(instancetype)normalViewNodataWithTarget:(id)target andSel:(SEL)sel;

+ (instancetype)addressListNoDataView;

/*红包明细*/
+ (instancetype)amountListNoDataView;

@end

NS_ASSUME_NONNULL_END
