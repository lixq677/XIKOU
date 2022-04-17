//
//  StartupVC.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/9/23.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;

NS_ASSUME_NONNULL_BEGIN

@interface StartupVC : UIViewController

- (instancetype)initWithPath:(NSString *)filePath enterBlock:(void(^)(void))enterBlock configuration:(nullable void (^)(AVPlayerLayer *playerLayer))configurationBlock;

@end

NS_ASSUME_NONNULL_END
