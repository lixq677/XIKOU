//
//  CTDesignerWorksVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/26.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "CTDesignerWorksVC.h"
#import "XKUIUnitls.h"
#import "CTBaseCell.h"
#import "XKBannerView.h"
#import "XKInputView.h"
#import <AFViewShaker.h>
#import <SDWebImage.h>
#import "MJDIYFooter.h"
#import "NSDate+Extension.h"
#import "XKDesignerService.h"
#import "XKAccountManager.h"
#import "XKDataService.h"
#import "XKUserService.h"

static const int kPageCount =   20;

@interface CTDesignerWorksVC ()<UITableViewDelegate,UITableViewDataSource,XKBannerViewDelegate,XKInputViewDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UIView *toolBar;
@property (nonatomic,strong)UIButton *writeCommentBtn;
@property (nonatomic,strong)UIImageView *writeCommentImageView;
@property (nonatomic,strong)UILabel *writeCommentLabel;
@property (nonatomic,strong)UIButton *commentsBtn;
@property (nonatomic,strong)UIButton *thumbsupBtn;

@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)XKBannerView *bannerView;
@property (nonatomic,strong)UILabel *countLabel;
@property (nonatomic,strong)UIButton *concernBtn;
@property (nonatomic,strong)UIImageView *headerIcon;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UILabel *worksLabel;
@property (nonatomic,strong)UILabel *signatureLabel;

@property (nonatomic,strong)UIView *footerView;
@property (nonatomic,strong)UILabel *commentHintLabel;

@property (nonatomic,strong)UIView *topLine;

@property (nonatomic,strong)UILabel *commentLabel;

@property (nonatomic,strong)XKInputView *inputView;

@property (nonatomic,strong,readonly)XKDesignerWorkData *workData;

@property (nonatomic,strong,readonly)NSMutableArray<XKDesignerCommentVoModel *> *commentsArray;

@property (nonatomic,assign)NSUInteger curPage;
@end

@implementation CTDesignerWorksVC
@synthesize tableView = _tableView;
@synthesize toolBar = _toolBar;
@synthesize workData = _workData;
@synthesize commentsArray = _commentsArray;

- (instancetype)initWithWorkData:(XKDesignerWorkData *)workData{
    if (self = [super init]) {
        _workData = [workData copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.extendedLayoutIncludesOpaqueBars = YES;
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    [self setupUI];
    [self autoLayout];
    [self addObserver];
    [self setupWithWorkData:self.workData];
    self.tableView.mj_footer = [MJDIYFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self loadNewData];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGFloat height = CGRectGetHeight(self.bannerView.frame)-kNavBarHeight;
    if (self.tableView.contentOffset.y > height) {
        if (self.navigationBarStyle != XKNavigationBarStyleDefault) {
            self.navigationBarStyle = XKNavigationBarStyleDefault;
        }
    }else{
        if (self.navigationBarStyle != XKNavigationBarStyleTranslucent) {
            self.navigationBarStyle = XKNavigationBarStyleTranslucent;
        }
    }
}


- (void)dealloc{
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:NO];
    [self removeObserver];
}

- (void)setupUI{
    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"diandian"] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:self.bannerView];
    [self.bannerView addSubview:self.countLabel];
    [self.headerView addSubview:self.headerIcon];
    [self.headerView addSubview:self.nameLabel];
    [self.headerView addSubview:self.timeLabel];
    [self.headerView addSubview:self.concernBtn];
    [self.headerView addSubview:self.worksLabel];
    [self.headerView addSubview:self.signatureLabel];
    [self.headerView addSubview:self.topLine];
    [self.headerView addSubview:self.commentLabel];
    [self.footerView addSubview:self.commentHintLabel];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    self.tableView.backgroundColor = HexRGB(0xffffff, 1.0f);
    [self.tableView registerClass:[CTCommentsCell class] forCellReuseIdentifier:@"CTCommentsCell"];
    
    
    [self.view addSubview:self.toolBar];
    [self.toolBar addSubview:self.writeCommentBtn];
    [self.writeCommentBtn addSubview:self.writeCommentImageView];
    [self.writeCommentBtn addSubview:self.writeCommentLabel];
    [self.toolBar addSubview:self.commentsBtn];
    [self.toolBar addSubview:self.thumbsupBtn];
    
    [self.view addSubview:self.inputView];
    
    [self.concernBtn addTarget:self action:@selector(concernAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentsBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.writeCommentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)autoLayout{
    /*tool bar 布局*/
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(60.0f);
        make.bottom.equalTo(self.view).offset(-[XKUIUnitls safeBottom]);
    }];
    [self.thumbsupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.toolBar.mas_right).offset(-20.0f);
        make.height.mas_equalTo(16.0f);
        make.width.mas_equalTo(55.0f);
        make.centerY.equalTo(self.toolBar);
    }];
    
    [self.commentsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.thumbsupBtn.mas_left).offset(-45.0f);
        make.bottom.top.equalTo(self.thumbsupBtn);
        make.width.mas_equalTo(60.0f);
    }];
    [self.writeCommentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(self.commentsBtn.mas_left).offset(-23.0f);
        make.centerY.equalTo(self.toolBar);
        make.height.mas_equalTo(35.0f);
    }];
    
    [self.writeCommentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.width.height.mas_equalTo(14.0f);
        make.centerY.equalTo(self.writeCommentBtn);
    }];
    
    [self.writeCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.writeCommentImageView.mas_right).offset(4.0f);
        make.height.mas_equalTo(14.0f);
        make.centerY.equalTo(self.writeCommentBtn);
    }];
    
    /*布局tableView*/
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.mas_equalTo(self.toolBar.mas_top);
    }];
    
    /*布局headerView*/
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.headerView);
        make.height.mas_equalTo(scalef(kScreenWidth));
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50.0f);
        make.height.mas_equalTo(25.0f);
        make.bottom.equalTo(self.bannerView).offset(-18.0f);
        make.right.equalTo(self.bannerView).offset(-20.0f);
    }];
    
    [self.headerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.top.mas_equalTo(self.bannerView.mas_bottom).offset(20.0f);
        make.width.height.mas_equalTo(40.0f);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerIcon.mas_right).offset(10.0f);
        make.top.equalTo(self.headerIcon).offset(5.0f);
        make.height.mas_equalTo(14.0f);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(6.0f);
        make.height.mas_equalTo(12.0f);
    }];
    [self.concernBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(70.0f);
        make.height.mas_equalTo(29.0f);
        make.top.mas_equalTo(self.bannerView.mas_bottom).offset(26.0f);
        make.right.mas_equalTo(self.headerView.mas_right).offset(-20.0f);
    }];
    [self.worksLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIcon);
        make.right.equalTo(self.concernBtn);
        make.height.mas_equalTo(15.0f);
        make.top.mas_equalTo(self.headerIcon.mas_bottom).offset(26.0f);
    }];
    [self.signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.worksLabel);
        make.top.mas_equalTo(self.worksLabel.mas_bottom).offset(11.0f);
    }];
    
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.signatureLabel);
        make.top.mas_equalTo(self.signatureLabel.mas_bottom).offset(11.0f);
        make.height.mas_equalTo(0.5f);
    }];
    
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topLine);
        make.top.mas_equalTo(self.topLine.mas_bottom).offset(25.0f);
        make.height.mas_equalTo(15.0f);
        make.bottom.equalTo(self.headerView).offset(-11.0f);
    }];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view.width);
    }];
    self.inputView.y = CGRectGetMaxY(self.view.bounds);
}

#pragma mark tableView data source or delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.commentsArray.count < kPageCount) {
        tableView.mj_footer.hidden = YES;
    }else{
        tableView.mj_footer.hidden = NO;
    }
    if (self.commentsArray.count == 0) {
        self.tableView.tableFooterView.hidden = NO;
    }else{
        self.tableView.tableFooterView.hidden = YES;
    }
    return self.commentsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CTCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CTCommentsCell" forIndexPath:indexPath];
    XKDesignerCommentVoModel *result = [self.commentsArray objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:result.headUrl]];
    cell.nameLabel.text = result.userName;
    cell.timeLabel.text = result.commentTime;
    cell.textLabel.text = result.commentContent;
    if([NSString isNull:result.replayContent]){
        cell.detailTextLabel.text = nil;
    }else{
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@回复:%@",result.name,result.replayContent];
    }
    cell.separatorInset = UIEdgeInsetsMake(0, 60.0f, 0, 0);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat height = CGRectGetHeight(self.bannerView.frame)-kNavBarHeight;
    if (scrollView.contentOffset.y > height) {
        if (self.navigationBarStyle != XKNavigationBarStyleDefault) {
            self.navigationBarStyle = XKNavigationBarStyleDefault;
        }
        self.title = self.workData.workName;
    }else if (scrollView.contentOffset.y + 80 > height){
        self.navigationController.navigationBar.translucent = YES;
        CGFloat alpha = (scrollView.contentOffset.y + 80.0f - height)/80.0f;
        alpha = alpha > 1.0f ? 1.0f :alpha;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:HexRGB(0xffffff, alpha)] forBarMetrics:UIBarMetricsDefault];
    }else{
        if (self.navigationBarStyle != XKNavigationBarStyleTranslucent) {
            self.navigationBarStyle = XKNavigationBarStyleTranslucent;
        }
        self.title = nil;
    }
    if (scrollView.contentOffset.y<0) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
    }
}


#pragma mark banner delegate

- (void)bannerView:(XKBannerView *)bannerView currentPage:(NSInteger)currentPage{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d/%d",(int)currentPage+1,(int)bannerView.pageCount] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSForegroundColorAttributeName:HexRGB(0xffffff, 1.0f)}];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17.0f] range:NSMakeRange(0, 1)];
    self.countLabel.attributedText = attributeString;
}


- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
};

- (void)removeObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark 私有，数据初始化界面
- (void)setupWithWorkData:(XKDesignerWorkData *)data{
    NSMutableArray <NSString *> *urls = [NSMutableArray arrayWithCapacity:data.imageList.count];
    [data.imageList enumerateObjectsUsingBlock:^(XKDesignerWorkImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [urls addObject:obj.imageUrl];
    }];
    self.bannerView.dataSource = urls;
    [self.headerIcon sd_setImageWithURL:[NSURL URLWithString:data.headUrl] placeholderImage:[UIImage imageNamed:@"touxiang"] options:SDWebImageAvoidDecodeImage];
    self.nameLabel.text = data.pageName;
    self.timeLabel.text = data.showTime;
    self.worksLabel.text = data.workName;
    self.signatureLabel.text = data.desc;
    [self.commentsBtn setTitle:[data.commentCnt stringValue] forState:UIControlStateNormal];
    [self.thumbsupBtn setTitle:[data.fabulousCnt stringValue] forState:UIControlStateNormal];
    [self.thumbsupBtn setSelected:data.isPraise.boolValue];
    if ([data.isFollow boolValue]) {//已关注
        [self setupUnconcern];
    }else{
        [self setupConcern];
    }
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"1/%d",(int)self.bannerView.pageCount] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSForegroundColorAttributeName:HexRGB(0xffffff, 1.0f)}];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17.0f] range:NSMakeRange(0, 1)];
    self.countLabel.attributedText = attributeString;
    [self.tableView layoutIfNeeded];
}

- (void)setupConcern{
    self.concernBtn.selected = NO;
    [self.concernBtn setImage:[UIImage imageNamed:@"custom_add_bt"] forState:UIControlStateNormal];
    self.concernBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
}

- (void)setupUnconcern{
    self.concernBtn.selected = YES;
    [self.concernBtn setImage:nil forState:UIControlStateNormal];
    self.concernBtn.titleEdgeInsets = UIEdgeInsetsZero;
}

#pragma mark input delegate
- (void)inputView:(XKInputView *)inputView sendMessage:(NSString *)message{
    NSLog(@"发送评论：%@",message);
    if ([NSString isNull:message]) {
        AFViewShaker *viewShaker =  [[AFViewShaker alloc] initWithView:inputView.textView];
        [viewShaker shake];
        return;
    }
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self commentWithMsg:message];
}



- (void)loadNewData{
    [self loadDataForUpdate:YES];
}

- (void)loadMoreData{
    [self loadDataForUpdate:NO];
}

- (void)loadDataForUpdate:(BOOL)update{
    NSUInteger page = 1;
    if (!update) {
        page = self.curPage + 1;
    }
    XKDesignerCommentsRequestParams *params = [[XKDesignerCommentsRequestParams alloc] init];
    params.workId = self.workData.id;
    params.designerId = self.workData.designerId;
    params.page = @(page);
    params.limit = @(kPageCount);
    //[XKLoading show];
    @weakify(self);
    [[XKFDataService() designerService] queryDesignerCommentsWithParams:params completion:^(XKDesignerCommentResponse * _Nonnull response) {
        @strongify(self);
        //[XKLoading dismiss];
        if (update) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([response isSuccess]) {
            NSArray<XKDesignerCommentVoModel *> *results = response.data.result;
            //刷新数据时，需要清理旧的数据
            if (update) {
                [self.commentsArray removeAllObjects];
            }
            self.curPage = page;
            [self.commentsArray addObjectsFromArray:results];
            [self.tableView reloadData];
            if (results.count < kPageCount) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }else{
            if(!update){
                [self.tableView.mj_footer endRefreshing];
            }
            [response showError];
        }
    }];
}

- (void)commentWithMsg:(NSString *)msg{
    if (NO == [[XKAccountManager defaultManager] isLogin]) {
        [MGJRouter openURL:kRouterLogin];
        return;
    }
    NSString *userId = [[[XKAccountManager defaultManager] account] userId];
    
    XKUserInfoData *infoData = [[XKFDataService() userService] queryUserInfoFromCacheWithId:userId];
    XKDesignerCommentVoModel *voModel = [[XKDesignerCommentVoModel alloc] init];
    voModel.commentContent = msg;
    voModel.userId = userId;
    voModel.userName = infoData.nickName;
    voModel.headUrl = infoData.headUrl;
    voModel.designerId = self.workData.designerId;
    voModel.workId = self.workData.id;
    voModel.commentTime = [[NSDate date] stringWithFormater_CStyle:@"%Y-%m-%d %H:%M:%S"];
    [[XKFDataService() designerService] commentWithVoModel:voModel completion:^(XKBaseResponse * _Nonnull response) {
        if (response.isSuccess) {
            [self.commentsArray insertObject:voModel atIndex:0];
            [self.tableView reloadData];
            [self.tableView layoutIfNeeded];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }else{
            [response showError];
        }
    }];
}

- (void)requestConcernFromServer{
    if ([[XKAccountManager defaultManager] isLogin] == NO) {
        [MGJRouter openURL:kRouterLogin];
        return;
    }
    XKDesignerFollowVoParams *params = [[XKDesignerFollowVoParams alloc] init];
    params.designerId = self.workData.designerId;
    params.userId = [[[XKAccountManager defaultManager] account] userId];
    params.follow = ![self.workData.isFollow boolValue];
    self.concernBtn.enabled = NO;
    [XKLoading show];
    @weakify(self);
    [[XKFDataService() designerService] setConcernDesignerWithParams:params completion:^(XKBaseResponse * _Nonnull response) {
        @strongify(self);
        [XKLoading dismiss];
        self.concernBtn.enabled = YES;
        if (response.isSuccess) {
            self.workData.isFollow = @(!self.workData.isFollow.boolValue);
            if (params.follow) {
                [self setupUnconcern];
            }else{
                [self setupConcern];
            }
        }else{
            [response showError];
        }
    }];
}



#pragma mark action
- (void)concernAction:(id)sender{
    [self requestConcernFromServer];
}

- (void)commentAction:(id)sender{
    if (NO == [[XKAccountManager defaultManager] isLogin]) {
        [MGJRouter openURL:kRouterLogin];
        return;
    }
    [[self.inputView textView] becomeFirstResponder];
}

- (void)thumbsupAction:(id)sender{
    if ([[XKAccountManager defaultManager] isLogin] == NO) {
        [MGJRouter openURL:kRouterLogin];
        return;
    }
    XKDesignerFollowVoParams *params = [[XKDesignerFollowVoParams alloc] init];
    params.designerId = self.workData.designerId;
    params.workId = self.workData.id;
    params.userId = [[[XKAccountManager defaultManager] account] userId];
    params.praise = ![self.workData.isPraise boolValue];
    self.thumbsupBtn.enabled = NO;
    @weakify(self);
    [[XKFDataService() designerService] setThumbupDesignerWithParams:params completion:^(XKBaseResponse * _Nonnull response) {
        @strongify(self);
        self.thumbsupBtn.enabled = YES;
        if (response.isSuccess) {
            self.workData.isPraise = @(params.praise);
            if (params.praise) {
                self.workData.fabulousCnt =  @(self.workData.fabulousCnt.integerValue + 1);
                self.thumbsupBtn.selected = YES;
            }else{
                self.workData.fabulousCnt =  @(self.workData.fabulousCnt.integerValue - 1);
                self.thumbsupBtn.selected = NO;
            }
            [self.thumbsupBtn setTitle:[self.workData.fabulousCnt stringValue] forState:UIControlStateNormal];
        }else{
            [response showError];
        }
    }];
}

- (void)shareAction:(id)sender{
    
}

//输入键盘显示
- (void)inputKeyboardWillShow:(NSNotification *)notif{
    NSDictionary * info = [notif userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGRect keyboardFrame = [self.view convertRect:[aValue CGRectValue] fromView:window];
    [UIView animateWithDuration:0.3f animations:^{
        self.inputView.bottom = CGRectGetMinY(keyboardFrame);
    }];
}

//输入键盘隐藏
- (void)inputKeyboardWillHide:(NSNotification *)notif{
    [UIView animateWithDuration:0.3 animations:^{
        self.inputView.y = CGRectGetMaxY(self.view.bounds);
    }];
}

- (void)inputKeyboardWillChangeFrame:(NSNotification *)notif{
    NSDictionary * info = [notif userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGRect keyboardFrame = [self.view convertRect:[aValue CGRectValue] fromView:window];
    [UIView animateWithDuration:0.3f animations:^{
        self.inputView.bottom = CGRectGetMinY(keyboardFrame) - [XKUIUnitls safeBottom];
    }];
}



#pragma mark getter or setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 250.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = COLOR_VIEW_GRAY;
        _tableView.separatorColor = HexRGB(0xe4e4e4, 1.0f);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.sectionFooterHeight = 0.0f;
    }
    return _tableView;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = HexRGB(0xffffff, 1.0f);
    }
    return _headerView;
}

- (UIView *)toolBar{
    if (!_toolBar) {
        _toolBar = [[UIView alloc] init];
        _toolBar.backgroundColor = [UIColor whiteColor];
    }
    return _toolBar;
}

- (UIButton *)writeCommentBtn{
    if(!_writeCommentBtn){
        _writeCommentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _writeCommentBtn.backgroundColor = COLOR_VIEW_GRAY;
        _writeCommentBtn.layer.cornerRadius = 2.0f;
    }
    return _writeCommentBtn;
}

- (UIImageView *)writeCommentImageView{
    if(!_writeCommentImageView){
        _writeCommentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pencil"]];
    }
    return _writeCommentImageView;
}

- (UILabel *)writeCommentLabel{
    if (!_writeCommentLabel) {
        _writeCommentLabel = [[UILabel alloc] init];
        _writeCommentLabel.text = @"写评价...";
        _writeCommentLabel.font = [UIFont systemFontOfSize:14.0f];
        _writeCommentLabel.textColor = HexRGB(0x999999, 1.0f);
    }
    return _writeCommentLabel;
}

- (UIButton *)commentsBtn{
    if (!_commentsBtn) {
        _commentsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentsBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [_commentsBtn setTitleColor:HexRGB(0x999999, 1.0f) forState:UIControlStateNormal];
        [[_commentsBtn titleLabel] setFont:[UIFont systemFontOfSize:12.0f]];
        _commentsBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [_commentsBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentsBtn;
}

- (UIButton *)thumbsupBtn{
    if (!_thumbsupBtn) {
        _thumbsupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_thumbsupBtn setImage:[UIImage imageNamed:@"thumb"] forState:UIControlStateNormal];
        [_thumbsupBtn setImage:[UIImage imageNamed:@"thumb_up"] forState:UIControlStateSelected];
        [_thumbsupBtn setTitleColor:HexRGB(0x999999, 1.0f) forState:UIControlStateNormal];
        [[_thumbsupBtn titleLabel] setFont:[UIFont systemFontOfSize:12.0f]];
        _thumbsupBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [_thumbsupBtn addTarget:self action:@selector(thumbsupAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _thumbsupBtn;
}

- (XKBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[XKBannerView alloc] init];
        _bannerView.delegate = self;
        _bannerView.needPageControl = NO;
    }
    return _bannerView;
}

- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = HexRGB(0xffffff, 1.0f);
        _countLabel.backgroundColor = HexRGB(0x0, 0.5f);
        _countLabel.layer.cornerRadius = 12.5f;
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.clipsToBounds = YES;
    }
    return _countLabel;
}


- (UIImageView *)headerIcon{
    if (!_headerIcon) {
        _headerIcon = [[UIImageView alloc] init];
        _headerIcon.layer.cornerRadius = 20.0f;
        _headerIcon.clipsToBounds = YES;
    }
    return _headerIcon;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HexRGB(0x444444, 1.0f);
        _nameLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = HexRGB(0x999999, 1.0f);
        _timeLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _timeLabel;
}

- (UILabel *)worksLabel{
    if (!_worksLabel) {
        _worksLabel = [[UILabel alloc] init];
        _worksLabel.textColor = HexRGB(0x444444, 1.0f);
        _worksLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _worksLabel;
}

- (UILabel *)signatureLabel{
    if (!_signatureLabel) {
        _signatureLabel = [[UILabel alloc] init];
        _signatureLabel.textColor = HexRGB(0x999999, 1.0f);
        _signatureLabel.font = [UIFont systemFontOfSize:12.0f];
        _signatureLabel.numberOfLines = 0;
    }
    return _signatureLabel;
}

- (UIButton *)concernBtn{
    if (!_concernBtn) {
        _concernBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _concernBtn.layer.borderColor = [COLOR_TEXT_BROWN CGColor];
        [_concernBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_concernBtn setTitleColor:COLOR_TEXT_BROWN forState:UIControlStateNormal];
        [_concernBtn setImage:[UIImage imageNamed:@"custom_add_bt"] forState:UIControlStateNormal];
        
        [_concernBtn setTitle:@"取消关注" forState:UIControlStateSelected];
        [_concernBtn setTitleColor:HexRGB(0x444444, 1.0f) forState:UIControlStateSelected];
        [[_concernBtn titleLabel] setFont:[UIFont systemFontOfSize:12.0f]];
        _concernBtn.layer.cornerRadius = 14.5f;
        _concernBtn.layer.borderWidth = 1.0f;
        _concernBtn.clipsToBounds = YES;
        
    }
    return _concernBtn;
}


- (UIView *)topLine{
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = HexRGB(0xe4e4e4, 1.0f);
    }
    return _topLine;
}

- (UILabel *)commentLabel{
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.text = @"评价";
        _commentLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    }
    return _commentLabel;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30.0f)];
    }
    return _footerView;
}

- (UILabel *)commentHintLabel{
    if (!_commentHintLabel) {
        _commentHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30.0f)];
        _commentHintLabel.text = @"快来发表你的评论吧";
        _commentHintLabel.textColor = HexRGB(0x999999, 1.0f);
        _commentHintLabel.font = [UIFont systemFontOfSize:12.0f];
        _commentHintLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _commentHintLabel;
}

- (XKInputView *)inputView{
    if (!_inputView) {
        _inputView = [[XKInputView alloc] initWithDelegate:self];
    }
    return _inputView;
}

- (NSMutableArray<XKDesignerCommentVoModel *> *)commentsArray{
    if (!_commentsArray) {
        _commentsArray = [NSMutableArray array];
    }
    return _commentsArray;
}

@end
