//
//  XKBannerView.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/19.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKBannerData.h"
#import "XKPageControl.h"
NS_ASSUME_NONNULL_BEGIN

@class XKBannerView;
@protocol XKBannerViewDelegate <NSObject>
@optional
- (void)bannerView:(XKBannerView *)bannerView currentPage:(NSInteger)currentPage;

- (void)bannerView:(XKBannerView *)bannerView selectPage:(NSInteger)currentPage;
@end

//IB_DESIGNABLE
@interface XKBannerView : UIView

@property (nonatomic,strong)NSArray *dataSource;

@property (nonatomic,assign)NSInteger currentIndex;

@property (nonatomic,assign,readonly)NSInteger pageCount;

@property (nonatomic,strong,readonly)XKPageControl *pageControl;

@property (nonatomic,assign) BOOL needPageControl;

@property (nonatomic,weak)id<XKBannerViewDelegate> delegate;

- (void)startLoop;

- (void)stopLoop;

- (void)scrollToCurrentIndex:(NSInteger)currentIndex;

@end

NS_ASSUME_NONNULL_END
