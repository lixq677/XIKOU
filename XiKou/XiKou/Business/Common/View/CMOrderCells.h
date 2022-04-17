//
//  CMOrderCells.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/9.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMOrderAddrCell : UITableViewCell

@property (nonatomic,strong,readonly)UILabel *textLabel;

@property (nonatomic,strong,readonly)UILabel *detailTextLabel;

@property (nonatomic,strong,readonly)UIImageView *imageView;

@property (nonatomic,strong,readonly)UILabel *hintLabel;

@property (nonatomic,assign)BOOL hasAddress;

@end

@interface CMOrderGoodCell : UITableViewCell

@property (nonatomic,strong,readonly)UILabel *textLabel;

@property (nonatomic,strong,readonly)UILabel *detailTextLabel;

@property (nonatomic,strong,readonly)UIImageView *imageView;

@property (nonatomic,strong,readonly) UILabel *priceLabel;

@property (nonatomic,strong,readonly) UILabel *countLabel;

@property (nonatomic,strong,readonly) UILabel *discountLabel;

@end


@interface CMOrderDeliveryCell : UITableViewCell

@property (nonatomic,strong,readonly)UILabel *textLabel;

@property (nonatomic,strong,readonly)UILabel *detailTextLabel;

@property (nonatomic,assign)BOOL bottomCell;

@end


/*代付的Cell*/
@interface CMOrderPaidByOtherCell : UITableViewCell

@property (nonatomic,strong)UILabel *textLabel;

@property (nonatomic,strong,readonly)UIImageView *imageView;

@property (nonatomic,assign) BOOL paidSelect;


/// 是否找喜扣好友代付
/// @param friendPay 默认NO
/// @param phone 好友电话号码
- (void)setPayStyle:(BOOL)friendPay friendPhone:(NSString *)phone;

@end

/*商品订单 描述*/
@interface CMOrderDetailCell : UITableViewCell

@property (nonatomic,strong,readonly)UILabel *textLabel;

@property (nonatomic,strong,readonly)UILabel *detailTextLabel;

@end

/*订单付费方式选择cell*/
@interface CMOrderPaymentCell : UITableViewCell

@property (nonatomic,strong,readonly)UIImageView *imageView;

@property (nonatomic,strong,readonly)UILabel *textLabel;

@property (nonatomic,assign) BOOL paidSelect;

@end

NS_ASSUME_NONNULL_END
