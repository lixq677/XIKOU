//
//  CTCommentVC.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/18.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTCommentVC : UIViewController


- (void)show;

- (void)dismiss;

@property (nonatomic,strong,nonnull)NSString *designerId;

@property (nonatomic,strong,nonnull)NSString *workId;

- (void)refreshData;

@end

NS_ASSUME_NONNULL_END
