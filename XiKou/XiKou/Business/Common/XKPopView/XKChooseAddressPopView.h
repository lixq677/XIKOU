//
//  XKChooseAddressPopView.h
//  XiKou
//
//  Created by L.O.U on 2019/7/20.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKPopBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@class XKAddressVoData;
@interface XKChooseAddressPopView : XKPopBaseView

- (void)showWithTitle:(NSString *)title
       chooseComplete:(void(^)(XKAddressVoData *data))complete
             addBlock:(void(^)(void))addBlock;

@end

NS_ASSUME_NONNULL_END
