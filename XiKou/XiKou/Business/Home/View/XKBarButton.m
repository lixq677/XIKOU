//
//  XKBarButton.m
//  XiKou
//
//  Created by Tony on 2019/6/21.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKBarButton.h"
#import "XKUIUnitls.h"

@implementation XKBarButton

-(void)layoutSubviews{
    [super layoutSubviews];
    if (!_noImage) {
        self.imageView.frame = CGRectMake(6.f, 0, self.frame.size.width - 12.f, self.frame.size.width - 12.f);
        self.titleLabel.frame = CGRectMake(0.f, self.frame.size.height - 12.f, self.frame.size.width, 12.f);
        self.titleLabel.font = [UIFont systemFontOfSize:9.f];
    }else{
        self.imageView.frame = CGRectZero;
        self.titleLabel.frame = CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height);
        self.titleLabel.font = [UIFont systemFontOfSize:14.f];
    }
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
}

@end
