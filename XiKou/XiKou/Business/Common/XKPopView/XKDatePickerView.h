//
//  XKDatePickerView.h
//  XiKou
//
//  Created by L.O.U on 2019/7/11.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKPopBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKDatePickerView : XKPopBaseView

- (void)showWithTitle:(NSString *)title
        andSelectDate:(NSDate *)scrollToDate
          andComplete:(void(^)(NSDate *date))complete;

@end

@interface XKDatePicker : UIPickerView

@end
NS_ASSUME_NONNULL_END
