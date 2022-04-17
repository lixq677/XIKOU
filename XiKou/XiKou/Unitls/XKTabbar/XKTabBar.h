//
//  XKTabBar.h
//  XiKou
//
//  Created by 李笑清 on 2019/6/3.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XKTabBar;
@protocol XKTabBarDelegate <NSObject>
@optional
- (void)tabBarPlusBtnClick:(XKTabBar *)tabBar;
@end


@interface XKTabBar : UITabBar

/** tabbar的代理 */
@property (nonatomic, weak) id<XKTabBarDelegate> tabBarDelegate;

@end

NS_ASSUME_NONNULL_END
