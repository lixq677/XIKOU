//
//  HMSearchResultVC.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/8.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN


@protocol HMSearchResultDelegate <NSObject>

- (void)searchResult:(UIViewController *)controller searchText:(NSString *)text;

@end

@interface HMSearchResultVC : UIViewController <UISearchResultsUpdating,UISearchBarDelegate>

- (instancetype)initWithDelegate:(id<HMSearchResultDelegate>)delegate;

@property (nonatomic,weak) id<HMSearchResultDelegate> delegate;

@property (nonatomic,assign)CGFloat offsetY;

@end

NS_ASSUME_NONNULL_END
