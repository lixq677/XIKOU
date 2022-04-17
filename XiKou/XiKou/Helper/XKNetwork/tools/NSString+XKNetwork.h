//
//  NSString+XKNetowrk.h
//  XiKou
//
//  Created by 李笑清 on 2019/5/28.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (XKNetwork)

- (NSString *)validUrl;

- (BOOL)isValidUrl;

@end

NS_ASSUME_NONNULL_END
