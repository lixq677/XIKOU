//
//  XKSearchFriendViewController.h
//  XiKou
//
//  Created by majia on 2019/11/4.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^XKSearchFriendBlock)(NSString *phone,NSString *userId);
@interface XKSearchFriendViewController : BaseViewController
@property (nonatomic,copy) XKSearchFriendBlock phoneBlock;
@end

NS_ASSUME_NONNULL_END
