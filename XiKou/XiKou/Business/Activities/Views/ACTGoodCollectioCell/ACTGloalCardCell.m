//
//  ACTGloalCardCell.m
//  XiKou
//
//  Created by L.O.U on 2019/7/6.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTGloalCardCell.h"
#import "ACTGoodCardCell.h"
#import "XKUIUnitls.h"
#import "XKGoodModel.h"

@interface ACTGloalCardCell ()

@property (nonatomic, strong) ACTGoodCardCell *bigCell;

@property (nonatomic, strong) ACTGoodCardCell *smallCell;

@property (nonatomic, strong) ACTGoodCardCell *smallCell2;

@end

@implementation ACTGloalCardCell
{
    CGFloat space;
    CGFloat smallCellH;
    CGFloat bigCellW;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _bigCell   = [[ACTGoodCardCell alloc]init];
        _bigCell.tag  = 1;
        _bigCell.hidden = YES;
        _bigCell.userInteractionEnabled  = YES;
        _bigCell.layer.masksToBounds = YES;
        _bigCell.layer.cornerRadius  = 2.f;
        
        _smallCell = [[ACTGoodCardCell alloc]init];
        _smallCell.tag = 2;
        _smallCell.hidden = YES;
        _smallCell.userInteractionEnabled = YES;
        _smallCell.layer.masksToBounds = YES;
        _smallCell.layer.cornerRadius  = 2.f;
        
        _smallCell2 = [[ACTGoodCardCell alloc]init];
        _smallCell2.tag = 3;
        _smallCell2.hidden = YES;
        _smallCell2.userInteractionEnabled = YES;
        _smallCell2.layer.masksToBounds = YES;
        _smallCell2.layer.cornerRadius  = 2.f;
        
        [_bigCell addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cardCellClick:)]];
        [_smallCell addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cardCellClick:)]];
        [_smallCell2 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cardCellClick:)]];
        
        [self.contentView xk_addSubviews:@[self.bigCell,self.smallCell,self.smallCell2]];
        
         space = 10;
         smallCellH = (self.height - space)/2.;
         bigCellW   = self.width - space - smallCellH;
        
        _bigCell.frame = CGRectMake(0, 0, bigCellW, self.height);
        _smallCell.frame = CGRectMake(self.bigCell.right + space, 0, smallCellH, smallCellH);
        _smallCell2.frame = CGRectMake(self.bigCell.right + space, self.smallCell.bottom + space, smallCellH, smallCellH);

    }
    return self;
}

- (void)cardCellClick:(UIGestureRecognizer *)tap{
    XKGoodListModel *gModel = self.goodlist[tap.view.tag-1];
    [MGJRouter openURL:kRouterGoods withUserInfo:@{@"activityType":@(Activity_Global),@"id":gModel.id} completion:nil];
}
    
- (void)setGoodlist:(NSArray <XKGoodListModel *>*)goodlist{
    _goodlist = goodlist;

    for (int i = 0; i<goodlist.count; i++) {
        
        if (i>= self.contentView.subviews.count) return;
        ACTGoodCardCell *cell = self.contentView.subviews[i];
        cell.hidden = NO;
        XKGoodListModel *gModel = goodlist[i];
        cell.discountLabel.text  = [NSString stringWithFormat:@" 券%.2f   ",[gModel.couponValue floatValue]/100];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[gModel.goodsImageUrl appendOSSImageWidth:bigCellW height:self.height]] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
        if (gModel.stock == 0) {
            cell.sellOutLabel.hidden = NO;
        }else{
            cell.sellOutLabel.hidden = YES;
        }
    }
}
@end
