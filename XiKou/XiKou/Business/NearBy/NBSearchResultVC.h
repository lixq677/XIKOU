//
//  NBSearchResultVC.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/11.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NBSearchResultDelegate <NSObject>

- (void)searchResult:(UIViewController *)controller searchText:(NSString *)text;

@end

@interface NBSearchResultVC : UIViewController <UISearchResultsUpdating,UISearchBarDelegate>

- (instancetype)initWithDelegate:(id<NBSearchResultDelegate>)delegate;

@property (nonatomic,weak) id<NBSearchResultDelegate> delegate;

@property (nonatomic,assign)CGFloat offsetY;

@end

NS_ASSUME_NONNULL_END
