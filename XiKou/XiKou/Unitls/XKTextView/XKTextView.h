//
//  XKTextView.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/25.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKTextView : UITextView

@property (nonatomic,strong,readonly)UILabel *placeHolderLabel;

@property (nonatomic,strong)UIView *leftView;

@end

NS_ASSUME_NONNULL_END
