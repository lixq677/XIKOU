//
//  ACTHomePageBannerCell.m
//  XiKou
//
//  Created by L.O.U on 2019/7/26.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTBannerCollectionCell.h"

@interface ACTBannerCollectionCell ()

@end

@implementation ACTBannerCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.bannerView];
        [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (XKBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[XKBannerView alloc]init];
    }
    return _bannerView;
}
@end
