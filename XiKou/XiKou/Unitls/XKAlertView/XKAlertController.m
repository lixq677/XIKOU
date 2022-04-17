//
//  XKAlertController.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/12.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKAlertController.h"

@interface XKAlertController ()

@end

@implementation XKAlertController
@dynamic attributedTitle;
@dynamic attributedMessage;

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle{
    [super setValue:attributedTitle forKey:@"attributedTitle"];
}

- (NSAttributedString *)attributedTitle{
    return (NSAttributedString *)[super valueForKey:@"attributedTitle"];
}

- (void)setAttributedMessage:(NSAttributedString *)attributedMessage{
    [super setValue:attributedMessage forKey:@"attributedMessage"];
}

- (NSAttributedString *)attributedMessage{
    return (NSAttributedString *)[super valueForKey:@"attributedMessage"];
}



@end
