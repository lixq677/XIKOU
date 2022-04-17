//
//  XKPageControl.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/8/16.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKPageControl : UIControl

@property(nonatomic) NSInteger numberOfPages;          // default is 0
@property(nonatomic) NSInteger currentPage;            // default is 0. value pinned to 0..numberOfPages-1

@property(nonatomic) BOOL hidesForSinglePage;          // hide the the indicator if there is only one page. default is NO

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;   // returns minimum size required to display dots for given page count. can be used to size control if page count could change

@property(nullable, nonatomic,strong) UIColor *pageIndicatorTintColor;

@property(nullable, nonatomic,strong) UIColor *currentPageIndicatorTintColor;

@end

NS_ASSUME_NONNULL_END
