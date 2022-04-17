//
//  ACTWgVC.m
//  XiKou
//
//  Created by 李笑清 on 2019/11/24.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTWgVC.h"
#import "XKPageController.h"
#import "XKBannerView.h"
#import "XKShareTool.h"
#import "UIBarButtonItem+Badge.h"
#import "XKActivityService.h"
#import "XKActivityCartService.h"
#import <TABAnimated.h>
#import "MJDIYHeader.h"
#import "ACTWgChildVC.h"
#import "XKGradientView.h"
#import <YYText.h>
#import "XKAccountManager.h"
#import "XKOrderService.h"

static const float kMenuHeight = 60;

#define kBackH (scalef(170)+kMenuHeight+50+200)

@interface ACTWgVC ()
<WMPageControllerDataSource,
WMPageControllerDelegate,
UIScrollViewDelegate>

@property (nonatomic,strong,readonly)UIScrollView *scrollView;

@property (nonatomic, strong) XKBannerView *bannerView;

@property (nonatomic,strong,readonly)XKGradientView *backView;

@property (nonatomic,strong,readonly)XKGradientView *navView;

@property (nonatomic, strong,readonly) XKPageController *contentController;

@property (nonatomic,assign)BOOL allowScroll;

@property (nonatomic,strong)NSArray<ACTMoudleModel *>  *models;

@property (nonatomic,strong)UIImageView *suspensionImageView;

@property (nonatomic,strong)UIImageView *suspensionIcon;

@property (nonatomic,strong)YYLabel *suspensionLabel;

@property (nonatomic,assign)BOOL expand;

@property (nonatomic,strong)ACTWgChildVC *currentChildVC;

@property (nonatomic,strong)XKWugOderLimitBanalce *limitModel;

@end

@implementation ACTWgVC
@synthesize scrollView = _scrollView;
@synthesize bannerView = _bannerView;
@synthesize backView = _backView;
@synthesize navView = _navView;
@synthesize contentController = _contentController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"吾G限量购";
    self.view.backgroundColor = COLOR_VIEW_GRAY;
    [self setNavigationBarStyle:XKNavigationBarStyleTranslucent];
    [self setupUI];
    [self autoLayout];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allowScroll:) name:@"ksAllowScroll_wg" object:nil];
    self.allowScroll = YES;
    [self getMoudleData];
    if ([[XKAccountManager defaultManager] isLogin]) {
        [self getWugLimiteBalance];
        self.suspensionImageView.hidden = NO;
    }else{
        self.suspensionImageView.hidden = YES;
    }
    ACTMoudleData *moduleData = [[XKFDataService() actService] queryModuleDataFromCache:Activity_WG];
    if (moduleData) {
        self.bannerView.dataSource = moduleData.bannerList;
        self.models = moduleData.sectionList;
        [self.contentController reloadData];
    }
    self.scrollView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    [self.scrollView bringSubviewToFront:self.scrollView.mj_header];
     
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupUI{
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.backView];
    [self.scrollView addSubview:self.bannerView];
    [self.scrollView addSubview:self.contentController.view];
    
    [self.view addSubview:self.suspensionImageView];
    [self.suspensionImageView addSubview:self.suspensionLabel];
    [self.suspensionImageView addSubview:self.suspensionIcon];
    self.suspensionImageView.frame = CGRectMake(0, kBackH+80-30, 70, 60);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWg)];
    [self.suspensionImageView addGestureRecognizer:tapGesture];
    self.suspensionImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.navView];
    self.navView.frame = CGRectMake(0, 0, kScreenWidth, kTopHeight);
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"吾G\n限购"];
    attri.yy_font = [UIFont systemFontOfSize:14.0f];
    attri.yy_color = HexRGB(0x7D521A, 1.0f);
    attri.yy_lineSpacing = 3.5f;
    self.suspensionLabel.attributedText = attri;
    self.suspensionLabel.frame =  CGRectMake(10, 10, 40, 40);
    self.suspensionIcon.frame = CGRectMake(45, 25, 10, 10);
    self.suspensionIcon.image = [UIImage imageNamed:@"arrow_right"];
    self.suspensionImageView.frame = CGRectMake(0, scalef(364.0f)+80-30, 70, 60);
}

- (void)autoLayout{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(kTopHeight);
        make.width.mas_equalTo(kScreenWidth);
    }];
    self.backView.frame = CGRectMake(0, -200, kScreenWidth, kBackH);
    self.bannerView.frame = CGRectMake(10, 0, kScreenWidth-20, (kScreenWidth-20)/355.0f*170);
    
    [self.contentController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.top.mas_equalTo(self.bannerView.bottom);
        make.height.mas_equalTo(kScreenHeight-kTopHeight);
    }];
   // self.contentController.view.frame = CGRectMake(0, self.bannerView.bottom, kScreenWidth, kScreenHeight-kTopHeight);
    //self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.contentController.view.bottom);
}

// 获取模块信息
- (void)getMoudleData{
    @weakify(self);
    [[XKFDataService() actService]getActivityMoudleByActivityType:Activity_WG Complete:^(ACTMoudleResponse * _Nonnull response) {
        @strongify(self);
        if ([response isSuccess]) {
            self.bannerView.dataSource = response.data.bannerList;
            self.models = response.data.sectionList;
            [self.contentController reloadData];
        }else{
            [response showError];
        }
    }];
}

- (void)getWugLimiteBalance {
    NSString *userId = [XKAccountManager defaultManager].account.userId ?:@"";
    @weakify(self);
    [[XKFDataService() orderService] getWugLimitBlanceWithUserId:userId comlete:^(XKWugOderLimitBanalceData * _Nonnull response) {
        @strongify(self);
        if (response.isSuccess) {
            XKWugOderLimitBanalce *limitModel = response.data;
            self.limitModel = limitModel;
        }else{
            [response showError];
        }
    }];
}

- (void)refresh{
    if (self.currentChildVC) {
        [self.currentChildVC refreshDataWithBlock:^{
            [self.scrollView.mj_header endRefreshing];
        }];
    }else{
        [self.scrollView.mj_header endRefreshing];
    }
}


#pragma mark - WMPageControllerDataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.models.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    ACTMoudleModel *model = [self.models objectAtIndex:index];
    return model.categoryName;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGRect frame = self.contentController.view.bounds;
    frame.origin.y = kMenuHeight;
    frame.size.height = kScreenHeight-kTopHeight-kMenuHeight;
    return frame;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 0, kScreenWidth, kMenuHeight);
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    self.contentController.scrollView.backgroundColor = [UIColor clearColor];
    ACTMoudleModel *model = [self.models objectAtIndex:index];
    ACTWgChildVC *controller = [[ACTWgChildVC alloc] init];
    controller.moduleId = model.id;
    return controller;
}

- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{
    self.currentChildVC = viewController;
}


- (void)allowScroll:(NSNotification *)notif{
    self.allowScroll = [notif.object boolValue];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"offsetY:%f",offsetY);
    if (offsetY < -150) {
        scrollView.contentOffset = CGPointMake(0, -150);
        return;
    }
    
    CGFloat y =  self.bannerView.bottom;
    BOOL allowScroll = NO;
    if (offsetY >= y) {
        allowScroll = YES;
        scrollView.contentOffset = CGPointMake(0, y);
    }else{
        if (offsetY >= y-100-20 && offsetY <= y-20) {
            self.backView.layer.cornerRadius = 0.5*(y - offsetY-20);
            self.backView.height = kBackH - 50 + 0.5*(y-offsetY-20);
        }else if (offsetY > y - 20){
            self.backView.layer.cornerRadius = 0;
            self.backView.height = kBackH - 50;
        }
        allowScroll = NO;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kcAllowScroll_wg" object:@(allowScroll)];
    if (self.allowScroll == NO && offsetY < y) {
        scrollView.contentOffset = CGPointMake(0, y);
    }
}

- (void)tapWg{
    if (self.expand) {
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"吾G\n限购"];
        attri.yy_font = [UIFont systemFontOfSize:14.0f];
        attri.yy_color = HexRGB(0x7D521A, 1.0f);
        attri.yy_lineSpacing = 3.5f;
        self.suspensionLabel.attributedText = attri;
        [UIView animateWithDuration:0.3 animations:^{
            self.suspensionImageView.image = [UIImage imageNamed:@"suspension_s"];
            self.suspensionImageView.frame = CGRectMake(0, scalef(364.0f)+80-30, 70, 60);
            self.suspensionLabel.frame =  CGRectMake(10, 10, 40, 40);
            self.suspensionIcon.frame = CGRectMake(45, 25, 10, 10);
            self.suspensionIcon.image = [UIImage imageNamed:@"arrow_right"];
        }];

    }else{
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] init];
        NSAttributedString *attri1 = [[NSAttributedString alloc] initWithString:@"每月限额" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:HexRGB(0x7D521A, 1.0f)}];
        [attri appendAttributedString:attri1];
        if (self.limitModel.limitAmount >= 1000000) {
            NSAttributedString *attriLM = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %.2f万元\n",self.limitModel.limitAmount/100.0/10000.0] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f],NSForegroundColorAttributeName:HexRGB(0x7D521A, 1.0f)}];
            [attri appendAttributedString:attriLM];
        }else{
            NSAttributedString *attriLM = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %.2f元\n",self.limitModel.limitAmount/100.0] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f],NSForegroundColorAttributeName:HexRGB(0x7D521A, 1.0f)}];
            [attri appendAttributedString:attriLM];
        }
        
        NSAttributedString *attri2 = [[NSAttributedString alloc] initWithString:@"可购余额" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:HexRGB(0x7D521A, 1.0f)}];
        [attri appendAttributedString:attri2];

        if (self.limitModel.balance >= 1000000) {
           NSAttributedString *attriLB = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %.2f万元\n",self.limitModel.balance/100.0/10000.0] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f],NSForegroundColorAttributeName:HexRGB(0x7D521A, 1.0f)}];
           [attri appendAttributedString:attriLB];
        }else{
            NSAttributedString *attriLB = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %.2f元\n",self.limitModel.balance/100.0] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f],NSForegroundColorAttributeName:HexRGB(0x7D521A, 1.0f)}];
            [attri appendAttributedString:attriLB];
        }

        NSAttributedString *attri3 = [[NSAttributedString alloc] initWithString:@"下次刷新" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:HexRGB(0x7D521A, 1.0f)}];
        [attri appendAttributedString:attri3];
        
        NSAttributedString *attriLT = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@\n",self.limitModel.expirationTime] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f],NSForegroundColorAttributeName:HexRGB(0x7D521A, 1.0f)}];
        [attri appendAttributedString:attriLT];
        attri.yy_lineSpacing = 3.5f;
        self.suspensionLabel.attributedText = attri;
        [UIView animateWithDuration:0.3 animations:^{
            self.suspensionImageView.image = [UIImage imageNamed:@"suspension"];
            self.suspensionImageView.frame = CGRectMake(0, scalef(364.0f)+80-40, 170, 80);
            self.suspensionLabel.frame =  CGRectMake(25, 10, 135, 60);
            self.suspensionIcon.frame = CGRectMake(10, 35, 10, 10);
            self.suspensionIcon.image = [UIImage imageNamed:@"arrow_left"];
        }];
    }
    self.expand = !self.expand;
}

#pragma mark getter or setter
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (XKBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[XKBannerView alloc]init];
        _bannerView.layer.cornerRadius = 5.0f;
        _bannerView.clipsToBounds = YES;
    }
    return _bannerView;
}

- (XKGradientView *)backView{
    if (!_backView) {
        _backView = [[XKGradientView alloc] init];
        _backView.gradientLayer.startPoint = CGPointMake(0, 0);
        _backView.gradientLayer.endPoint = CGPointMake(0.99, 0);
        _backView.gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:178/255.0 green:69/255.0 blue:146/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:222/255.0 green:82/255.0 blue:107/255.0 alpha:1.0].CGColor];
        _backView.gradientLayer.locations = @[@(0), @(1.0f)];
        _backView.layer.cornerRadius = 50;
        _backView.clipsToBounds = YES;
    }
    return _backView;
}

- (XKGradientView *)navView{
    if (!_navView) {
        _navView = [[XKGradientView alloc] init];
        _navView.gradientLayer.startPoint = CGPointMake(0, 0);
        _navView.gradientLayer.endPoint = CGPointMake(0.99, 0);
        _navView.gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:178/255.0 green:69/255.0 blue:146/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:222/255.0 green:82/255.0 blue:107/255.0 alpha:1.0].CGColor];
        _navView.gradientLayer.locations = @[@(0), @(1.0f)];
    }
    return _navView;
}

- (XKPageController *)contentController {
    if (!_contentController) {
        _contentController = [XKPageController new];
        _contentController.dataSource = self;
        _contentController.delegate = self;
        _contentController.menuViewStyle = WMMenuViewStyleLine;
        _contentController.menuViewContentMargin = 0;
        _contentController.progressHeight = 2.5;
        _contentController.progressViewCornerRadius = 2.5/2;
        _contentController.progressViewBottomSpace = 5;
        _contentController.titleSizeSelected = 16;
        _contentController.titleSizeNormal = 14;
        _contentController.titleColorSelected = COLOR_HEX(0xffffff);
        _contentController.titleColorNormal = COLOR_HEX(0xffffff);
        _contentController.progressColor = COLOR_HEX(0xffffff);
        _contentController.pageAnimatable = YES;
        _contentController.progressWidth = 60;
        //_contentController.menuItemWidth = 80;
        _contentController.automaticallyCalculatesItemWidths = YES;
        NSInteger numberOfPages = 0;
        if ([_contentController.dataSource respondsToSelector:@selector(numbersOfChildControllersInPageController:)]) {
            numberOfPages = [_contentController.dataSource numbersOfChildControllersInPageController:_contentController];
        }
        _contentController.view.backgroundColor = [UIColor clearColor];
    }
    return _contentController;
}


- (UIImageView *)suspensionImageView{
    if (!_suspensionImageView) {
        _suspensionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"suspension_s"]];
    }
    return _suspensionImageView;
}

- (YYLabel *)suspensionLabel{
    if (!_suspensionLabel) {
        _suspensionLabel = [[YYLabel alloc] init];
        _suspensionLabel.numberOfLines = 0;
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"吾G\n限购"];
        attri.yy_font = [UIFont systemFontOfSize:14.0f];
        attri.yy_color = HexRGB(0x7D521A, 1.0f);
        attri.yy_lineSpacing = 3.5f;
        _suspensionLabel.attributedText = attri;
    }
    return _suspensionLabel;
}

- (UIImageView *)suspensionIcon{
    if (!_suspensionIcon) {
        _suspensionIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    }
    return _suspensionIcon;
}


@end
