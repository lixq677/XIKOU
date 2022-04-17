//
//  HMRankChildVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/29.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "HMRankChildVC.h"
#import "HMOtGoodsCell.h"
#import "XKEmptyView.h"
#import "XKDataService.h"
#import "UILabel+NSMutableAttributedString.h"

#import "XKHomeService.h"
#import "XKGoodModel.h"

#import "TABAnimated.h"
#import "XKPlaceholdTableCell.h"

@interface HMRankChildVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) UIImageView *headView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation HMRankChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    
    @weakify(self);
    [RACObserve(self.tableView, contentSize) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        CGSize contentSize = [(NSValue *)x CGSizeValue];
        if ([@(self.tableView.height) integerValue] != [@(contentSize.height) integerValue] && self.dataArray.count > 0) {
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(contentSize.height);
            }];
        }
    }];
}

- (void)setupUI{

    [self.view addSubview:self.bgScrollView];
    [self.bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.bgScrollView xk_addSubviews:@[self.headView,self.tableView]];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.bgScrollView);
        make.height.mas_equalTo(205.f);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWidth - 30);
        make.height.mas_equalTo(kScreenHeight - kTopHeight - (34 + [XKUIUnitls safeBottom]));
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.bottom.equalTo(self.bgScrollView);
    }];
    
    self.tableView.scrollEnabled = NO;
    self.tableView.ly_emptyView.contentViewOffset = -180;
    self.headView.hidden = YES;
    
    if (self.type == RankHot)       self.headView.image = [UIImage imageNamed:@"hm_hotrank_banner"];
    if (self.type == RankRecommend) self.headView.image = [UIImage imageNamed:@"hm_hotaddvice_banner"];
    if (self.type == RankMakeMoney) self.headView.image = [UIImage imageNamed:@"hm_makemoney_banner"];
    
    self.tableView.tabAnimated =
    [TABTableAnimated animatedWithCellClass:[XKPlaceholdGoodCell class]
                                 cellHeight:[XKPlaceholdGoodCell cellHeight]];
    
    _tableView.tabAnimated.animatedCount = 1;
    _tableView.tabAnimated.animatedSectionCount = 4;
    
    [self.tableView tab_startAnimationWithCompletion:^{
        [self getRankList];
    }];
    
    self.bgScrollView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(getRankList)];
}

- (void)getRankList{
    [[XKFDataService() homeService]queryRankDataByType:self.type Completion:^(XKRankResponse * _Nonnull response) {
        if ([response isSuccess]) {
            self.dataArray = response.data;
            [self.tableView reloadData];
            if (self.dataArray.count == 0) {
                self.tableView.tableHeaderView = nil;
                self.headView.hidden = YES;
            }else{
                self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 120.f)];
                self.headView.hidden = NO;
            }
        }else{
            [response showError];
        }
        [self.bgScrollView.mj_header endRefreshing];
        [self.tableView tab_endAnimation];
    }];
}

#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HMOtGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HMOtGoodsCell" forIndexPath:indexPath];

    XKGoodListModel *model = _dataArray[indexPath.section];
    [cell.imageView sd_setImageWithURL:[NSURL  URLWithString:model.goodsImageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    cell.textLabel.text = model.commodityName;
    [cell.textLabel setLineSpace:7.f];
    
    if (_type == RankMakeMoney) {
        cell.transmitLabel.text = [NSString stringWithFormat:@"省钱¥%.2f",[model.saveMoney floatValue]/100];
    }else{
        cell.transmitLabel.text = [NSString stringWithFormat:@"转发%@+",model.shareCount];
    }
    cell.rankLabel.text = [NSString stringWithFormat:@"%ld",indexPath.section + 1];
    if (indexPath.section == 0) {
        cell.rankBgView.image = [UIImage imageNamed:@"rank1"];
    }else if (indexPath.section == 1) {
        cell.rankBgView.image = [UIImage imageNamed:@"rank2"];
    }else if (indexPath.section == 2) {
        cell.rankBgView.image = [UIImage imageNamed:@"rank3"];
    }else{
        cell.rankBgView.image = [UIImage imageNamed:@"rank"];
    }
    
    if (model.activityType == Activity_Discount) {
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.commodityPriceOne doubleValue]/100];
        cell.originalLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.salePrice doubleValue]/100];
    }else{
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.commodityPrice doubleValue]/100];
        cell.originalLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.salePrice doubleValue]/100];
    }
    [cell.originalLabel addMiddleLineWithSubString:cell.originalLabel.text];
    [cell.priceLabel handleRedPrice:FontSemibold(17.f)];
    
    if (model.activityType == Activity_Discount) {
        cell.detailTextLabel.hidden = NO;
        cell.detailTextLabel.text = [NSString stringWithFormat:@" 封顶%@折 ",@([[NSString stringWithFormat:@"%.2f",[model.rateOne floatValue]] floatValue])];
    }
    if (model.activityType == Activity_Bargain) {
        cell.detailTextLabel.hidden = NO;
        cell.detailTextLabel.text = [NSString stringWithFormat:@" %ld人助力 ",model.bargainNumber];
    }
    if (model.activityType == Activity_Global) {
        cell.detailTextLabel.hidden = YES;
        cell.dashView.value = [model.couponAmount floatValue]/100;
    }
    cell.dashView.hidden = !cell.detailTextLabel.hidden;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XKGoodModel *model = _dataArray[indexPath.section];
    [MGJRouter openURL:kRouterGoods withUserInfo:@{@"activityType":@(model.activityType),@"id":model.id} completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
#pragma mark getter or setter
- (UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc]init];
        _bgScrollView.backgroundColor = COLOR_VIEW_GRAY;
        _bgScrollView.showsVerticalScrollIndicator = NO;
    }
    return _bgScrollView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = CGFLOAT_MIN;
        _tableView.sectionFooterHeight = 10;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.ly_emptyView = [XKEmptyView goodListNoDataView];
        [_tableView registerClass:[HMOtGoodsCell class] forCellReuseIdentifier:@"HMOtGoodsCell"];
    }
    return _tableView;
}

- (UIImageView *)headView{
    if (!_headView) {
        _headView = [[UIImageView alloc]init];
        _headView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headView;
}

@end
