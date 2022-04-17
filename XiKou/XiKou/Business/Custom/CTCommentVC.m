//
//  CTCommentVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/18.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "CTCommentVC.h"
#import "XKInputView.h"
#import "XKUIUnitls.h"
#import <AFViewShaker.h>
#import "CTBaseCell.h"
#import "XKDataService.h"
#import <SDWebImage.h>
#import "MJDIYFooter.h"
#import "NSDate+Extension.h"
#import "XKDesignerService.h"
#import "XKUserService.h"

#define kSheetWidth (kScreenWidth)

#define kSheetHeight (460.0f+[XKUIUnitls safeBottom])

static const int kPageCount =   20;

@interface CTCommentVC ()
<XKInputViewDelegate,
UITableViewDataSource,
UITableViewDelegate,
CTCommentsCellDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UIButton *dissBtn;

@property (nonatomic,strong)XKInputView *inputView;

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UILabel *hintLabel;

@property (nonatomic,strong)UIView *topLine;

@property (nonatomic,strong)UIView *sheetView;

@property (nonatomic,strong)UIView *backgroundView;

@property (nonatomic,strong)XKLoading *loading;

@property (nonatomic,strong)NSNumber *totalCount;//评论总条数

@property (nonatomic,strong,readonly)NSMutableArray<XKDesignerCommentVoModel *> *commentsArray;

@property (nonatomic,assign)NSUInteger curPage;

//@property (nonatomic,strong)NSMutableDictionary<NSString *,XKDesignerCommentParams *> *paramsDict;

@end

@implementation CTCommentVC
@synthesize commentsArray = _commentsArray;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setup];
    [self autoLayout];
    [self addObserver];
    self.inputView.bottom = kSheetHeight - [XKUIUnitls safeBottom];
    self.tableView.mj_footer = [MJDIYFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)dealloc{
    [self removeObserver];
}

- (void)setup{
    [self.sheetView addSubview:self.titleLabel];
    [self.sheetView addSubview:self.dissBtn];
    [self.sheetView addSubview:self.topLine];
    [self.sheetView addSubview:self.tableView];
    [self.sheetView addSubview:self.inputView];
    [self.sheetView addSubview:self.hintLabel];
    [self.sheetView addSubview:self.loading];
    self.sheetView.backgroundColor = HexRGB(0xffffff, 1.0f);
    [self.dissBtn setImage:[UIImage imageNamed:@"custom_dissmiss"] forState:UIControlStateNormal];
    [self.dissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView registerClass:[CTCommentsCell class] forCellReuseIdentifier:@"CTCommentsCell"];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSheetWidth, 300)];
    UILabel *label = [[UILabel alloc] init];
    
    label.text = @"快来发表你的评论吧";
    label.textColor = HexRGB(0x999999, 1.0f);
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textAlignment = NSTextAlignmentCenter;
    [backgroundView addSubview:label];
    [label sizeToFit];
    label.centerX = 0.5*kSheetWidth;
    label.top = 200.0f;
    self.tableView.backgroundView = backgroundView;
    
}

- (void)autoLayout{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200.0f);
        make.centerX.equalTo(self.sheetView);
        make.height.mas_equalTo(45.0f);
        make.top.mas_equalTo(0.0f);
    }];
    [self.dissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30.0f);
        make.top.mas_equalTo(7.5f);
        make.right.equalTo(self.sheetView).offset(-20.0f);
    }];
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.right.equalTo(self.sheetView).offset(-20.0f);
        make.height.mas_equalTo(0.5f);
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.sheetView);
        make.bottom.equalTo(self.sheetView).offset(-60.0f-[XKUIUnitls safeBottom]);
        make.top.mas_equalTo(self.topLine.mas_bottom);
    }];
    [self.loading mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30.0f);
        make.centerX.centerY.equalTo(self.sheetView);
    }];
}

- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
};

- (void)removeObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//输入键盘显示
- (void)inputKeyboardWillShow:(NSNotification *)notif{
    NSDictionary * info = [notif userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGRect keyboardFrame = [self.sheetView convertRect:[aValue CGRectValue] fromView:window];
    [UIView animateWithDuration:0.3f animations:^{
        self.inputView.bottom = CGRectGetMinY(keyboardFrame);
    }];
}

//输入键盘隐藏
- (void)inputKeyboardWillHide:(NSNotification *)notif{
    [UIView animateWithDuration:0.3 animations:^{
        self.inputView.bottom = CGRectGetMaxY(self.sheetView.bounds) - [XKUIUnitls safeBottom];
    }];
}

- (void)inputKeyboardWillChangeFrame:(NSNotification *)notif{
    NSDictionary * info = [notif userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGRect keyboardFrame = [self.sheetView convertRect:[aValue CGRectValue] fromView:window];
    [UIView animateWithDuration:0.3f animations:^{
        self.inputView.bottom = CGRectGetMinY(keyboardFrame) - [XKUIUnitls safeBottom];
    }];
}





- (void)show{
    [self refreshData];
    UIViewController *topVC = [self appRootViewController];
    self.sheetView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds), kSheetWidth, kSheetHeight);
    self.backgroundView.frame = topVC.view.bounds;
    [topVC.view addSubview:self.backgroundView];
    [topVC.view addSubview:self.sheetView];
    CGRect afterFrame = CGRectMake(0, (CGRectGetHeight(topVC.view.bounds)-kSheetHeight),kSheetWidth, kSheetHeight);
    [UIView animateWithDuration:0.2f animations:^{
         self.sheetView.frame = afterFrame;
    }];
}

- (void)dismiss{
    [self.backgroundView removeFromSuperview];
    UIViewController *topVC = [self appRootViewController];
    CGRect afterFrame = CGRectMake(0,CGRectGetHeight(topVC.view.bounds), kSheetWidth, kSheetHeight);
    [UIView animateWithDuration:0.2F animations:^{
        self.sheetView.frame = afterFrame;
    }completion:^(BOOL finished) {
        [self.sheetView removeFromSuperview];
    }];
}


- (UIViewController *)appRootViewController{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (void)tapAction{
    [self.inputView endEditing:YES];
}


- (void)scrollToBottom{
    [self.tableView layoutIfNeeded];
    CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
    if (offset.y > 0) {
        [self.tableView setContentOffset:offset animated:YES];
    }
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
        self.tableView.backgroundView.hidden = NO;
    }else{
        self.tableView.backgroundView.hidden = YES;
    }
    return self.commentsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CTCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CTCommentsCell" forIndexPath:indexPath];
    XKDesignerCommentVoModel *result = [self.commentsArray objectAtIndex:indexPath.row];
    [cell setCommentVoModel:result];
    cell.delegate = self;
    cell.separatorInset = UIEdgeInsetsMake(0, 60.0f, 0, 0);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self.inputView.textView becomeFirstResponder];
//   
//}

- (void)commentsCell:(CTCommentsCell *)cell retryAction:(id)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    XKDesignerCommentVoModel *voModel = [self.commentsArray objectAtIndex:indexPath.row];
    [self commentWithVoModel:voModel];
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
    params.workId = self.workId;
    params.designerId = self.designerId;
    params.page = @(page);
    params.limit = @(kPageCount);
    [self.loading startAnimating];
    @weakify(self);
    [[XKFDataService() designerService] queryDesignerCommentsWithParams:params completion:^(XKDesignerCommentResponse * _Nonnull response) {
        @strongify(self);
        [self.loading stopAnimating];
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
            self.titleLabel.text = [NSString stringWithFormat:@"%@条评论",response.data.totalCount];
            self.totalCount = response.data.totalCount;
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
    voModel.designerId = self.designerId;
    voModel.workId = self.workId;
    [self.commentsArray insertObject:voModel atIndex:0];
    
    [self commentWithVoModel:voModel];
}

- (void)commentWithVoModel:(XKDesignerCommentVoModel *)voModel{
    
    voModel.commentTime = [[NSDate date] stringWithFormater_CStyle:@"%Y-%m-%d %H:%M:%S"];
    
    
    if([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable){
        voModel.commentStatus = XKCommentStatusFailed;
    }else{
        voModel.commentStatus = XKCommentStatusSending;
    }
    
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    if([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable){
        XKShowToast(@"当前网络不可用");
        return;
    }
    [[XKFDataService() designerService] commentWithVoModel:voModel completion:^(XKBaseResponse * _Nonnull response) {
        if (response.isSuccess) {
            voModel.commentStatus = XKCommentStatusSuccess;
            self.totalCount = @(self.totalCount.intValue + 1);
            self.titleLabel.text = [NSString stringWithFormat:@"%@条评论",self.totalCount];
        }else{
            voModel.commentStatus = XKCommentStatusFailed;
            [response showError];
        }
        [self.tableView reloadData];
    }];
}





- (void)refreshData{
    self.totalCount = @(0);
    [self.commentsArray removeAllObjects];
    self.titleLabel.text = @"0条评论";
    [self.tableView reloadData];
    [self loadNewData];
}


#pragma mark getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 250.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = HexRGB(0xffffff, 1.0f);
        _tableView.separatorColor = HexRGB(0xe4e4e4, 1.0f);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.sectionFooterHeight = 0.0f;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UIButton *)dissBtn{
    if (!_dissBtn) {
        _dissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _dissBtn;
}

- (UILabel *)hintLabel{
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
    }
    return _hintLabel;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _titleLabel.textColor = HexRGB(0x444444, 1.0f);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)topLine{
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = HexRGB(0xe4e4e4, 1.0f);
    }
    return _topLine;
}

- (XKInputView *)inputView{
    if (!_inputView) {
        _inputView = [[XKInputView alloc] initWithDelegate:self];
        _inputView.textMaximumLength = 100;
    }
    return _inputView;
}

- (UIView *)sheetView{
    if (!_sheetView) {
        _sheetView = [[UIView alloc] init];
    }
    return _sheetView;
}

- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = HexRGB(0x0, 0.3);
        _backgroundView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_backgroundView addGestureRecognizer:gesture];
    }
    return _backgroundView;
}

- (XKLoading *)loading{
    if (!_loading) {
        _loading = [[XKLoading alloc] init];
        _loading.hidesWhenStopped = YES;
    }
    return _loading;
}

- (NSMutableArray<XKDesignerCommentVoModel *> *)commentsArray{
    if (!_commentsArray) {
        _commentsArray = [NSMutableArray array];
    }
    return _commentsArray;
}


@end
