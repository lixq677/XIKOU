//
//  MIRedbagSheet.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/10/21.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIRedbagSheet.h"

@interface MIRedbagSheetReusableView : UICollectionReusableView

@property (nonatomic,strong)UILabel *textLabel;

@property (nonatomic,strong)UIView *line;

@end

@implementation MIRedbagSheetReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.textLabel];
        [self addSubview:self.line];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.frame = self.bounds;
    self.line.frame = CGRectMake(20, self.height-1, self.width-40, 1);
}


- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HexRGB(0xe4e4e4, 1.0f);
    }
    return _line;
}

@end

@interface MIRedbagSheetCell : UICollectionViewCell

@property (nonatomic,strong)UIButton *button;

@end

@implementation MIRedbagSheetCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.button];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.button.frame = self.bounds;
}


- (UIButton *)button{
    if (!_button) {
        _button = [[UIButton alloc] init];
        _button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_button setTitleColor:HexRGB(0x444444, 1.0f) forState:UIControlStateNormal];
        _button.layer.cornerRadius = 2.0f;
        _button.userInteractionEnabled = NO;
    }
    return _button;
}

@end


@interface MIRedbagSheet ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong,readonly)UIView *backgroundView;

@property (nonatomic,strong,readonly)UICollectionView *collectionView;

@property (nonatomic,strong,readonly)UIButton *button;

@property (nonatomic,strong)XKRedbagCategoryTitle *categoryTitleModel;

@end

@implementation MIRedbagSheet
@synthesize backgroundView = _backgroundView;
@synthesize collectionView = _collectionView;
@synthesize button = _button;


- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = HexRGB(0xffffff, 1.0f);
        [self addSubview:self.collectionView];
        [self.collectionView registerClass:[MIRedbagSheetCell class] forCellWithReuseIdentifier:@"MIRedbagSheetCell"];
        [self.collectionView registerClass:[MIRedbagSheetReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MIRedbagSheetReusableView"];
        [self addSubview:self.button];
        
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20.0f);
            make.right.mas_equalTo(-20.0f);
            make.bottom.mas_equalTo(-15);
            make.height.mas_equalTo(40);
        }];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.bottom.mas_equalTo(self.button.mas_top).offset(-20);
        }];
    }
    return self;
}


- (void)showAtView:(UIView *)view{
    _isShow = YES;
    self.backgroundView.frame = CGRectMake(0, 0, kScreenWidth, view.height);
    [view addSubview:self.backgroundView];
    [self.backgroundView addSubview:self];
    self.frame = CGRectMake(0, - [self sheetHeight], [self sheetWidth], [self sheetHeight]);
    CGRect afterFrame = CGRectMake(0, 0,[self sheetWidth], [self sheetHeight]);
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame = afterFrame;
    } completion:nil];
}

- (void)dismiss{
    _isShow = NO;
    CGRect afterFrame = CGRectMake(0,-[self sheetHeight], [self sheetWidth], [self sheetHeight]);
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = afterFrame;
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        [super removeFromSuperview];
    }];
}




#pragma mark collcetionView delegate && dataSouce
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.categoryData.income.count;
    }else{
        return self.categoryData.outcome.count;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (![kind isEqualToString:UICollectionElementKindSectionHeader])return nil;
     MIRedbagSheetReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MIRedbagSheetReusableView" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        reusableView.textLabel.text = @"收入";
    }else{
        reusableView.textLabel.text = @"支出";
    }
    return reusableView;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MIRedbagSheetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MIRedbagSheetCell" forIndexPath:indexPath];
    XKRedbagCategoryTitle *categoryTitle = nil;
    if(indexPath.section == 0){
        categoryTitle = [self.categoryData.income objectAtIndex:indexPath.row];
    }else{
        categoryTitle = [self.categoryData.outcome objectAtIndex:indexPath.row];
        [cell.button setTitle:categoryTitle.name forState:UIControlStateNormal];
    }
    [cell.button setTitle:categoryTitle.name forState:UIControlStateNormal];
    if (categoryTitle.select) {
        [cell.button setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
        cell.button.layer.borderColor = [[UIColor clearColor] CGColor];
        cell.button.backgroundColor = HexRGB(0x444444, 1.0f);
    }else{
        [cell.button setTitleColor:HexRGB(0x444444, 1.0f) forState:UIControlStateNormal];
        cell.button.layer.borderColor = [HexRGB(0xcccccc, 1.0f) CGColor];
        cell.button.backgroundColor = [UIColor clearColor];
        cell.button.layer.borderWidth = 1;
    }
    return cell;
   
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    XKRedbagCategoryTitle *categoryTitleModel = nil;
    if (indexPath.section == 0) {
        categoryTitleModel = [self.categoryData.income objectAtIndex:indexPath.row];
    }else{
        categoryTitleModel = [self.categoryData.outcome objectAtIndex:indexPath.row];
    }
    if (self.categoryTitleModel) {
        if (self.categoryTitleModel == categoryTitleModel) {
            self.categoryTitleModel.select = !self.categoryTitleModel.select;
        }else{
            self.categoryTitleModel.select = NO;
            categoryTitleModel.select = YES;
        }
    }else{
        categoryTitleModel.select = YES;
    }
    self.categoryTitleModel = categoryTitleModel;
    [self.collectionView reloadData];
}


- (UIViewController *)appRootViewController{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (void)removeFromSuperview{
    [self.backgroundView removeFromSuperview];
    //UIViewController *topVC = [self appRootViewController];
    CGRect afterFrame = CGRectMake(0,-[self sheetHeight], [self sheetWidth], [self sheetHeight]);
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = afterFrame;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}


#pragma mark getter or setter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        //flowLayout.minimumInteritemSpacing = 29;
        flowLayout.minimumLineSpacing = 10.0f;
        flowLayout.minimumInteritemSpacing = 10.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(30, 17, 20, 17);
        flowLayout.itemSize = CGSizeMake((kScreenWidth-57)/3.0f, 40);
        flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth-30, 50);
        
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)
                                            collectionViewLayout:flowLayout];
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}


- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = HexRGB(0x0, 0.3);
        _backgroundView.clipsToBounds = YES;
    }
    return _backgroundView;
}

- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:@"确定" forState:UIControlStateNormal];
        [_button setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
        [_button setBackgroundColor:HexRGB(0x444444, 1.0f)];
        @weakify(self);
        [[_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (self.sureBlock) {
                self.sureBlock(self.categoryTitleModel);
            }
            [self dismiss];
        }];
    }
    return _button;
}

- (CGFloat)sheetWidth{
    return kScreenWidth;
}

- (CGFloat)sheetHeight{
    return kScreenHeight - 100 - kTopHeight;
}

@end
