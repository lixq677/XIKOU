//
//  MIPaySheet.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/10/21.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKSuperSheet.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIPaySheet : XKSuperSheet

@property (nonatomic,copy)void(^sureBlock)(void);

- (void)setContent:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
