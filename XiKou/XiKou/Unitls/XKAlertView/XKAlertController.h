//
//  XKAlertController.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/12.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKAlertAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKAlertController : UIAlertController

@property (nonatomic,strong)NSAttributedString *attributedTitle;

@property (nonatomic,strong)NSAttributedString *attributedMessage;

@end

NS_ASSUME_NONNULL_END
