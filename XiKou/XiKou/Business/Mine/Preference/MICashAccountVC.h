//
//  MICashAccount.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/5.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class MICashAccountVC;
@class XKBankData;
@protocol MICashAccountVCDelegate <NSObject>
@optional;
- (void)cashAccountVC:(MICashAccountVC *)viewController selectBankCard:(XKBankData *)bankData;

@end

@interface MICashAccountVC : BaseViewController

@property (nonatomic,weak)id<MICashAccountVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
