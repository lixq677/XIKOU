//
//  XCImageCell.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/4.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XCImageCell.h"
#import "XKUIUnitls.h"

@implementation XCImageCell
@synthesize imageView = _imageView;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode  = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

@end

