//
//  MIOrderPayForAnotherBaseVC.m
//  XiKou
//
//  Created by L.O.U on 2019/8/30.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIOrderPayForAnotherBaseVC.h"
#import "MIOrderPayForAnotherChildVC.h"
#import "XKSegmentView.h"

@interface MIOrderPayForAnotherBaseVC ()<XKSegmentViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) XKSegmentView *segmentView;

@property (nonatomic, strong) UIScrollView *contetView;

@property (nonatomic, strong) NSMutableDictionary *vcs;

@property (nonatomic, strong) UIView *infoView;

@property (nonatomic, strong) UILabel *infoLabel;
@end

@implementation MIOrderPayForAnotherBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的代付";
    [self initUI];
}

#pragma mark UI
- (void)initUI{
    
    [self.view addSubview:self.infoView];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(30);
    }];

    _segmentView = [[XKSegmentView alloc]initWithTitles:@[@"未支付",@"已支付"]];
    _segmentView.delegate = self;
    _segmentView.style = XKSegmentViewStyleDivide;
    [self.view addSubview:_segmentView];
    [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.infoView.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    
    _contetView = [[UIScrollView alloc]init];
    _contetView.showsHorizontalScrollIndicator = NO;
    _contetView.pagingEnabled = YES;
    _contetView.delegate = self;
    _contetView.contentSize = CGSizeMake(kScreenWidth * self.segmentView.titles.count, 0);
    [self.view addSubview:_contetView];
    [_contetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(( self.segmentView.titles.count > 0) ? 75 : 30);
    }];
    [self sliderIndex:0];
}

//滚动
- (void)sliderIndex:(NSInteger)index{
    if (![_vcs objectForKey:@(index)]) {

        MIOrderPayForAnotherChildVC *vc = [MIOrderPayForAnotherChildVC new];
        vc.status = index == 0 ? OSUnPay : OSComlete;
        vc.requestSuccessBlock = ^(NSInteger totalPay, NSInteger totalUnPay) {
            self.infoLabel.text = [NSString stringWithFormat:@"您已代付金额：%.2f元，还剩 %.2f元未代付。",totalPay/100.00,totalUnPay/100.00];
        };
        
        [_vcs setObject:vc forKey:@(index)];
        [self addChildViewController:vc];
        [self.contetView addSubview:vc.view];
        [self.contetView setNeedsLayout];
        [self.contetView layoutIfNeeded];
        vc.view.frame = CGRectMake(self.contetView.width * index, 0, kScreenWidth, self.contetView.height);
    }
    if (self.segmentView.currentIndex != index) {
        self.segmentView.currentIndex  = index;
    }
    [self.contetView setContentOffset:CGPointMake(kScreenWidth * index, 0) animated:YES];
}

//代理
- (void)segmentView:(XKSegmentView *)segmentView selectIndex:(NSUInteger)index{
    [self sliderIndex:index];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/kScreenWidth;
    [self sliderIndex:index];
}

- (UIView *)infoView{
    if (!_infoView) {
        _infoView = [UIView new];
        _infoView.backgroundColor = COLOR_HEX(0xFFF5E0);
        
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"qiandai"]];
        [_infoView addSubview:imgView];
        [_infoView addSubview:self.infoLabel];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(12);
            make.left.mas_equalTo(15);
            make.centerY.equalTo(self->_infoView);
        }];
        [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.bottom.equalTo(self->_infoView);
            make.left.equalTo(imgView.mas_right).offset(11);
        }];
    }
    return _infoView;
}

- (UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [UILabel new];
        _infoLabel.textColor = COLOR_TEXT_RED;
        _infoLabel.font = Font(12.f);
        _infoLabel.text = @"您已代付金额：0元，还剩 0元未代付。";
    }
    return _infoLabel;
}
@end
