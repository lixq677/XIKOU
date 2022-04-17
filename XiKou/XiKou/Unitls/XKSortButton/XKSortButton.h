//
//  XKSortButton.h
//  XiKou
//
//  Created by L.O.U on 2019/7/7.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKSortButton : UIButton 

@property (nonatomic, copy) NSString *title;
/** 是否是升序 */
@property (nonatomic, assign, readonly, getter=isAscending) BOOL ascending;

@end

NS_ASSUME_NONNULL_END
