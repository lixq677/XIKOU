//
//  XKBaseResponse.m
//  XiKou
//
//  Created by 李笑清 on 2019/5/28.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKBaseResponse.h"

@implementation XKBaseResponse

- (BOOL)isSuccess{
    return self.code != nil && [self.code intValue] == 0;
    
}

- (BOOL)isNotSuccess{
    return ![self isSuccess];
}


@end
