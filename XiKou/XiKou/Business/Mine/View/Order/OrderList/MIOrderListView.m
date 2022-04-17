//
//  MIOrderListView.m
//  XiKou
//
//  Created by L.O.U on 2019/7/1.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIOrderListView.h"
#import "XKUIUnitls.h"
#import "MIOrderGoodCell.h"
#import "MIOrderHeadView.h"
#import "MIOrderFootView.h"
#import "UILabel+NSMutableAttributedString.h"
#import "XKOrderModel.h"
#import <MJRefresh.h>

@interface MIOrderListView ()<UITableViewDataSource>

@end

static NSString * const headID = @"MIOrderHeadView";
static NSString * const cellID = @"MIOrderGoodCell";
static NSString * const mutilStoreCellID = @"mutilStoreCellID";

@implementation MIOrderListView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        self.backgroundColor = COLOR_VIEW_GRAY;
        self.dataSource      = self;
        self.delegate        = self;
        self.separatorStyle  = UITableViewCellSeparatorStyleNone;
        self.estimatedRowHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [XKUIUnitls safeBottom])];
        [self registerClass:[MIOrderGoodCell class] forCellReuseIdentifier:cellID];
        [self registerClass:[MIOrderHeadView class] forHeaderFooterViewReuseIdentifier:headID];
        [self registerClass:[MIOrderFootView class] forHeaderFooterViewReuseIdentifier:footID1];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.orderArray.count < K_REQUEST_PAGE_COUNT ) {
        self.mj_footer.hidden = YES;
    }else{
        self.mj_footer.hidden = NO;
    }
    return _orderArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    MIOrderGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    XKOrderListModel *model  = _orderArray[indexPath.section];
    if (model.type != OTZeroBuy) {
        cell.numLabel.text   = [NSString stringWithFormat:@"x%@",model.commodityQuantity ? model.commodityQuantity : @1];
    }
    cell.nameLabel.text  = model.goodsName;
    [cell.nameLabel setLineSpace:8.5];
    [cell.coverView sd_setImageWithURL:[NSURL URLWithString:model.goodsImageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    
    if (model.type == OTZeroBuy) {
        //cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.commoditySalePrice doubleValue]/100];
        cell.desLabel.text   = [NSString stringWithFormat:@"销售价:¥%.2f 拍卖价:¥%.2f 我出价: %@次",[model.commoditySalePrice doubleValue]/100,[model.commodityAuctionPrice doubleValue]/100,model.timesNum];
    }else{
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.commoditySalePrice doubleValue]/100];
        cell.desLabel.text   = [NSString stringWithFormat:@"%@ %@",model.commodityModel,model.commoditySpec];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    MIOrderHeadView *head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headID];
    XKOrderListModel *model  = _orderArray[section];
    head.titleLabel.text = model.merchantName;
    head.subLabel.text   = model.statusTitle;
    head.userInteractionEnabled = YES;
    head.tag = section;
    [head addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSection:)]];
    return head;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    XKOrderListModel *model  = _orderArray[section];
    MIOrderFootView *foot = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footID1];
    foot.model = model;
    foot.tag = section;
    [foot addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSection:)]];
    return foot;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 101;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    XKOrderListModel *model  = _orderArray[section];
    if (model.state == OSConsign) {
        return 30;
    }
    if (model.type == OTConsigned) {
        return 15;
    }
    return 79;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    XKOrderListModel *model  = _orderArray[indexPath.section];
    if (model.type == OTConsigned) {

        MIOrderGoodCell *goodCell = (MIOrderGoodCell *)cell;
        NSInteger numberOfRows = [tableView numberOfRowsInSection:indexPath.section];
 
        UIBezierPath *bezierPath;
        CGRect rect = CGRectMake(0, 0, cell.width - 30, cell.height);
        if (indexPath.row == numberOfRows - 1) {
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(4, 4)];
        } else {
            bezierPath = [UIBezierPath bezierPathWithRect:rect];
        }
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = bezierPath.CGPath;
        layer.fillColor = [UIColor whiteColor].CGColor;
        goodCell.bgView.layer.mask = layer;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self selectSection:indexPath.section];
}
- (void)setOrderArray:(NSArray<XKOrderListModel *> *)orderArray{
    _orderArray = orderArray;
    [self reloadData];
}

- (void)tapSection:(UITapGestureRecognizer *)tap{
    NSInteger tag = tap.view.tag;
    [self selectSection:tag];
}

- (void)selectSection:(NSInteger)section{
    XKOrderListModel *model = self.orderArray[section];
    if (_orderDelegate && [_orderDelegate respondsToSelector:@selector(selectOrder:)]) {
        [_orderDelegate selectOrder:model];
    }
}
@end
