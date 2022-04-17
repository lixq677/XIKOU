//
//  MIOrderUserDetailView.h
//  XiKou
//
//  Created by majia on 2019/11/4.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIOrderUserDetailView : UIView
- (void)reloadImageUrl:(NSString *)imageUrl
              type:(BOOL)type
         namePhone:(NSString *)namePhone
            status:(NSString *)status;
@end

NS_ASSUME_NONNULL_END
