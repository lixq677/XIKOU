//
//  MITaskModel.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/21.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

/*功能列表*/
typedef NS_ENUM(int, MITaskCategory){
    MITaskCategoryShare             =   0,
    MITaskCategoryUserRegister      =   1,
    MITaskCategoryVerify            =   2,
    MITaskCategoryPay               =   3,
    MITaskCategoryComments          =   4,
};


NS_ASSUME_NONNULL_BEGIN

@interface MITaskModel : NSObject

@property (nonatomic,strong) NSString *desc;

@property (nonatomic,strong) NSString *taskValue;

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,assign) BOOL finish;

@property (nonatomic,assign) MITaskCategory category;

@end

NS_ASSUME_NONNULL_END
