//
//  MIPreferenceVC.m
//  XiKou
//
//  Created by Tony on 2019/6/13.
//  Copyright © 2019年 李笑清. All rights reserved.
//

#import "MIPreferenceVC.h"
#import "MIPreferenceDetailVC.h"

#import "XKUIUnitls.h"
#import "MIBasicCell.h"
#import "XKSegmentView.h"

#import "NSError+XKNetwork.h"
#import "MJDIYFooter.h"

#import "XKDataService.h"
#import "XKPropertyService.h"
#import "XKUnitls.h"
#import "XKPropertyData.h"
#import "XKAccountManager.h"

@interface MIPreferenceVC () <UITableViewDelegate,UITableViewDataSource,XKSegmentViewDelegate>

@property (nonatomic,strong)UITableView *tableView1;

@property (nonatomic,strong)UITableView *tableView2;

@property (nonatomic,strong)UITableView *tableView3;

@property (nonatomic,strong)UILabel *totalLabel;

@property (nonatomic,strong)UIImageView *icon;

@property (nonatomic,strong)UIView *topView;

@property (nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,strong)XKSegmentView *segmentView;

@property (nonatomic,strong)NSMutableArray<XKPreferenceData *> *unusePreferences;

@property (nonatomic,strong)NSMutableArray<XKPreferenceData *> *usedPreferences;

@property (nonatomic,strong)NSMutableArray<XKPreferenceData *> *unvalidPreferences;

@end

@implementation MIPreferenceVC{
    NSUInteger curPage;
   int _curPageForUnusePreference;//未使用优惠券当前数据所拉取到的页码
   int _curPageForUsedPreference;//已使用优惠券当前数据所拉取到的页码
   int _curPageForUnvalidPreference;//失效的优惠券当前数据所拉取到的页码
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view.
    [self setupUI];
    [self layout];
    NSString *userId = [[[XKAccountManager defaultManager] account] userId];
    /*缓存中获取未使用过的优惠券*/
    NSArray<XKPreferenceData *> *unusedPreferences = [[XKFDataService() propertyService] queryPreferenceFromCacheWithPrefrenceState:XKPreferenceStateUnused userId:userId];
    [self.unusePreferences addObjectsFromArray:unusedPreferences];
    
    /*缓存中获取已使用过的优惠券*/
    NSArray<XKPreferenceData *> *usedPreferences = [[XKFDataService() propertyService] queryPreferenceFromCacheWithPrefrenceState:XKPreferenceStateUsed userId:userId];
    [self.usedPreferences addObjectsFromArray:usedPreferences];
    
    /*缓存中获取未使用过的优惠券*/
    NSArray<XKPreferenceData *> *unvalidPreferences = [[XKFDataService() propertyService] queryPreferenceFromCacheWithPrefrenceState:XKPreferenceStateUnvalid userId:userId];
    [self.unvalidPreferences addObjectsFromArray:unvalidPreferences];
    
    [self initWithServer];
    [self queryTotalTickets];
}


- (void)setupUI{
    self.title = @"我的优惠券";
    self.view.backgroundColor = HexRGB(0xffffff, 1.0f);
    [self.topView addSubview:self.icon];
    [self.topView addSubview:self.totalLabel];
    [self.view addSubview:self.topView];
    
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.tableView1];
    [self.scrollView addSubview:self.tableView2];
    [self.scrollView addSubview:self.tableView3];
    
    [self.tableView1 registerClass:[MIPreferenceCell class] forCellReuseIdentifier:@"MIPreferenceCell"];
    [self.tableView2 registerClass:[MIPreferenceCell class] forCellReuseIdentifier:@"MIPreferenceCell"];
    [self.tableView3 registerClass:[MIPreferenceCell class] forCellReuseIdentifier:@"MIPreferenceCell"];
   
    UIView *(^createViewBlock)(void) = ^UIView *{
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_no_preference"]];
        UILabel *label = [[UILabel alloc] init];
        label.text = @"您还没有优惠券哦";
        label.textColor = HexRGB(0x999999, 1.0f);
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textAlignment = NSTextAlignmentCenter;
        
        [backgroundView addSubview:imageView];
        [backgroundView addSubview:label];
        imageView.centerX = kScreenWidth/2.0f;
        imageView.top = 75.0f;
        
        [label sizeToFit];
        label.centerX = imageView.centerX;
        label.top = imageView.bottom+10.0f;
        return backgroundView;
    };
    self.tableView1.backgroundView = createViewBlock();
    self.tableView2.backgroundView = createViewBlock();
    self.tableView3.backgroundView = createViewBlock();
    
    self.tableView1.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataForUnused)];
    self.tableView1.mj_footer = [MJDIYFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataForUnused)];
    
    
    
    self.tableView2.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataForUsed)];
    self.tableView2.mj_footer = [MJDIYFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataForUsed)];
    
    self.tableView3.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataForUnvalid)];
    self.tableView3.mj_footer = [MJDIYFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataForUnvalid)];
    
}

- (void)layout{
    CGFloat space = 0.0f;
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.mas_equalTo(15.0f);
        make.centerY.equalTo(self.topView);
    }];
    
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).offset(10.0f);
        make.centerY.equalTo(self.topView);
        make.top.bottom.right.equalTo(self.topView);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(30.0f);
    }];
    
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.height.mas_equalTo(45.0);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentView.mas_bottom);
        make.right.equalTo(self.view).offset(space);
        make.left.bottom.equalTo(self.view);
    }];

    CGFloat y =  45.0f+kTopHeight;

    self.tableView1.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-y);
    self.tableView2.frame = CGRectMake(CGRectGetMaxX(self.tableView1.frame)+space, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-y);
    self.tableView3.frame = CGRectMake(CGRectGetMaxX(self.tableView2.frame)+space, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-y);
    self.scrollView.contentSize = CGSizeMake(3*(kScreenWidth+space), 0);
}


- (void)initWithServer{
    /*请求未使用过的优惠券*/
    [self loadNewDataForUnused];
    /*请求已使用过的优惠券*/
    [self loadNewDataForUsed];
    /*请求失效的优惠券*/
    [self loadNewDataForUnvalid];
}

#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView1) {
        if (self.unusePreferences.count < K_REQUEST_PAGE_COUNT ) {
            tableView.mj_footer.hidden = YES;
        }else{
            tableView.mj_footer.hidden = NO;
        }
        if(self.unusePreferences.count > 0){
            tableView.backgroundView.hidden = YES;
        }else{
            tableView.backgroundView.hidden = NO;
        }
        return  self.unusePreferences.count;
    }else if (tableView == self.tableView2){
        if (self.usedPreferences.count < K_REQUEST_PAGE_COUNT ) {
            tableView.mj_footer.hidden = YES;
        }else{
            tableView.mj_footer.hidden = NO;
        }
        if(self.usedPreferences.count > 0){
            tableView.backgroundView.hidden = YES;
        }else{
            tableView.backgroundView.hidden = NO;
        }
        return self.usedPreferences.count;
    }else{
        if (self.unvalidPreferences.count < K_REQUEST_PAGE_COUNT ) {
            tableView.mj_footer.hidden = YES;
        }else{
            tableView.mj_footer.hidden = NO;
        }
        if(self.unvalidPreferences.count > 0){
            tableView.backgroundView.hidden = YES;
        }else{
            tableView.backgroundView.hidden = NO;
        }
        return self.unvalidPreferences.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MIPreferenceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MIPreferenceCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    XKPreferenceData *data = nil;
    //价钱
    NSMutableAttributedString *attributedString = nil;
    if (tableView == self.tableView1) {
        cell.backgroud.image = [UIImage imageNamed:@"preference_bg"];
        cell.icon.image = [UIImage imageNamed:@"preference"];
        [cell.detailBtn setTitle:@"明细" forState:UIControlStateNormal];
        [cell.detailBtn setHidden:NO];
        cell.detailBtn.layer.borderColor = [HexRGB(0xffffff, 1.0f) CGColor];
        
        data = [self.unusePreferences objectAtIndex:indexPath.row];
        
        NSString *price = [NSString stringWithFormat:@"%.2f/优惠券%.2f",data.balance.doubleValue/100.00f,data.total.doubleValue/100.00f];
        attributedString = [self getPriceAttribute:price];
        [attributedString addAttributes:@{NSForegroundColorAttributeName:HexRGB(0xffffff, 1.0f)} range:NSMakeRange(0, attributedString.length)];
        cell.validitylabel.textColor = HexRGB(0xffffff, 1.0f);
        cell.scopelabel.textColor = HexRGB(0xffffff, 1.0f);
        cell.imageView.image = [UIImage imageNamed:@"ic_p_uneffect"];
        if (data.useable == XKPreferenceUseableValid) {
            [cell.detailBtn setHidden:NO];
            [cell.imageView setHidden:YES];
        }else{
            [cell.detailBtn setHidden:YES];
            [cell.imageView setHidden:NO];
        }
    }else if (tableView == self.tableView2){
        cell.backgroud.image = [UIImage imageNamed:@"preference_bg_unvalid"];
        cell.icon.image = [UIImage imageNamed:@"preference_unvalid"];
        [cell.detailBtn setHidden:YES];
        
        data = [self.usedPreferences objectAtIndex:indexPath.row];
        NSString *price = [NSString stringWithFormat:@"%.2f/优惠券%.2f",data.balance.doubleValue/100.00f,data.total.doubleValue/100.00f];
        attributedString = [self getPriceAttribute:price];
        [attributedString addAttributes:@{NSForegroundColorAttributeName:HexRGB(0x999999, 1.0f)} range:NSMakeRange(0, attributedString.length)];
        cell.validitylabel.textColor = HexRGB(0x999999, 1.0f);
        cell.scopelabel.textColor = HexRGB(0x999999, 1.0f);
        [cell.imageView setHidden:NO];
        cell.imageView.image = [UIImage imageNamed:@"ic_p_used"];
    }else{
        cell.backgroud.image = [UIImage imageNamed:@"preference_bg_unvalid"];
        cell.icon.image = [UIImage imageNamed:@"preference_unvalid"];
        [cell.detailBtn setHidden:YES];
        
        data = [self.unvalidPreferences objectAtIndex:indexPath.row];
        NSString *price = [NSString stringWithFormat:@"%.2f/优惠券%.2f",data.balance.doubleValue/100.00f,data.total.doubleValue/100.00f];
        attributedString = [self getPriceAttribute:price];
        [attributedString addAttributes:@{NSForegroundColorAttributeName:HexRGB(0x999999, 1.0f)} range:NSMakeRange(0, attributedString.length)];
        cell.validitylabel.textColor = HexRGB(0x999999, 1.0f);
        cell.scopelabel.textColor = HexRGB(0x999999, 1.0f);
        [cell.imageView setHidden:NO];
        cell.imageView.image = [UIImage imageNamed:@"ic_p_unvalid"];
    }
    cell.pricelabel.attributedText = attributedString;
    //有效期
    NSString *startTime = [self changeDateFormatter:[data.startTime substringToIndex:10]];
    NSString *endTime = [self changeDateFormatter:[data.endTime substringToIndex:10]];
    cell.validitylabel.text = [NSString stringWithFormat:@"%@-%@",startTime,endTime];
    //适用范围
    cell.scopelabel.text = @"适用范围：全球买手、0元抢、O2O";
    //cell.delegate = self;
    cell.detailBtn.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XKPreferenceData *preferenceData = nil;
    if (tableView == self.tableView1) {
         preferenceData = [self.unusePreferences objectAtIndex:indexPath.row];
    }else if (tableView == self.tableView2){
        preferenceData = [self.usedPreferences objectAtIndex:indexPath.row];
    }else{
        preferenceData = [self.unvalidPreferences objectAtIndex:indexPath.row];
    }
    if (preferenceData == nil) return;
    if (preferenceData.useable != XKPreferenceUseableValid) return;
    
    MIPreferenceDetailVC *controller = [[MIPreferenceDetailVC alloc] initWithPreferenceData:preferenceData];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.scrollView != scrollView)return;
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (page < 0 || page > 2) return;
    if (page != curPage) {
        curPage = page;
        NSLog(@">>>>>-%d",page);
        [self.segmentView setIndex:page];
    }
}


- (void)segmentView:(XKSegmentView *)segmentView selectIndex:(NSUInteger)index{
    [self.scrollView setContentOffset:CGPointMake(index*CGRectGetWidth(self.scrollView.frame), 0) animated:YES];
}



#pragma mark 网络请求数据
//下拉刷新数据
- (void)loadNewDataForUnused{
    [self loadDataForPrefrenceState:XKPreferenceStateUnused update:YES];
}

//上拉加载更多数据
- (void)loadMoreDataForUnused{
   [self loadDataForPrefrenceState:XKPreferenceStateUnused update:NO];
}

//下拉刷新数据
- (void)loadNewDataForUsed{
    [self loadDataForPrefrenceState:XKPreferenceStateUsed update:YES];
}

//上拉加载更多数据
- (void)loadMoreDataForUsed{
    [self loadDataForPrefrenceState:XKPreferenceStateUsed update:NO];
}

//下拉刷新数据
- (void)loadNewDataForUnvalid{
    [self loadDataForPrefrenceState:XKPreferenceStateUnvalid update:YES];
}

//上拉加载更多数据
- (void)loadMoreDataForUnvalid{
    [self loadDataForPrefrenceState:XKPreferenceStateUnvalid update:NO];
}

//请求网络数据
- (void)loadDataForPrefrenceState:(XKPreferenceState)state update:(BOOL)isUpdate{
    XKPrefrenceParams *params = [[XKPrefrenceParams alloc] init];
    params.userId = [[[XKAccountManager defaultManager] account] userId];
    params.limit = @10;//一次拉取数据限制为10条
    if (isUpdate) {
        params.page = @1;
    }else{
        if (state == XKPreferenceStateUnused) {
             params.page = @(_curPageForUnusePreference+1);
        }else if (state == XKPreferenceStateUsed){
             params.page = @(_curPageForUsedPreference+1);
        }else{
             params.page = @(_curPageForUnvalidPreference+1);
        }
    }
    @weakify(self);
    [[XKFDataService() propertyService] getPreferenceWithParams:params prefrenceState:state completion:^(XKPreferenceResponse * _Nonnull response) {
        @strongify(self);
        void (^responseBlock)(UITableView *tableVeiw,NSMutableArray<XKPreferenceData *> *preferences,int *page) = ^(UITableView *tableView,NSMutableArray<XKPreferenceData *> *preferences,int *page){
            if(self == nil)return;
            if (isUpdate) {
                [tableView.mj_header endRefreshing];
            }
            if ([response isSuccess]) {
                NSArray *result = response.data.result;
                //刷新数据时，需要清理旧的数据
                if(result.count > 0) {
                    if (isUpdate){
                        [preferences removeAllObjects];
                        *page = 1;
                    }else{//上拉 获取 page+1页数据
                        *page+=1;
                    }
                    [preferences addObjectsFromArray:result];
                    [tableView reloadData];
                }
                if (result.count < K_REQUEST_PAGE_COUNT ) {
                    [tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [tableView.mj_footer endRefreshing];
                }
            }else{
                if(!isUpdate){
                    [tableView.mj_footer endRefreshing];
                }
                [response showError];
            }
        };
        if(self == nil)return;
        if (state == XKPreferenceStateUnused) {
            responseBlock(self.tableView1,self.unusePreferences,&(self->_curPageForUnusePreference));
        }else if (state == XKPreferenceStateUsed){
            responseBlock(self.tableView2,self.usedPreferences,&(self->_curPageForUsedPreference));
        }else{
            responseBlock(self.tableView3,self.unvalidPreferences,&(self->_curPageForUnvalidPreference));
        }
    }];
}

- (void)queryTotalTickets{
    NSString *userId = [[XKAccountManager defaultManager] userId];
    [[XKFDataService() propertyService] getTicketTotalWithUserId:userId completion:^(XKTicketTotalResponse * _Nonnull response) {
        if (response.isSuccess) {
            self.totalLabel.text = [NSString stringWithFormat:@"优惠券总额：%.2f元\t可用优惠券：%.2f元",response.data.couponSumNum/100.00f,response.data.couponUsableSumNum/100.00f];
        }
    }];
}


#pragma mark 私有方法
//富文本
-(NSMutableAttributedString *)getPriceAttribute:(NSString *)string{
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:string];
    //目的是想改变 ‘/’前面的字体的属性，所以找到目标的range
    NSRange range = [string rangeOfString:@"/"];
    
    if (IS_IPHONE_MIN) {
        [attribut addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0, range.location)];
        [attribut addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:8.0f] range:NSMakeRange(range.location,string.length-range.location)];
    }else{
        [attribut addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f] range:NSMakeRange(0, range.location)];
        [attribut addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:NSMakeRange(range.location,string.length-range.location)];
    }
   
    
    return attribut;
}

//转换日期格式
- (NSString *)changeDateFormatter :(NSString *)stringDate {
    // 实例化NSDateFormatter
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    // 设置日期格式
    [formatter1 setDateFormat:@"yyyy-MM-dd"];//yyyy-MM-dd HH:mm:ss
    // NSDate形式的日期
    NSDate *date =[formatter1 dateFromString:stringDate];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"yyyy/MM/dd"];
    NSString *dateString2 = [formatter2 stringFromDate:date];
    NSLog(@"%@",dateString2);
    return dateString2;
}


#pragma mark getter or setter 函数

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.directionalLockEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (UITableView *)tableView1{
    if (!_tableView1) {
        _tableView1 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView1.delegate = self;
        _tableView1.dataSource = self;
        _tableView1.rowHeight = 130;
        _tableView1.backgroundColor = HexRGB(0xffffff, 1.0f);
        _tableView1.separatorColor = [UIColor clearColor];
        _tableView1.showsVerticalScrollIndicator = NO;
        _tableView1.sectionFooterHeight = 0.0f;
        _tableView1.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    }
    return _tableView1;
}

- (UITableView *)tableView2{
    if (!_tableView2) {
        _tableView2 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView2.delegate = self;
        _tableView2.dataSource = self;
        _tableView2.rowHeight = 130.0f;
        _tableView2.backgroundColor = HexRGB(0xffffff, 1.0f);
        _tableView2.separatorColor = [UIColor clearColor];
        _tableView2.showsVerticalScrollIndicator = NO;
        _tableView2.sectionFooterHeight = 0.0f;
        _tableView2.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    }
    return _tableView2;
}

- (UITableView *)tableView3{
    if (!_tableView3) {
        _tableView3 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView3.delegate = self;
        _tableView3.dataSource = self;
        
        _tableView3.rowHeight = 130;
        _tableView3.backgroundColor = HexRGB(0xffffff, 1.0f);
        _tableView3.separatorColor = [UIColor clearColor];
        _tableView3.showsVerticalScrollIndicator = NO;
        _tableView3.sectionFooterHeight = 0.0f;
        _tableView3.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    }
    return _tableView3;
}


- (XKSegmentView *)segmentView{
    if (!_segmentView) {
        _segmentView = [[XKSegmentView alloc] initWithTitles:@[@"可使用",@"已使用",@"已失效"]];
        _segmentView.style = XKSegmentViewStyleDivide;
        _segmentView.backgroundColor = HexRGB(0xffffff, 1.0f);
        _segmentView.delegate = self;
    }
    return _segmentView;
}

- (NSMutableArray *)unusePreferences{
    if (!_unusePreferences) {
        _unusePreferences = [NSMutableArray array];
    }
    return _unusePreferences;
}

- (NSMutableArray *)usedPreferences{
    if (!_usedPreferences) {
        _usedPreferences = [NSMutableArray array];
    }
    return _usedPreferences;
}


- (NSMutableArray *)unvalidPreferences{
    if (!_unvalidPreferences) {
        _unvalidPreferences = [NSMutableArray array];
    }
    return _unvalidPreferences;
}

- (UILabel *)totalLabel{
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.textColor = HexRGB(0xFF4057, 1.0f);
        _totalLabel.font = [UIFont systemFontOfSize:11.0f];
        _totalLabel.text = @"优惠券总额：0.00元\t可用优惠券：0.00元";
    }
    return _totalLabel;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = HexRGB(0xFFF5E0, 1.0f);
    }
    return _topView;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youhuiquan-3"]];
    }
    return _icon;
}

@end

