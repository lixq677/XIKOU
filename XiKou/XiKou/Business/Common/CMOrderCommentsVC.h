//
//  CMOrderCommentsVC.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/10/15.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class CMOrderCommentsVC;
@protocol CMOrderCommentsVCDelegate <NSObject>
@optional
- (void)commentsViewController:(CMOrderCommentsVC *)controller commentText:(NSString *)text;

@end

@interface CMOrderCommentsVC : BaseViewController

- (instancetype)initWithDelegate:(id<CMOrderCommentsVCDelegate>) delegate;

- (void)setText:(NSString *)text;

- (void)canEdit:(BOOL)edit;

@end

NS_ASSUME_NONNULL_END
