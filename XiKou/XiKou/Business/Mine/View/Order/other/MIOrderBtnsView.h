//
//  MIOrderBtnsView.h
//  XiKou
//
//  Created by L.O.U on 2019/7/2.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XKOrderBaseModel,XKOrderDetailModel;

@interface MIOrderBtnsView : UIView

@property (nonatomic, strong) XKOrderBaseModel *model;

- (void)loadOrderTimeWithModel:(XKOrderDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
