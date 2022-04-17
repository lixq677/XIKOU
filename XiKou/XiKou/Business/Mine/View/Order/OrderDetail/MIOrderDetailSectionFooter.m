//
//  MIOrderDetailSectionFooter.m
//  XiKou
//
//  Created by L.O.U on 2019/7/25.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIOrderDetailSectionFooter.h"
#import "XKOrderModel.h"

@interface MIOrderDetailSectionFooter ()

@property (nonatomic, strong) UIView *infoView;

@property (nonatomic, strong) UIView *payInfoView;

@property (nonatomic, strong) UIButton *remarkView;

@end

@implementation MIOrderDetailSectionFooter

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self creatSubViews];
    }
    return self;
}

- (void)setModel:(XKOrderDetailModel *)model{
    _model = model;
    
    
    NSMutableArray *payInfos = [NSMutableArray array];
    if (model.cutPrice && model.type == OTBargain) {
        [payInfos addObject:@{@"砍后价":[NSString stringWithFormat:@"¥%.2f",[model.cutPrice doubleValue]/100]}];
    }
    if (model.commodityAuctionPrice && model.type == OTZeroBuy) {
        [payInfos addObject:@{@"拍卖价":[NSString stringWithFormat:@"¥%.2f",[model.commodityAuctionPrice doubleValue]/100]}];
    }
    [payInfos addObject:@{@"邮费":[NSString stringWithFormat:@"¥%.2f",[model.postage doubleValue]/100]}];
    [payInfos addObject:@{@"实付款":[NSString stringWithFormat:@"¥%.2f",[model.payAmount doubleValue]/100]}];

    [self creatPayInfoView:payInfos];
    [self createRemarkView];
    NSMutableArray *infos = [NSMutableArray array];
    if (model.type == OTDiscount && model.tradeNo) {
        [infos addObject:[NSString stringWithFormat:@"总订单编号: %@",_model.tradeNo]];
    }
    
    [infos addObject:[NSString stringWithFormat:@"订单编号: %@",model.orderNo]];
    
    if (model.externalPlatformNo) {
        [infos addObject:[NSString stringWithFormat:@"交易流水号: %@",model.externalPlatformNo]];
    }
    
    [infos addObject:[NSString stringWithFormat:@"创建时间: %@",model.orderTime]];
    
    if (model.payTime) {
        [infos addObject:[NSString stringWithFormat:@"付款时间: %@",model.payTime]];
    }
    
    if (model.shipTime) {
        [infos addObject:[NSString stringWithFormat:@"发货时间: %@",model.shipTime]];
    }
    
    if (model.confirmReceiptTime) {
        [infos addObject:[NSString stringWithFormat:@"成交时间: %@",model.confirmReceiptTime]];
    }
    if (model.state == OSCancle && model.type == OTConsigned) {
        [infos addObject:[NSString stringWithFormat:@"取消时间: %@",model.lastUpdateTime]];
    }
    [self creatInfoViews:infos];
}

- (void)copyClick{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.model.orderNo;
    XKShowToast(@"复制成功");
}

- (void)creatSubViews{
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"订单信息";
    titleLabel.font = FontMedium(15.f);
    
    UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    copyBtn.layer.borderColor = COLOR_LINE_GRAY.CGColor;
    copyBtn.layer.borderWidth = 0.5;
    copyBtn.layer.masksToBounds = YES;
    copyBtn.layer.cornerRadius  = 2.f;
    [copyBtn setTitle:@"复制" forState:UIControlStateNormal];
    [copyBtn setTitleColor:COLOR_TEXT_GRAY forState:UIControlStateNormal];
    [copyBtn.titleLabel setFont:Font(12.f)];
    [copyBtn addTarget:self action:@selector(copyClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *middleLine1 = [UIView new];
    middleLine1.backgroundColor = COLOR_VIEW_GRAY;
    
    UIView *middleLine2 = [UIView new];
    middleLine2.backgroundColor = COLOR_VIEW_GRAY;
    
    [self xk_addSubviews:@[self.payInfoView,middleLine1,self.remarkView,middleLine2, titleLabel,copyBtn,self.infoView]];
    [self.payInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(2);
    }];
    [middleLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(9);
        make.top.equalTo(self.payInfoView.mas_bottom).offset(22);
    }];
    
    [self.remarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.mas_equalTo(middleLine1.mas_bottom);
        make.height.mas_equalTo(45.0f);
    }];
    
    [middleLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(9);
        make.top.equalTo(self.remarkView.mas_bottom);
    }];
    
    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(middleLine2.mas_bottom).offset(20);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(24);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(copyBtn.mas_left).offset(-15);
        make.left.equalTo(self).offset(20);
        make.top.bottom.equalTo(copyBtn);
    }];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.right.equalTo(copyBtn);
        make.top.equalTo(copyBtn.mas_bottom).offset(6);
        make.bottom.equalTo(self).offset(-22);
    }];
}

- (void)creatInfoViews:(NSArray *)array{
    [self.infoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *lastView;
    for (NSString *string in array) {
        UILabel *label = [[UILabel alloc]init];
        label.font = Font(12.f);
        label.textColor = COLOR_TEXT_GRAY;
        label.text = string;
        [_infoView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.infoView);
            make.height.mas_equalTo(25);
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom);
            }else{
                make.top.equalTo(self.infoView);
            }
        }];
        lastView = label;
    }
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView);
    }];
}

- (void)createRemarkView{
    [self.remarkView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel *rightLabel = [[UILabel alloc]init];
    rightLabel.font = Font(13.f);
    rightLabel.textColor = COLOR_TEXT_GRAY;
    rightLabel.textAlignment = NSTextAlignmentRight;
    if ([NSString isNull:self.model.remarks]) {
        rightLabel.text = @"无";
    }else{
        rightLabel.text = self.model.remarks;
    }
    [self.remarkView addSubview:rightLabel];
    
    UILabel *leftLabel = [[UILabel alloc]init];
    leftLabel.font = Font(13.f);
    leftLabel.textColor = COLOR_TEXT_GRAY;
    leftLabel.text = @"订单备注";
    [self.remarkView addSubview:leftLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_arrow"]];
    [self.remarkView addSubview:imageView];
    
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.bottom.equalTo(self.remarkView);
        make.width.mas_equalTo(80.0f);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.0f);
        make.size.mas_equalTo(CGSizeMake(8.0f, 14.0f));
        make.centerY.equalTo(self.remarkView);
    }];
    
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.right.mas_equalTo(imageView.mas_left).offset(-10);
       make.top.bottom.equalTo(self.remarkView);
        make.left.mas_equalTo(leftLabel.mas_right).offset(20);
    }];
}

- (void)creatPayInfoView:(NSArray *)array{
    [self.payInfoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *lastView;
    for (NSDictionary *dic in array) {
        
        UILabel *rightLabel = [[UILabel alloc]init];
        rightLabel.font = Font(13.f);
        rightLabel.textColor = COLOR_TEXT_GRAY;
        rightLabel.text = [dic allValues][0];
        rightLabel.textAlignment = NSTextAlignmentRight;
        [_payInfoView addSubview:rightLabel];
        
        UILabel *leftLabel = [[UILabel alloc]init];
        leftLabel.font = Font(13.f);
        leftLabel.textColor = COLOR_TEXT_GRAY;
        leftLabel.text = [dic allKeys][0];
        [_payInfoView addSubview:leftLabel];
        
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.payInfoView);
            make.height.mas_equalTo(12);
            make.width.equalTo(self.payInfoView).multipliedBy(0.5);
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom).offset(10);
            }else{
                make.top.equalTo(self.payInfoView);
            }
        }];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.payInfoView);
            make.top.bottom.equalTo(rightLabel);
            make.right.equalTo(rightLabel.mas_left);
        }];
        lastView = rightLabel;
        if ([leftLabel.text isEqualToString:@"实付款"]) {
            leftLabel.textColor = COLOR_TEXT_BLACK;
            rightLabel.textColor = COLOR_TEXT_RED;
            rightLabel.font = FontMedium(13.f);
        }
    }
    [_payInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView);
    }];
}

- (UIView *)payInfoView{
    if (!_payInfoView) {
        _payInfoView = [UIView new];
    }
    return _payInfoView;
}
- (UIView *)infoView{
    if (!_infoView) {
        _infoView = [UIView new];
    }
    return _infoView;
}

- (UIButton *)remarkView{
    if (!_remarkView) {
        _remarkView = [UIButton buttonWithType:UIButtonTypeCustom];
        @weakify(self);
        [[_remarkView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (self.remarkBlock && [NSString isNull:self.model.remarks] == NO) {
                self.remarkBlock(self.model.remarks);
            }
        }];
    }
    return _remarkView;
}

@end
