//
//  CTDesignerModel.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/24.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTDesignerModel : NSObject

@property (nonatomic,strong)UIImage *image;

@property (nonatomic,strong)NSString *name;

@property (nonatomic,strong)NSString *pinyin;

@property (nonatomic,strong)NSString *commentsCount;

@property (nonatomic,strong)NSString *thumbsupCount;

@end

NS_ASSUME_NONNULL_END
