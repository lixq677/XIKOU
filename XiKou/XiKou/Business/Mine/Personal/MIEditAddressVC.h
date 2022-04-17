//
//  MIEditAddressVC.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/12.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MIAddressSelectVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIEditAddressVC : BaseViewController

- (instancetype)initWithAddressVoData:(nullable XKAddressVoData *)addressVoData;

@end

NS_ASSUME_NONNULL_END
