//
//  XKTableView.m
//  XiKou
//
//  Created by 李笑清 on 2019/11/24.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKTableView.h"

@implementation XKTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
