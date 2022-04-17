//
//  XKItemsPopView.h
//  XiKou
//
//  Created by L.O.U on 2019/7/11.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKPopBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKItemsPopView : XKPopBaseView

- (void)showWithTitle:(NSString *)title
             andItems:(NSArray <NSString *>*)items
       andSelectIndex:(NSInteger)selectIndex
          andComplete:(void(^)(NSInteger index))complete;

@end

NS_ASSUME_NONNULL_END
