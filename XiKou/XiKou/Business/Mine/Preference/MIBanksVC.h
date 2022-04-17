//
//  MIBanksVC.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/10/8.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class XKBankListData;
@class MIBanksVC;
@protocol MIBankVCDelegate <NSObject>

- (void)bankVC:(MIBanksVC *)bankVC selectBankListData:(XKBankListData *)bankListData;

@end

@interface MIBanksVC : BaseViewController

- (instancetype)initWithDelegate:(id<MIBankVCDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
