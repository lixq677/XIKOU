//
//  XKGoodInfoZeroBuyCell.m
//  XiKou
//
//  Created by L.O.U on 2019/8/5.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKZeroBuyGoodInfoCell.h"
#import "XKGCDTimer.h"

@interface XKZeroBuyGoodInfoCell ()

@property (nonatomic, strong) UIButton *countDownBtn;       //倒计时

@end

@implementation XKZeroBuyGoodInfoCell
{
    NSString *_timer;
    NSInteger _time;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView xk_addSubviews:@[self.countDownBtn]];
        self.joinVipView.hidden = YES;
        [self.countDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.bottom.equalTo(self.joinVipView);
        }];
        
        [self.countDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
    }
    return self;
}

#pragma mark -------- 生命周期

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.countDownBtn layoutIfNeeded];
    self.gradientLayer.frame = self.countDownBtn.bounds;
    [self.countDownBtn.layer insertSublayer:self.gradientLayer atIndex:0];
    
    [self.tagView setNeedsDisplay];
}

- (void)setDetailModel:(ACTGoodDetailModel *)detailModel{
    [super setDetailModel:detailModel];
    
    XKGoodModel *gModel = self.detailModel.activityCommodityAndSkuModel;
    self.nameLabel.text = gModel.commodityName;
    [self.nameLabel setLineSpace:4.f];
    
    self.originalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[gModel.salePrice doubleValue]/100] ;
    [self.originalPriceLabel addMiddleLineWithSubString:self.originalPriceLabel.text];
    
    self.priceLabel.text = [NSString stringWithFormat:@"当前竞拍价 ¥%.2f",[gModel.adctionModel.currentPrice doubleValue]/100];
    [self.priceLabel setAttributedStringWithSubString:@"当前竞拍价" font:Font(12.f)];
    if (gModel.adctionModel.status == Auction_Begin) {
        _time = [gModel.adctionModel.remainingTime integerValue];
        [self startTimer];
    }else{
        [_countDownBtn setTitle:gModel.adctionModel.statusTitle forState:UIControlStateNormal];
    }
    
    NSMutableArray *tags = @[@"承诺正品",@"发货极快"].mutableCopy;
    if (!detailModel.baseRuleModel.postage || [detailModel.baseRuleModel.postage doubleValue] == 0) {
        [tags insertObject:@"全国包邮" atIndex:0];
    }else{
        [tags insertObject:[NSString stringWithFormat:@"邮费 %.2f元",[detailModel.baseRuleModel.postage doubleValue]/100] atIndex:0];
    }
    self.tagView.titles = tags;
    
    [self.priceLabel handleRedPrice:FontSemibold(17.f)];

}

- (void)startTimer {
    if (!_timer) {
        @weakify(self);
        _timer = @"抢拍倒计时";
        [self reloadTime];
        [[XKGCDTimer sharedInstance]scheduleGCDTimerWithName:_timer interval:1 queue:nil repeats:YES option:MergePreviousTimerAction action:^{
            @strongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadTime];
            });
        }];
    }
}

- (void)reloadTime{
    _time--;
    if (_time <= 0) {
        //关闭定时器
        [_countDownBtn setTitle:@"离竞拍结束时间：0s" forState:UIControlStateNormal];
        [[XKGCDTimer sharedInstance]cancelTimerWithName:_timer];
    }else {
        //处倒计时
        NSInteger second = _time % 60;
        NSInteger minute = (_time % 3600)/60;
        NSInteger hour = _time / 3600;
        [_countDownBtn setTitle:[NSString stringWithFormat:@"离竞拍结束时间: %ld时%02ld分%02ld秒",hour,minute,second] forState:UIControlStateNormal];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview && _timer) {
        [[XKGCDTimer sharedInstance]cancelTimerWithName:_timer];
    }
}

- (UIButton *)countDownBtn{
    if (!_countDownBtn) {
        _countDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_countDownBtn setImage:[UIImage imageNamed:@"wait"] forState:UIControlStateNormal];
        [_countDownBtn setTitle:@"" forState:UIControlStateNormal];
        [_countDownBtn setTitleColor:COLOR_TEXT_BROWN forState:UIControlStateNormal];
        [_countDownBtn.titleLabel setFont:Font(12.f)];
        [_countDownBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_countDownBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        [_countDownBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    }
    return _countDownBtn;
}

@end
