//
//  XKMakePosterVC.h
//  XiKou
//
//  Created by L.O.U on 2019/7/10.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BaseViewController.h"
#import "XKGoodModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKMakePosterVC : BaseViewController

- (instancetype)initWithGoodModel:(XKGoodModel *)model URLString:(NSString *)URLString;

@end

NS_ASSUME_NONNULL_END
