//
//  XKOrderManger.h
//  XiKou
//
//  Created by L.O.U on 2019/7/22.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKOrderModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    OActionPay,         // 支付
    OActionCancle,      // 取消
    OActionPayForOther, // 代付
    OActionExpedite,    // 提醒发货
    OActionLogistics,   // 查看物流
    OActionSure,        // 确认收货
    OActionDelete,      // 删除
    OActionExtend,      // 延长收货
    OActionShare,       // 分享
    OActionDeliver,     // 发货
    OActionConsign      // 寄卖
} OrderActionType;
@protocol XKOrderMangerDelegate <NSObject>

@optional
- (void)orderStatusHasUpdate:(NSString *)orderNo andOrderStatus:(XKOrderStatus)orderStaus;

- (void)orderHasDelete:(NSString *)orderNo;
@end

@interface XKOrderManger : NSObject
/**
 *  单例
 */
+ (XKOrderManger *)sharedMange;

- (void)addWeakDelegate:(id<XKOrderMangerDelegate>)delegate;

- (void)removeWeakDelegate:(id<XKOrderMangerDelegate>)delegate;

- (void)orderListButtonClick:(OrderActionType)type andModel:(XKOrderBaseModel *)model;
@end

NS_ASSUME_NONNULL_END
