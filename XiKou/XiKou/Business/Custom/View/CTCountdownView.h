//
//  CTCountdownView.h
//  XiKou
//
//  Created by L.O.U on 2019/7/15.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTCountdownView : UIView
    
@property (nonatomic,strong,readonly)UILabel *hintLabel;

@property (nonatomic,strong,readonly)UILabel *hourLabel;

@property (nonatomic,strong,readonly)UILabel *minuteLabel;

@property (nonatomic,strong,readonly)UILabel *secondLabel;

@property (nonatomic,strong,readonly)UILabel *colonLabel1;

@property (nonatomic,strong,readonly)UILabel *colonLabel2;

@property (nonatomic,strong)dispatch_source_t timer;

@end

NS_ASSUME_NONNULL_END
