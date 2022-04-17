//
//  XKTagsView.h
//  XiKou
//
//  Created by L.O.U on 2019/7/8.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XKTagsView;
@protocol XKTagsViewDelegate <NSObject>
@optional
- (void)clickTagView:(XKTagsView *)tagsView atIndex:(NSUInteger)index;

@end

@interface XKTagsView : UIView

@property (nonatomic, copy) NSArray <NSString *> *titles;

@property (nonatomic, strong)id<XKTagsViewDelegate> delegate;

@end

@interface XKTagVew : UIView

@property (nonatomic, copy) NSString *value;

@property (nonatomic, assign) CGFloat tagWidth;

@end

NS_ASSUME_NONNULL_END
