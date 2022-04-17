//
//  XKCardView.h
//  XiKou
//
//  Created by L.O.U on 2019/7/5.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XKCardView;
@protocol XKCardDelegate <NSObject>

- (void)xkCardView:(XKCardView *)view ClickIndex:(NSInteger)index;

- (void)xkCardView:(XKCardView *)view scrollIndex:(NSInteger)index;
@end

@interface XKCardView : UIView

@property (nonatomic, assign) id <XKCardDelegate> delegate;

@property (nonatomic, copy) NSArray <UIImage *>*images;

@property (nonatomic, copy) NSArray <NSString *>*imageUrls;

@property (nonatomic, copy, readonly) NSArray *dataSouce;
@end

NS_ASSUME_NONNULL_END
