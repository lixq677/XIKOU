//
//  XKSearchFriendViewController.m
//  XiKou
//
//  Created by majia on 2019/11/4.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKSearchFriendViewController.h"
#import "XKHistorySearchTextLabelCell.h"
#import "XKGoodPropertyHeader.h"
#import "XKSearchResultView.h"
#import "XKUserService.h"
@interface XKSearchFriendViewController () <UICollectionViewDelegate,
                                            UICollectionViewDataSource,
                                            UICollectionViewDelegateFlowLayout,
                                            UITextFieldDelegate>

@property (nonatomic,strong) UILabel *searchFriendLabel;

@property (nonatomic,strong) UITextField *searchTextfield;

@property (nonatomic,strong) UIView *lineView;


@property (nonatomic,strong) UICollectionView *historyCollectionView;

@property (nonatomic,strong) UICollectionViewFlowLayout *flowOut;

@property (nonatomic,strong) NSMutableArray *historyArray;

@property (nonatomic,strong) XKSearchResultView *resultView;


@end

@implementation XKSearchFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索喜扣好友";
    [self setUpUI];
    [self.searchTextfield becomeFirstResponder];
    @weakify(self);
    self.resultView.tapActionBlock = ^(NSString *phone,NSString *nickName,NSString *userId){
        @strongify(self);
        NSDictionary *dict = @{@"phone":phone,@"nickName":nickName,@"userId":userId};
        NSMutableArray *muarray = self.historyArray.mutableCopy;
       __block BOOL isNeedAdd = YES;
        [muarray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *phoneText = obj[@"phone"];
            if ([phoneText isEqualToString:phone]) {
                [self.historyArray replaceObjectAtIndex:idx withObject:dict];
                isNeedAdd = NO;
                *stop = YES;
            }
        }];
        if (isNeedAdd) {
            [self.historyArray insertObject:dict atIndex:0];
        }
        NSArray *subArray = [NSArray arrayWithArray:self.historyArray];
        if (self.historyArray.count > 9) {
         subArray = [self.historyArray subarrayWithRange:NSMakeRange(0, 9)];
        }
        [[NSUserDefaults standardUserDefaults] setObject:subArray forKey:@"recentSearchFriend"];
        [self doBackWithPhone:phone userId:userId nickName:nickName];
    };
}
#pragma mark - private method
- (void)setUpUI {
    [self.view addSubview:self.searchFriendLabel];
    [self.view addSubview:self.searchTextfield];
    [self.view addSubview:self.lineView];
    [self.searchFriendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(28);
        make.left.equalTo(self.view).offset(15);
        make.height.mas_equalTo(20);
    }];
    [self.searchTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchFriendLabel.mas_bottom).offset(10).priorityHigh();
        make.left.equalTo(self.searchFriendLabel).priorityHigh();
        make.right.equalTo(self.view).offset(-26).priorityHigh();
        make.height.mas_equalTo(30).priorityHigh();
    }];
    [self.view addSubview:self.resultView];
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchTextfield.mas_bottom).offset(10);
        make.left.right.equalTo(self.searchTextfield);
        make.height.mas_equalTo(0.1);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resultView.mas_bottom).offset(5);
        make.left.right.equalTo(self.resultView);
        make.height.mas_equalTo(0.5);
    }];
   
    [self.view addSubview:self.historyCollectionView];
    [self.historyCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(20);
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.historyCollectionView reloadData];
    
    [[self.searchTextfield.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        NSString *tel = [value deleteSpace];
        return tel;
    }] subscribeNext:^(NSString * _Nullable x) {
        if ([x isMobileNumber]) {
            [self searchUserByPhone:x];
        }else{
            [self showSearchResult:NO];
        }
    }];


}
- (void)showSearchResult:(BOOL)show {
    self.searchFriendLabel.hidden = show;
    if (!show) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.searchFriendLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).offset(30);
            }];
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            [self.searchFriendLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).offset(-20);
            }];
        }];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.resultView.hidden = !show;
        [self.resultView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(show ? 40 : 0.1);
        }];
        
    }];
    [self.view layoutIfNeeded];

}
- (void)doBackWithPhone:(NSString *)phone userId:(NSString *)userId nickName:(NSString *)nickname {
    if (phone.length > 0 && userId.length > 0) {
        if (self.phoneBlock) {
            self.phoneBlock(phone,userId);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        XKShowToast(@"喜扣好友信息错误");
    }

}
#pragma mark - network
- (void)searchUserByPhone:(NSString *)phone {
    if ([phone isEqualToString:[XKAccountManager defaultManager].mobile]) {
        XKShowToast(@"不能请自己代付");
        return;
    }
    [[XKFDataService() userService] queryUserInfoWithMobile:phone completion:^(XKUserInfoResponse * _Nonnull response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showSearchResult:YES];
            if ([response isSuccess]) {
                [self.resultView reloadSearchResult:phone userId:response.data.id nickName:response.data.nickName];
            }else{
                [self.resultView reloadSearchResult:@"" userId:@"" nickName:@""];
                
            }
        });
    }];
    
}





#pragma mark - delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.historyArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XKHistorySearchTextLabelCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"historyCell" forIndexPath:indexPath];
    NSDictionary *dict = [self.historyArray objectAtIndex:indexPath.row];
    NSString *phone = dict[@"phone"];
    cell.textLabel.text = [phone mobileNumberFormat];
    cell.titleLabel.text = dict[@"nickName"];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XKHistorySearchTextLabelCell * cell = (XKHistorySearchTextLabelCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSDictionary *dict = [self.historyArray objectAtIndex:indexPath.row];
    NSString *userId = dict[@"userId"];
    [self doBackWithPhone:cell.textLabel.text userId:userId nickName:cell.titleLabel.text];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    XKGoodPropertyHeader * reusableView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"historyHeader" forIndexPath:indexPath];
    reusableView.titleLabel.text = @"好友搜索记录";
    reusableView.titleLabel.textColor = COLOR_HEX(0xCCCCCC);
    return reusableView;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark - lazy

- (UICollectionView *)historyCollectionView {
    if (!_historyCollectionView) {
        _historyCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowOut];
        _historyCollectionView.delegate = self;
        _historyCollectionView.dataSource = self;
        _historyCollectionView.backgroundColor = [UIColor whiteColor];
        [_historyCollectionView registerClass:[XKHistorySearchTextLabelCell class] forCellWithReuseIdentifier:@"historyCell"];
        [_historyCollectionView registerClass:[XKGoodPropertyHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"historyHeader"];
        
    }
    return _historyCollectionView;
}
- (UICollectionViewFlowLayout *)flowOut {
    if (!_flowOut) {
        _flowOut = [[UICollectionViewFlowLayout alloc] init];
        _flowOut.itemSize = CGSizeMake((kScreenWidth-50)/3, 60);
        _flowOut.minimumInteritemSpacing = 5;
        _flowOut.minimumLineSpacing = 10;
        _flowOut.headerReferenceSize = CGSizeMake(kScreenWidth, 40);
        
    }
    return _flowOut;
}
- (NSMutableArray *)historyArray {
    if (!_historyArray) {
        _historyArray = [[NSMutableArray alloc] init];
        NSArray *arr = [[NSUserDefaults standardUserDefaults] arrayForKey:@"recentSearchFriend"];
        [_historyArray addObjectsFromArray:arr];
        
    }
    return _historyArray;
}

- (XKSearchResultView *)resultView {
    if (!_resultView) {
        _resultView = [[XKSearchResultView alloc] init];
        _resultView.backgroundColor = [UIColor whiteColor];
        _resultView.hidden = YES;
    }
    return _resultView;
}
- (UILabel *)searchFriendLabel {
    if (!_searchFriendLabel) {
        _searchFriendLabel = [[UILabel alloc] init];
        _searchFriendLabel.textColor = COLOR_HEX(0xCCCCCC);
        _searchFriendLabel.font = Font(15);
        _searchFriendLabel.textAlignment = NSTextAlignmentLeft;
        _searchFriendLabel.text = @"搜索喜扣好友手机号码";
    }
    return _searchFriendLabel;
}
- (UITextField *)searchTextfield {
    if (!_searchTextfield) {
        _searchTextfield = [[UITextField alloc] init];
        _searchTextfield.textColor = COLOR_TEXT_BLACK;
        _searchTextfield.font = Font(25);
        _searchTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTextfield.keyboardType = UIKeyboardTypeNumberPad;
        _searchTextfield.returnKeyType = UIReturnKeyDone;
        _searchTextfield.delegate = self;
        _searchTextfield.xk_monitor = YES;
        _searchTextfield.xk_textFormatter = XKTextFormatterMobile;
        _searchTextfield.xk_supportContent = XKTextSupportContentNumber;
        _searchTextfield.xk_maximum = 11;

    }
    return _searchTextfield;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = COLOR_HEX(0xe4e4e4);
    }
    return _lineView;
}
@end
