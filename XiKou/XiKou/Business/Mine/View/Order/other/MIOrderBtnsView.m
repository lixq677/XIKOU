//
//  MIOrderBtnsView.m
//  XiKou
//
//  Created by L.O.U on 2019/7/2.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIOrderBtnsView.h"
#import "XKUIUnitls.h"
#import "XKOrderModel.h"
#import "XKCustomAlertView.h"
#import "XKOrderManger.h"
#import "NSDate+Extension.h"
@interface MIOrderBtnsView ()

@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIButton *middleBtn;

@property (nonatomic, strong) UILabel *tipsLabel;
@end

@implementation MIOrderBtnsView

- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.width = kScreenWidth;
        self.height = 29;
        
        self.rightBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightBtn.frame               = CGRectMake(self.width - 15 - 75, 0, 75, 29);
        self.rightBtn.layer.masksToBounds = YES;
        self.rightBtn.layer.cornerRadius  = 29/2.0;
        self.rightBtn.layer.allowsEdgeAntialiasing = YES;
        [self.rightBtn setBackgroundColor:COLOR_TEXT_BLACK];
        [self.rightBtn.titleLabel setFont:Font(12.f)];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.middleBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
        self.middleBtn.frame               = CGRectMake(self.rightBtn.left - 10 - 75, 0, 75, 29);
        self.middleBtn.layer.masksToBounds = YES;
        self.middleBtn.layer.cornerRadius  = 29/2.0;
        self.middleBtn.layer.borderColor   = COLOR_TEXT_GRAY.CGColor;
        self.middleBtn.layer.borderWidth   = 1/[UIScreen mainScreen].scale;
        self.middleBtn.layer.allowsEdgeAntialiasing = YES;
        [self.middleBtn setBackgroundColor:[UIColor whiteColor]];
        [self.middleBtn setTitleColor:COLOR_TEXT_GRAY forState:UIControlStateNormal];
        [self.middleBtn.titleLabel setFont:Font(12.f)];
        [self.middleBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.leftBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftBtn.frame               = CGRectMake(self.middleBtn.left - 10 - 75, 0, 75, 29);
        self.leftBtn.layer.masksToBounds = YES;
        self.leftBtn.layer.cornerRadius  = 29/2.0;
        self.leftBtn.layer.borderColor   = COLOR_TEXT_GRAY.CGColor;
        self.leftBtn.layer.borderWidth   = 1/[UIScreen mainScreen].scale;
        self.leftBtn.layer.allowsEdgeAntialiasing = YES;
        [self.leftBtn setBackgroundColor:[UIColor whiteColor]];
        [self.leftBtn setTitleColor:COLOR_TEXT_GRAY forState:UIControlStateNormal];
        [self.leftBtn.titleLabel setFont:Font(12.f)];
        [self.leftBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.leftBtn.hidden = YES;
        self.middleBtn.hidden = YES;
        self.rightBtn.hidden = YES;
        [self addSubview:self.tipsLabel];
        [self xk_addSubviews:@[self.leftBtn,self.middleBtn,self.rightBtn]];
        [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.rightBtn);
            make.left.equalTo(self).offset(10);
        }];
    }
    return self;
}

- (void)setModel:(XKOrderBaseModel *)model
{
    _model = model;
    
    self.leftBtn.hidden   = YES;
    self.middleBtn.hidden = YES;
    self.rightBtn.hidden  = YES;
    [self.rightBtn setBackgroundColor:COLOR_TEXT_BLACK];

    switch (model.state) {
        case OSUnPay:
        {
            self.middleBtn.hidden = NO;
            self.rightBtn.hidden  = NO;
            self.rightBtn.tag  = OActionPay;
            [self.rightBtn setTitle:@"立即付款" forState:UIControlStateNormal];
            if (model.type == OTWug || model.type == OTGlobalSeller) {
                if (model.paid) {
                    self.leftBtn.hidden  = NO;
                    self.middleBtn.tag = OActionPayForOther;
                    self.leftBtn.tag   = OActionCancle;
                    [self.middleBtn setTitle:@"请人代付" forState:UIControlStateNormal];
                    [self.leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                    if (model.type == OTWug) {
                         [self.leftBtn setHidden:YES];
                    }else{
                        [self.leftBtn setHidden:NO];
                    }
                }else{
                    self.middleBtn.tag = OActionCancle;
                    [self.middleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                    if (model.type == OTWug) {
                         [self.middleBtn setHidden:YES];
                    }else{
                        [self.middleBtn setHidden:NO];
                    }
                }
            }else{
                self.middleBtn.tag  = OActionCancle;
                [self.middleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            }
        }
            break;
        case OSUnDeliver:
        {
            self.rightBtn.hidden = NO;
            self.rightBtn.tag = OActionExpedite;
            [self.rightBtn setTitle:@"提醒发货" forState:UIControlStateNormal];
        }
            break;
        case OSUnReceive:
        {
            self.leftBtn.hidden   = YES;
            self.middleBtn.hidden = NO;
            self.rightBtn.hidden  = NO;
            self.middleBtn.tag    = OActionLogistics;
            self.rightBtn.tag     = OActionSure;
            self.leftBtn.tag      = OActionExtend;
            [self.rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [self.middleBtn setTitle:@"查看物流" forState:UIControlStateNormal];
//            [self.leftBtn setTitle:@"延长收货" forState:UIControlStateNormal];
            

        }
            break;
        case OSUnGroup:
        {
            self.rightBtn.hidden  = NO;
            self.rightBtn.tag     = OActionShare;
            [self.rightBtn setTitle:@"分享好友" forState:UIControlStateNormal];
        }
            break;
        case OSUnSure:
        {
            if (_model.type == OTGlobalSeller) {
                self.middleBtn.hidden = NO;
                self.rightBtn.hidden  = NO;
                self.middleBtn.tag    = OActionDeliver;
                self.rightBtn.tag     = OActionConsign;
                [self.rightBtn setBackgroundColor:COLOR_TEXT_BROWN];
                [self.middleBtn setTitle:@"发货" forState:UIControlStateNormal];
                [self.rightBtn setTitle:@"寄卖" forState:UIControlStateNormal];
            }
            if (_model.type == OTCanConsign) {
                self.middleBtn.hidden  = NO;
                self.rightBtn.hidden   = NO;
                self.middleBtn.tag     = OActionDeliver;
                self.rightBtn.tag      = OActionConsign;
                [self.rightBtn setBackgroundColor:COLOR_TEXT_BROWN];
                [self.middleBtn setTitle:@"发货" forState:UIControlStateNormal];
                [self.rightBtn setTitle:@"寄卖" forState:UIControlStateNormal];
            }
        }
            break;
        case OSComlete:{
            self.middleBtn.hidden = NO;
            self.middleBtn.tag    = OActionLogistics;
            [self.middleBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            
            self.rightBtn.hidden  = NO;
            self.rightBtn.tag     = OActionDelete;
            [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        }
            break;
        case OSClose:
        case OSCancle:
        case OSGroupFail:
        {
            self.rightBtn.hidden  = NO;
            self.rightBtn.tag     = OActionDelete;
            [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        }
            break;

        default:
            break;
    }
    
}
- (void)loadOrderTimeWithModel:(XKOrderDetailModel *)model {
    if (model.type == OSUnReceive) {
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
//        NSDate *date = [formatter dateFromString:model.orderTime];
//        NSDate *conDate = [date dateByAddingDays:15];
//        NSString *dateStr = [conDate stringWithFormat:@"MM月dd日24点"];
        self.tipsLabel.hidden = NO;
        self.tipsLabel.text = [NSString stringWithFormat:@"将于%@自动收货",model.autoDeliveryTime];
    }
}
- (void)buttonClick:(UIButton *)btn{
    [[XKOrderManger sharedMange] orderListButtonClick:btn.tag andModel:self.model];
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = Font(14);
        _tipsLabel.textAlignment = NSTextAlignmentLeft;
        _tipsLabel.textColor = COLOR_TEXT_BLACK;
        _tipsLabel.hidden = YES;
    }
    return _tipsLabel;
}

@end

