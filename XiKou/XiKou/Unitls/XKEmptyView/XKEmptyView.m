//
//  XKEmptyView.m
//  XiKou
//
//  Created by L.O.U on 2019/7/22.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKEmptyView.h"

@implementation XKEmptyView

+(instancetype)goodListNoDataView{
    return [XKEmptyView emptyViewWithImageStr:@"emptyOrder" titleStr:@"没有找到相关商品" detailStr:@""];
}

+(instancetype)orderListNoDataView{
    return [XKEmptyView emptyViewWithImageStr:@"emptyOrder" titleStr:@"您还没有相关订单" detailStr:@""];
}


+(instancetype)normalViewNodataWithTarget:(id)target andSel:(SEL)sel{
    
    XKEmptyView *emptyView = [XKEmptyView emptyActionViewWithImage:[UIImage imageNamed:@"emptyOrder"]
                                                          titleStr:@"没有找到相关商品"
                                                         detailStr:nil
                                                       btnTitleStr:@"重新加载"
                                                            target:target
                                                            action:sel];
    emptyView.emptyViewIsCompleteCoverSuperView = YES;
    return emptyView;
}

+(instancetype)networkErrorViewWithTarget:(id)target andSel:(SEL)sel{
    return [XKEmptyView emptyActionViewWithImage:[UIImage imageNamed:@"noNetwork"]
                                        titleStr:@"无网络，加载失败，稍后重试"
                                       detailStr:nil
                                     btnTitleStr:@"重新加载"
                                          target:target
                                          action:sel];
}

+ (instancetype)amountListNoDataView{
    return [XKEmptyView emptyViewWithImageStr:@"amount_no_data" titleStr:@"您还没有相关明细" detailStr:@""];

}

+ (instancetype)addressListNoDataView{
    return [XKEmptyView emptyViewWithImageStr:@"ic_no_address" titleStr:@"您还没有收货地址，前往新增吧" detailStr:@""];
    
}


- (void)prepare{
    [super prepare];
    
    self.titleLabFont = Font(12.f);
    self.titleLabTextColor = COLOR_TEXT_GRAY;
    
    self.actionBtnFont = FontMedium(12.f);
    self.actionBtnTitleColor = [UIColor whiteColor];
    self.actionBtnCornerRadius = 2.f;
    self.actionBtnBackGroundColor = COLOR_TEXT_BLACK;
    self.actionBtnHeight = 40;
    self.actionBtnWidth  = 100;
}

@end
