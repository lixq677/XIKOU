//
//  XKSearchResultView.h
//  XiKou
//
//  Created by majia on 2019/11/4.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKSearchResultView : UIView
- (void)reloadSearchResult:(NSString *)phone userId:(NSString *)userId nickName:(NSString *)nickname;
@property (nonatomic,copy) void(^tapActionBlock)(NSString *phone,NSString *nickName,NSString *userId);
@end

NS_ASSUME_NONNULL_END
