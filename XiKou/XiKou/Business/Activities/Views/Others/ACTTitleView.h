//
//  ACTCoollectionTitleHeadView.h
//  XiKou
//
//  Created by L.O.U on 2019/7/5.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACTTitleView : UICollectionReusableView

@property (nonatomic, assign) BOOL needIndicate;

@property (nonatomic, assign) BOOL needTimer;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger time;

- (void)hideCountTime:(BOOL)hidden;

+ (NSString *)identify;

@end

@interface ACTImageFootView : UICollectionReusableView

- (void)loadFootImageView:(NSString *)imageUrl;
+ (NSString *)identify;
@end
NS_ASSUME_NONNULL_END
