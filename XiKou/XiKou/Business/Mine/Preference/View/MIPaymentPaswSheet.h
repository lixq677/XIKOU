//
//  MIPaymentPaswSheet.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/6.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKSuperSheet.h"

NS_ASSUME_NONNULL_BEGIN

@class MIPaymentPaswSheet;
@protocol MIPaymentPaswSheetDelegate <NSObject>

- (void)resetPassword:(MIPaymentPaswSheet *)sheet;

- (void)paymentPaswSheet:(MIPaymentPaswSheet *)sheet inputPassword:(NSString *)password;

@end

@interface MIPaymentPaswSheet : XKSuperSheet

- (instancetype)initWithDelegate:(id<MIPaymentPaswSheetDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
