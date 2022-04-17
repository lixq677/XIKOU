//
//  ACTBargainDetailVC.h
//  XiKou
//
//  Created by L.O.U on 2019/7/10.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class ACTGoodDetailModel;
@class XKGoodSKUModel;
@interface ACTBargainDetailVC : BaseViewController

@property (nonatomic, strong) ACTGoodDetailModel *detailModel;

@property (nonatomic, strong) XKGoodSKUModel  *skuModel;
@end

NS_ASSUME_NONNULL_END
