//
//  ACTBargainDetailVC.m
//  XiKou
//  砍价详情
//  Created by L.O.U on 2019/7/10.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTBargainDetailVC.h"
#import "XKMakePosterVC.h"
#import "ACTBagainPersonCell.h"
#import "ACTBagainInfoCell.h"
#import "XKShareTool.h"
#import "UILabel+NSMutableAttributedString.h"
#import "XKBargainInfoModel.h"
#import "CMOrderVC.h"
#import "XKMakeOrderParam.h"
#import "XKActivityService.h"
#import "XKAccountManager.h"
#import "XKUserService.h"

#import "UIImage+XKCommon.h"

@interface ACTBargainDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) XKBargainInfoModel *bargainInfoModel;
@end

@implementation ACTBargainDetailVC
{
    CAShapeLayer *_shapeLayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}

- (void)setDetailModel:(ACTGoodDetailModel *)detailModel{
    _detailModel = detailModel;
}

- (void)getData{
    XKGoodModel *gModel = self.detailModel.activityCommodityAndSkuModel;
    [[XKFDataService() actService]getBargainDetailByUserId:[XKAccountManager defaultManager].account.userId andActivityId:gModel.activityId andCommodityId:self.skuModel.id Complete:^(XKBargainInfoRespnse * _Nonnull response) {
        if ([response isSuccess]) {
            self.bargainInfoModel = response.data;
            [self handleData];
        }else{
            [response showError];
        }
    }];
}

- (void)handleData{
    if (self.bargainInfoModel.state == 1) {
        self.title = @"继续砍价";
        [self shareAction];
    }else{
        if (self.bargainInfoModel.bargainCount  == self.detailModel.baseRuleModel.bargainNumber) {
            self.title = @"砍价成功";
        }else{
            [self shareAction];
            self.title = @"继续砍价";
        }
    }
    [self.tableView reloadData];
    if (self.bargainInfoModel.userBargainRecordVoList.count == 0) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 30, 100)];
        label.font = Font(12.f);
        label.textColor = COLOR_TEXT_GRAY;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"暂无砍价记录";
        label.backgroundColor = [UIColor whiteColor];
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:label.bounds
                                                         byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)
                                                               cornerRadii:CGSizeMake(4, 4)];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = bezierPath.CGPath;
        layer.fillColor = [UIColor whiteColor].CGColor;
        label.layer.mask = layer;
        
        self.tableView.tableFooterView = label;
    }else{
        self.tableView.tableFooterView = [UIView new];
    }
}

- (void)setUI{
    
    self.view.backgroundColor = COLOR_VIEW_GRAY;
    
    CGPoint point1 = CGPointMake(0, 170);
    CGPoint point2 = CGPointMake(kScreenWidth/2, 200);
    CGPoint point3 = CGPointMake(kScreenWidth, 170);
    [UIView Calculate_cicularPoint1:point1 poin2:point2 poin3:point3 complete:^(CGPoint center, CGFloat r) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(kScreenWidth, 0)];
        [path addLineToPoint:CGPointMake(kScreenWidth, 170)];
        [path addArcWithCenter:center radius:r startAngle:0 endAngle:M_PI clockwise:YES];
        [path addLineToPoint:CGPointMake(0, 170)];
        [path addLineToPoint:CGPointMake(0, 0)];
        [path fill];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = path.CGPath;
        layer.fillColor = COLOR_TEXT_BLACK.CGColor;
        [self.view.layer addSublayer:layer];
        self.view.clipsToBounds = YES;
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-[XKUIUnitls safeBottom]);
    }];
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ACTBagainInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ACTBagainInfoCell"];
        [cell reloadGoodInfo:self.skuModel andBargainInfo:self.bargainInfoModel ruleMode:self.detailModel.baseRuleModel];
        @weakify(self);
        cell.cellAction = ^(CellActionType type) {
            @strongify(self);
            switch (type) {
                case ActionShare:{
                    [self shareAction];
                    break;
                }
                case ActionBragainBuy:{
                    [self buyAction];
                    //[self bargainAction];
                }
                    break;
                case ActionBuy:{
                    [self buyWithSkuModel:self.skuModel];
                }
                    break;
                default:
                    [self buyAction];
                    break;
            }
        };
        return cell;
    }else{
        ACTBagainUsersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ACTBagainUsersCell" forIndexPath:indexPath];
        cell.models = self.bargainInfoModel.userBargainRecordVoList;
        cell.maxCount = self.detailModel.baseRuleModel.bargainNumber;
        [cell reloadData];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UITableViewHeaderFooterView *head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"head"];
        if (!head) {
            head = [self headView];
        }
        return head;
    }
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 20 : 53;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == 0 ? 9 : CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section > 0) {
        NSInteger numberOfRows = [tableView numberOfRowsInSection:indexPath.section];
        UIBezierPath *bezierPath;
        CGRect rect = CGRectMake(0, 0, cell.contentView.width, cell.contentView.height+1);
        if (indexPath.row == numberOfRows - 1) {
            if (indexPath.section == 0) {
                bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(4, 4)];
            }else{
                bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(4, 4)];
                cell.separatorInset  = UIEdgeInsetsMake(0, 0, 0, kScreenWidth);
            }
        } else {
            bezierPath = [UIBezierPath bezierPathWithRect:rect];
            cell.separatorInset  = UIEdgeInsetsMake(0, 40, 0, 40);
        }
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = bezierPath.CGPath;
        layer.fillColor = [UIColor whiteColor].CGColor;
        cell.contentView.layer.mask = layer;
    }
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isMemberOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark getter && setter
- (UITableViewHeaderFooterView *)headView{
    UITableViewHeaderFooterView *view = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"head"];

    UIView *whiteView = [UIView new];
    whiteView.backgroundColor = [UIColor whiteColor];
    [view.contentView addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view.contentView);
    }];
    
    UILabel *label  = [[UILabel alloc]init];
    label.font      = FontMedium(17.f);
    label.textColor = COLOR_TEXT_BLACK;
    label.text      = @"砍价记录 CUT PRICE LIST";
    [label setAttributedStringWithSubString:@"CUT PRICE LIST" color:COLOR_PRICE_GRAY font:FontLight(13.f)];
    [whiteView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(37);
        make.bottom.mas_equalTo(0);
    }];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, kScreenWidth - 30, 53)
                                                     byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                                           cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = bezierPath.CGPath;
    layer.fillColor = [UIColor whiteColor].CGColor;
    whiteView.layer.mask = layer;
    return view;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        _tableView.rowHeight  = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;

        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = COLOR_LINE_GRAY;
        _tableView.backgroundColor = [UIColor clearColor];

        [_tableView registerClass:[ACTBagainInfoCell class] forCellReuseIdentifier:@"ACTBagainInfoCell"];
        [_tableView registerClass:[ACTBagainUsersCell class] forCellReuseIdentifier:@"ACTBagainUsersCell"];
    }
    return _tableView;
}

#pragma mark ---------------------业务
- (void)shareAction{
    
    NSString *content = [NSString stringWithFormat:@"分享给好友，获得%ld人助力\n即可获得底价购物",self.detailModel.baseRuleModel.bargainNumber];
    XKGoodModel *gModel = self.detailModel.activityCommodityAndSkuModel;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.skuModel.skuImage]];
    if (data.length/1024 > 100) {
        UIImage *image = [UIImage imageWithData:data];
        data = [image compressQualityWithMaxLength:100*1024];
    }
    /*
    NSString *url = [NSString stringWithFormat:@"pages/activity/bargain/share/main?userId=%@&activityId=%@&commodityId=%@&extcode=%@",[XKAccountManager defaultManager].userId,gModel.activityId,gModel.id,[XKAccountManager defaultManager].extCode];
     [[XKShareTool defaultTool]shareProgramWithViewTitle:@"恭喜您发起砍价"
     andContent:content
     andUrl:url
     andImage:data
     andShareTitle:shareTitle];
    */
    
    NSString *shareTitle = [NSString stringWithFormat:@"快来帮我砍砍～只差你一刀了,%@",self.skuModel.commodityName];
    NSString *wxDomain = [[XKNetworkConfig shareInstance] wxDomain];
    NSString *url = [wxDomain stringByAppendingFormat:@"/BargainShare?userId=%@?activityId=%@?commodityId=%@?extCode=%@?BargainShare=BargainShare",[XKAccountManager defaultManager].userId,gModel.activityId,self.skuModel.id,[XKAccountManager defaultManager].extCode];
    [[XKShareTool defaultTool] shareWxOfficialAccountsPlatformWithViewTitle:@"恭喜您发起砍价" andContent:content andUrl:url andImage:data andShareTitle:shareTitle];
    
   
    
}
#pragma mark 生成订单
- (void)buyAction{
    XKGoodModel *gModel = self.detailModel.activityCommodityAndSkuModel;
    if (gModel.skuList.count == 0) {
        XKShowToast(@"商品信息错误");
        return;
    }
    XKGoodSKUModel *skuModel = gModel.skuList[0];
    XKMakeOrderParam *makeOrderModel = [XKMakeOrderParam new];
    makeOrderModel.activityGoodsId       = skuModel.id;
    makeOrderModel.activityId            = gModel.activityId;
    makeOrderModel.commodityId           = skuModel.commodityId;
    makeOrderModel.goodsCode             = gModel.goodsCode;
    makeOrderModel.goodsId               = gModel.goodsId;
    makeOrderModel.goodsName             = skuModel.commodityName ?: gModel.commodityName;
    makeOrderModel.goodsImageUrl         = skuModel.skuImage ?: gModel.goodsImageUrl;
    makeOrderModel.merchantId            = gModel.merchantId;
    makeOrderModel.salePrice             = skuModel.salePrice;
    makeOrderModel.goodsPrice            = skuModel.salePrice;
    makeOrderModel.orderSource           = @1;
    makeOrderModel.commodityQuantity     = @1;
    makeOrderModel.condition             = skuModel.contition;
    makeOrderModel.buyerId               = [XKAccountManager defaultManager].account.userId;
    makeOrderModel.postage               = self.detailModel.baseRuleModel.postage;
    makeOrderModel.activityType          = self.detailModel.activityType;
    makeOrderModel.id                    = self.bargainInfoModel.id;
    makeOrderModel.orderAmount           = [self.bargainInfoModel.currentPrice doubleValue];
    makeOrderModel.createType            = @2;
    CMOrderVC *vc = [[CMOrderVC alloc]initWithModel:makeOrderModel];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark 砍价
- (void)bargainAction{
    NSString *userId = [[[XKAccountManager defaultManager] account] userId];
    XKUserInfoData *userInfo = [[XKFDataService() userService] queryUserInfoFromCacheWithId:userId];
    [[XKFDataService() actService]userJoinBargainByIcon:userInfo.headUrl andName:(userInfo.nickName ? userInfo.nickName : userInfo.userName) andUserId:userId andID:self.bargainInfoModel.id Complete:^(XKBaseResponse * _Nonnull response) {
        if ([response isSuccess]) {
            XKShowToast(@"砍价成功");
        }else{
            [response showError];
        }
    }];
}

- (void)buyWithSkuModel:(XKGoodSKUModel *)skuModel{
    XKGoodModel *gModel = self.detailModel.activityCommodityAndSkuModel;
    XKMakeOrderParam *makeOrderModel = [XKMakeOrderParam new];
    makeOrderModel.activityGoodsId       = skuModel.id;
    makeOrderModel.activityId            = gModel.activityId;
    makeOrderModel.commodityId           = skuModel.commodityId;
    makeOrderModel.goodsCode             = gModel.goodsCode;
    makeOrderModel.goodsId               = gModel.goodsId;
    makeOrderModel.goodsName             = skuModel.commodityName ?: gModel.commodityName;
    makeOrderModel.goodsImageUrl         = skuModel.skuImage ?: gModel.goodsImageUrl;
    makeOrderModel.merchantId            = gModel.merchantId;
    makeOrderModel.goodsPrice            = skuModel.salePrice;
    makeOrderModel.salePrice             = skuModel.salePrice;
    makeOrderModel.commodityModel        = skuModel.commodityModel;
    makeOrderModel.commoditySpec         = skuModel.commoditySpec;
    makeOrderModel.condition             = skuModel.contition;
    makeOrderModel.orderSource           = @1;
    makeOrderModel.commodityQuantity     = @1;
    makeOrderModel.buyerId               = [XKAccountManager defaultManager].account.userId;
    makeOrderModel.postage               = self.detailModel.baseRuleModel.postage;
    makeOrderModel.activityType          = self.detailModel.activityType;
    makeOrderModel.id                    = self.bargainInfoModel.id;
    makeOrderModel.createType            = @1;
    makeOrderModel.orderAmount           = [makeOrderModel.goodsPrice doubleValue];
    CMOrderVC *vc = [[CMOrderVC alloc]initWithModel:makeOrderModel];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
