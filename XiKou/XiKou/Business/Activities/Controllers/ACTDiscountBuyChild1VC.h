//
//  ACTDiscountBuyChild1VC.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/10/26.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XKGoodListModel;

@interface ACTDiscountBuyChild1VC : UIViewController

@property (nonatomic,strong)NSString *moduleId;

@property (nonatomic, strong,readonly) NSMutableArray<XKGoodListModel *> *result;

@end

NS_ASSUME_NONNULL_END
