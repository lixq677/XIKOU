//
//  XKMineContentView.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/8.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIFunctionDesc.h"

NS_ASSUME_NONNULL_BEGIN

@class MineContentView;
@protocol MineContentViewDelegate <NSObject>

- (void)contentView:(MineContentView *)view functionCategory:(MIFunctionCategory)gategory;
@end

@interface MineContentView : UIView

@property (nonatomic,strong)NSArray<MIFunctionDesc *> *buyerFuns;

@property (nonatomic,strong)NSArray<MIFunctionDesc *> *sellerFuns;

@property (nonatomic,strong)NSArray<MIFunctionDesc *> *publicFuns;

@property (nonatomic,weak)id<MineContentViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
