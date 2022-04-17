//
//  XKGoodRowTagCell.h
//  XiKou
//
//  Created by L.O.U on 2019/8/5.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKGoodRowTagCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *imgView;

- (void)reloadTimeByCreatTime:(NSString *)creatTime
                  andDuration:(NSNumber *)duration
                      andType:(XKActivityType)type;

@end

NS_ASSUME_NONNULL_END
