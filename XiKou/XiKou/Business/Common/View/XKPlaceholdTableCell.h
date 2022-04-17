//
//  XKPlaceholdTableCell.h
//  XiKou
//
//  Created by L.O.U on 2019/8/19.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKPlaceholdBaseCell : UITableViewCell

+ (CGFloat)cellHeight;

@end

@interface XKPlaceholdGoodCell : XKPlaceholdBaseCell

@end

@interface XKPlaceholdTextCell : XKPlaceholdBaseCell


@end

@interface XKPlaceholdGoodInfoCell : XKPlaceholdBaseCell


@end


NS_ASSUME_NONNULL_END
