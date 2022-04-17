//
//  ACTDiscountBuyChild1VC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/10/26.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTDiscountBuyChild1VC.h"
#import "XKActivityService.h"
#import "XKDataService.h"
#import "XKAccountManager.h"
#import "ACTDiscountGoodCell.h"
#import <TABAnimated.h>

@interface ACTDiscountBuyChild1VC ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)UICollectionView *collectionView;

@end

@implementation ACTDiscountBuyChild1VC
@synthesize collectionView = _collectionView;
@synthesize result = _result;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[ACTDiscountGoodCell class]
               forCellWithReuseIdentifier:[ACTDiscountGoodCell identify]];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.collectionView.tabAnimated =
        [TABCollectionAnimated animatedWithCellClass:[ACTDiscountGoodCell class] cellSize:CGSizeMake(scalef(110), scalef(154.0f)) animatedCount:3];
    self.collectionView.tabAnimated.animatedCount = 4;
    self.collectionView.tabAnimated.animatedSectionCount = 1;
    [self.collectionView tab_startAnimation];
}

#pragma mark collcetionView delegate && dataSouce
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.result.count > 3) {
        return 3;
    }else{
        return self.result.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ACTDiscountGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ACTDiscountGoodCell identify] forIndexPath:indexPath];
    cell.model = [self.result objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    XKGoodListModel *model =  [self.result objectAtIndex:indexPath.row];
    [MGJRouter openURL:kRouterGoods withUserInfo:@{@"activityType":@(Activity_Discount),@"id":model.id} completion:nil];
}

- (void)getGoodsData{
    @weakify(self);
    NSString *userId = [XKAccountManager defaultManager].account.userId ?:@"";
    [[XKFDataService() actService] getGoodListByActivityType:Activity_Discount andCategoryId:self.moduleId andPage:1 andLimit:10 andUserId:userId Complete:^(ACTGoodListRespnse * _Nonnull response) {
        @strongify(self);
        [self.collectionView tab_endAnimation];
        if ([response isSuccess]) {
            [self.result removeAllObjects];
            [self.result addObjectsFromArray:response.data.result];
            [self.collectionView reloadData];
        }else{
            [response showError];
        }
    }];
}



- (void)setModuleId:(NSString *)moduleId{
    if ([_moduleId isEqualToString:moduleId] == NO) {
        _moduleId = moduleId;
        [self getGoodsData];
    }
}

- (NSMutableArray<XKGoodListModel *> *)result{
    if (!_result) {
        _result = [NSMutableArray array];
    }
    return _result;
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        CGFloat space = scalef(12.5);
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = space;
        flowLayout.minimumInteritemSpacing = space;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, scalef(10), 0, scalef(10));
        flowLayout.itemSize = CGSizeMake(scalef(110), scalef(154.0f));
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

@end
