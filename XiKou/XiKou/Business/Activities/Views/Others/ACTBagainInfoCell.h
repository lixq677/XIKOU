//
//  ACTBagainInfoCell.h
//  XiKou
//
//  Created by L.O.U on 2019/7/10.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKActivityData.h"
#import "XKBargainInfoModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    ActionShare,
    ActionBragainBuy,
    ActionBuy,
} CellActionType;
@interface ACTBagainInfoCell : UITableViewCell

@property (nonatomic, copy) void(^cellAction)(CellActionType type);

- (void)reloadGoodInfo:(XKGoodSKUModel *)skuModel
andBargainInfo:(XKBargainInfoModel *)infoModel ruleMode:(XKActivityRulerModel *)rulerModel;

@end

NS_ASSUME_NONNULL_END
