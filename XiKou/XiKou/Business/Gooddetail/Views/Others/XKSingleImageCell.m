//
//  XKSingleImageCell.m
//  XiKou
//
//  Created by L.O.U on 2019/8/9.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKSingleImageCell.h"

@implementation XKSingleImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.imgView = [UIImageView new];
        self.imgView.layer.masksToBounds = YES;
        self.imgView.layer.cornerRadius  = 2.f;
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        self.imgView.backgroundColor = COLOR_RANDOM;
        [self addSubview:self.imgView];
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.equalTo(self);
            make.bottom.mas_equalTo(1);
        }];
    }
    return self;
}

@end
