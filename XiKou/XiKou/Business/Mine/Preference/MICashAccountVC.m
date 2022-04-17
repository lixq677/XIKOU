//
//  MICashAccount.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/5.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MICashAccountVC.h"
#import "MIPaymentPaswSheet.h"
#import "MIPwdResettingVC.h"
#import "MIBankChooseVC.h"
#import "XKCustomAlertView.h"
#import "XKPropertyService.h"
#import "XKAccountManager.h"
#import "MIBankInfoVC.h"

@interface MCBankCell : UITableViewCell

@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic,strong)UILabel *textLabel;

@property (nonatomic,strong)UILabel *detailTextLabel;

@property (nonatomic,strong)UILabel *accountLabel;

@property (nonatomic,strong)UIView *contentV;

@end

@implementation MCBankCell
@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize accountLabel = _accountLabel;
@synthesize contentV = _contentV;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    for (UIView * subView in self.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            subView.layer.cornerRadius = 5.0f;
            break;
        }
    }
}

- (void)setupUI{
    [self.contentView addSubview:self.contentV];
    [self.contentV addSubview:self.imageView];
    [self.contentV addSubview:self.textLabel];
    [self.contentV addSubview:self.detailTextLabel];
    [self.contentV addSubview:self.accountLabel];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentV.backgroundColor = [UIColor whiteColor];
    self.contentV.layer.cornerRadius = 5.0f;
    self.layer.cornerRadius = 5.0f;
    self.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)autoLayout{
    [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.right.mas_equalTo(-20.0f);
        make.top.mas_equalTo(0.0f);
        make.bottom.mas_equalTo(0.0f);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25.0f);
        make.top.mas_equalTo(22.0f);
        make.width.height.mas_equalTo(40.0f);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(10.0f);
        make.top.mas_equalTo(24.0f);
        make.height.mas_equalTo(15.0f);
        make.right.mas_equalTo(-20.0f);
    }];
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel);
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(7.0f);
        make.height.mas_equalTo(12.0f);
    }];
    
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(65.0f);
        make.bottom.equalTo(self.contentV).offset(-20.0f);
        make.right.equalTo(self.contentV).offset(-57.0f);
        make.height.mas_equalTo(16.0f);
        
    }];
}


#pragma mark getter or setter
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.cornerRadius = 20.0f;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.textColor = HexRGB(0x999999, 1.0f);
        _detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _detailTextLabel;
}

- (UILabel *)accountLabel{
    if (!_accountLabel) {
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.textColor = HexRGB(0x444444, 1.0f);
        _accountLabel.font = [UIFont systemFontOfSize:16.0f];
        _accountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _accountLabel;
}

- (UIView *)contentV{
    if (!_contentV) {
        _contentV = [UIView new];
    }
    return _contentV;
}

@end

@interface MICashTableView : UITableView

@end

@implementation MICashTableView

- (void)layoutSubviews{
    [super layoutSubviews];
    if (@available(iOS 11.0,*)) {
        for (UIView *subView in self.subviews) {
            if ([NSStringFromClass([subView class]) isEqualToString:@"UISwipeActionPullView"]) {
                subView.layer.cornerRadius = 5.0f;
                break;
            }
        }
    }
}

@end

@interface MICashAccountVC ()
<UITableViewDelegate,
UITableViewDataSource,
MIPaymentPaswSheetDelegate,
XKPropertyServiceDelegate>

@property (nonatomic,strong,readonly) MICashTableView *tableView;

@property (nonatomic,strong,readonly) UIButton  *addBtn;

@property (nonatomic,strong,readonly) NSMutableArray<XKBankData *> *bankCards;

@end

@implementation MICashAccountVC
@synthesize tableView = _tableView;
@synthesize addBtn = _addBtn;
@synthesize bankCards = _bankCards;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [[XKFDataService() propertyService] addWeakDelegate:self];
    [self queryBankCardsFromServer];
}

- (void)dealloc{
    [[XKFDataService() propertyService] removeWeakDelegate:self];
}


- (void)setupUI{
    self.navigationBarStyle = XKNavigationBarStyleTranslucent;
    self.title = @"提现账号";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addBtn];
    
    [self.tableView registerClass:[MCBankCell class] forCellReuseIdentifier:@"MCBankCell"];
//    @weakify(self);
//    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
//        @strongify(self);
//        [self queryBankCardsFromServer];
//    }];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backgroundView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cash_package"]];
    imageView.frame = CGRectMake(CGRectGetMidX(backgroundView.frame)-35.0f, 100.0f+[XKUIUnitls safeTop] + kNavBarHeight, 70.f, 44.0f);
    
    
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.text = @"暂无银行卡，赶紧去添加吧";
    hintLabel.font = [UIFont systemFontOfSize:12.0f];
    hintLabel.textColor = HexRGB(0x999999, 1.0f);
    hintLabel.textAlignment = NSTextAlignmentCenter;
    [hintLabel sizeToFit];
    hintLabel.frame = CGRectMake(CGRectGetMidX(imageView.frame)-hintLabel.width*0.5f, imageView.bottom+8.0f, hintLabel.width, hintLabel.height);
    [backgroundView addSubview:imageView];
    [backgroundView addSubview:hintLabel];
    
    self.tableView.backgroundView = backgroundView;
    
    [self.addBtn addTarget:self action:@selector(addBankAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20.0f);
        make.right.equalTo(self.view).offset(-20.0f);
        make.height.mas_equalTo(45.0f);
        make.bottom.equalTo(self.view).offset(-20.0f-[XKUIUnitls safeBottom]);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.mas_equalTo(self.addBtn.mas_top).offset(-20.0f);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.bankCards.count == 0) {
        tableView.backgroundView.hidden = NO;
    }else{
        tableView.backgroundView.hidden = YES;
    }
    return self.bankCards.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MCBankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MCBankCell" forIndexPath:indexPath];
    XKBankData *bankData = [self.bankCards objectAtIndex:indexPath.section];
    
    if (bankData.channel == XKBankChannelWexin) {
        cell.imageView.image = [UIImage imageNamed:@"cash_wexin"];
        cell.detailTextLabel.text = @"实名认证";
    }else if (bankData.channel == XKBankChannelZhifubao){
        cell.imageView.image = [UIImage imageNamed:@"cash_zhifubao"];
    }else if(bankData.channel == XKBankChannelCredit){
        cell.imageView.image = [UIImage imageNamed:@"default_bank"];
        cell.detailTextLabel.text = @"信用卡";
    }else{
        NSString *imageName = [[XKFDataService() propertyService] imageNameFromBankName:bankData.bankName];
        cell.imageView.image = [UIImage imageNamed:imageName];
        cell.detailTextLabel.text = @"储蓄卡";
    }
    cell.textLabel.text = bankData.bankName;
    if(![NSString isNull:bankData.image]){
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:bankData.image] placeholderImage:[UIImage imageNamed:kPlaceholderImg]];
    }
    NSString *account = bankData.account;
    NSString *subAc1 = nil;
    NSString *subAc2 = nil;
    if (bankData.account.length <= 4) {
        subAc1 = @"";
        subAc2 = account;
    }else{
        subAc1 = [account substringToIndex:account.length-4];
        subAc2 = [account substringFromIndex:account.length-4];
    }
    NSMutableString *ms = [NSMutableString string];
    for (int i = 0; i < subAc1.length; i++) {
        [ms appendFormat:@"*"];
        if (i != 0 && (i+1)%4 == 0) {
            [ms appendFormat:@" "];
        }
    }
    NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:ms attributes:@{NSBaselineOffsetAttributeName:@(-5),NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:HexRGB(0x999999, 1.0f)}];
    NSAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:subAc2 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:HexRGB(0x444444, 1.0f)}];
    [attr1 appendAttributedString:attr2];
    cell.accountLabel.attributedText = attr1;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self);
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        @strongify(self);
        XKBankData *bankData = [self.bankCards objectAtIndex:indexPath.section];
        [self removeBankCardFromServer:bankData];
       
    }];
    rowAction.backgroundColor = HexRGB(0xcea552, 1.0f);
    return @[rowAction];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(cashAccountVC:selectBankCard:)]) {
        XKBankData *bankData = [self.bankCards objectAtIndex:indexPath.section];
        [self.delegate cashAccountVC:self selectBankCard:bankData];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)paymentPaswSheet:(MIPaymentPaswSheet *)sheet inputPassword:(NSString *)password{
    if([NSString isNull:password])return;
    NSString *userId = [[XKAccountManager defaultManager] userId];
    @weakify(self);
    [XKLoading show];
    [[XKFDataService() propertyService] verifyPayPassword:password userId:userId completion:^(XKBaseResponse * _Nonnull response) {
        [XKLoading dismiss];
        if (response.isSuccess) {
            @strongify(self);
            if ([response.data boolValue]) {
                [sheet dismiss];
                MIBankInfoVC *vc = [[MIBankInfoVC alloc] initWithBankChannel:XKBankChannelBank];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                XKShowToast(@"密码错误");
            }
        }else{
            [response showError];
        }
    }];
}

- (void)resetPassword:(MIPaymentPaswSheet *)sheet{
    MIPwdResettingVC *controller = [[MIPwdResettingVC alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)addBankAction:(id)sender{
    if ([[XKAccountManager defaultManager] isVer] == NO) {
        XKCustomAlertView *alert = [[XKCustomAlertView alloc]initWithType:CanleNoTitle
                                                                 andTitle:@"提示"
                                                               andContent:@"请先进行实名认证,再进行提现操作"
                                                              andBtnTitle:@"去认证"];
        alert.sureBlock = ^{
            [MGJRouter openURL:kRouterAuthen];
        };
        [alert show];
    }else{
        MIPaymentPaswSheet *sheet = [[MIPaymentPaswSheet alloc] initWithDelegate:self];
        [sheet show];
    }
}



- (void)queryBankCardsFromServer{
    NSString *userId = [[XKAccountManager defaultManager] userId];
    @weakify(self);
    [[XKFDataService() propertyService] queryMyBankCardsWithUserId:userId completion:^(XKBankResponse * _Nonnull response) {
        @strongify(self);
        if (response.isSuccess) {
            [self.bankCards removeAllObjects];
            [self.bankCards addObjectsFromArray:response.data];
            [self.tableView reloadData];
        }else{
            [response showError];
        }
    }];
}

- (void)removeBankCardFromServer:(XKBankData *)bankData{
    if ([NSString isNull:bankData.id]){
        XKShowToast(@"服务器数据错误,银行卡id为空");
        return;
    }
    NSInteger index = [self.bankCards indexOfObject:bankData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    [XKLoading show];
    @weakify(self);
    [[XKFDataService() propertyService] removeBankCardWithBankId:bankData.id completion:^(XKBaseResponse * _Nonnull response) {
        [XKLoading dismiss];
        @strongify(self);
        if (response.isSuccess) {
            [self.bankCards removeObject:bankData];
            [self.tableView beginUpdates];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        }else{
            [response showError];
        }
    }];
}

- (void)propertyService:(XKPropertyService *)service bindBankCardSuccess:(XKBankBindParams *)params{
    [self queryBankCardsFromServer];
}


#pragma mark getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[MICashTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 120.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HexRGB(0x444444, 1.0f);
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.sectionFooterHeight = 0.0f;
    }
    return _tableView;
}

- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.backgroundColor = [UIColor whiteColor];
        [_addBtn setTitle:@"+ 添加新账号" forState:UIControlStateNormal];
        [_addBtn setTitleColor:COLOR_TEXT_BROWN forState:UIControlStateNormal];
        _addBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _addBtn.layer.cornerRadius = 5.0f;
        _addBtn.layer.borderColor = [COLOR_TEXT_BROWN CGColor];
        _addBtn.layer.borderWidth = 1.0f;
    }
    return _addBtn;
}

- (NSMutableArray<XKBankData *> *)bankCards{
    if (!_bankCards) {
        _bankCards = [NSMutableArray array];
    }
    return _bankCards;
}


@end
