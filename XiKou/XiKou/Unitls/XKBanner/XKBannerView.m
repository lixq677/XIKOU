//
//  XKBannerView.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/19.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKBannerView.h"
#import "XKUIUnitls.h"
#import "XKWeakProxy.h"

@interface XKBannerView () <UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,strong)UIImageView *leftImageView;

@property (nonatomic,strong)UIImageView *centerImageView;

@property (nonatomic,strong)UIImageView *rightImageView;

@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic,assign) CGFloat lastX;

@property (nonatomic,assign) NSInteger curIndex;

@property (nonatomic,strong)UITapGestureRecognizer *tapGesture;

@end

@implementation XKBannerView
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize leftImageView = _leftImageView;
@synthesize centerImageView = _centerImageView;
@synthesize rightImageView = _rightImageView;
@synthesize currentIndex = _currentIndex;
@synthesize pageCount = _pageCount;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _needPageControl = YES;
        [self setupUI];
        [self layout];
        [self addGestureRecognizer:self.tapGesture];
        self.userInteractionEnabled = YES;
        self.timer = [NSTimer timerWithTimeInterval:3.0f target:[XKWeakProxy proxyWithTarget:self] selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark -private method

- (void)setupUI{
    [self addSubview:self.scrollView];
    if (self.needPageControl) {
        [self addSubview:self.pageControl];
    }
    [self.scrollView addSubview:self.leftImageView];
    [self.scrollView addSubview:self.centerImageView];
    [self.scrollView addSubview:self.rightImageView];
}

- (void)layout{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    if (self.needPageControl) {
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.mas_equalTo(30.0f);
        }];
    }
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.width.height.equalTo(self.scrollView);
    }];
    [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.height.equalTo(self.scrollView);
        make.left.mas_equalTo(self.leftImageView.mas_right);
    }];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.bottom.height.width.right.equalTo(self.scrollView);
         make.left.mas_equalTo(self.centerImageView.mas_right);
    }];
}


- (void)resetLayoutImages{
    if (_currentIndex >= (int)self.dataSource.count) {
        _currentIndex = 0;
    }
    if (_currentIndex < 0) {
        _currentIndex = self.dataSource.count -1;
    }
    [self setupImage];
}
- (void)timerAction{
    [self.scrollView setContentOffset:CGPointMake(2*CGRectGetWidth(self.bounds), 0) animated:YES];
}
- (void)setupImage{
    @weakify(self);
    NSInteger (^getIndexBlock)(NSInteger index) = ^(NSInteger index){
        @strongify(self);
        if (index >= (int)self.dataSource.count) {
            index = 0;
        }
        if (index < 0) {
            index = self.dataSource.count-1;
        }
        return index;
    };
    
    id leftSource = [self.dataSource objectAtIndex:getIndexBlock(self.currentIndex-1)];
    id centerSource = [self.dataSource objectAtIndex:getIndexBlock(self.currentIndex)];
    id rightSource = [self.dataSource objectAtIndex:getIndexBlock(self.currentIndex+1)];
    
    if ([leftSource isKindOfClass:[UIImage class]]) {
        self.leftImageView.image = (UIImage *)leftSource;
    }else if ([leftSource isKindOfClass:[NSString class]]){
        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:(NSString *)leftSource] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    }else if([leftSource isKindOfClass:[XKBannerData class]]){
        NSString *url = [(XKBannerData *)leftSource imageUrl];
        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    }else{
        NSAssert(NO, @"Banner数据源类型不对");
    }
    
    if ([centerSource isKindOfClass:[UIImage class]]) {
        self.centerImageView.image = (UIImage *)centerSource;
    }else if ([centerSource isKindOfClass:[NSString class]]){
        [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:(NSString *)centerSource] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    }else if([centerSource isKindOfClass:[XKBannerData class]]){
        NSString *url = [(XKBannerData *)centerSource imageUrl];
        [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    }else{
        NSAssert(NO, @"Banner数据源类型不对");
    }
    
    if ([rightSource isKindOfClass:[UIImage class]]) {
        self.rightImageView.image = (UIImage *)rightSource;
    }else if ([rightSource isKindOfClass:[NSString class]]){
        [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:(NSString *)rightSource] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    }else if([rightSource isKindOfClass:[XKBannerData class]]){
        NSString *url = [(XKBannerData *)rightSource imageUrl];
        [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    }else{
        NSAssert(NO, @"Banner数据源类型不对");
    }
    
    if (self.dataSource.count
        > 1) {
        [self.scrollView setContentSize:CGSizeMake(3*CGRectGetWidth(self.scrollView.bounds), 0)];
        [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.bounds), 0) animated:NO];
    }else{
        [self.scrollView setContentSize:CGSizeMake(0, 0)];
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    if (self.needPageControl) {
        self.pageControl.currentPage = self.currentIndex;
    }
    
    if ([self.delegate respondsToSelector:@selector(bannerView:currentPage:)]) {
        [self.delegate bannerView:self currentPage:self.currentIndex];
    }
}
- (void)tapAction:(id)sender{
    if (self.dataSource.count == 0) return;
    NSInteger index = self.currentIndex;
    if (index >= (int)self.dataSource.count) {
        index = 0;
    }
    if (index < 0) {
        index = self.dataSource.count -1;
    }
    
    id source = [self.dataSource objectAtIndex:index];
    if (![source isKindOfClass:[XKBannerData class]]){
        if (_delegate && [_delegate respondsToSelector:@selector(bannerView:selectPage:)]) {
            [_delegate bannerView:self selectPage:index];
        }
        [self stopLoop];
        return;
    };
    XKBannerData *bannerData = (XKBannerData *)source;
    if ([bannerData.skipType isEqualToString:XKBannerSkipTypeActivity]) {
        if (NO == [NSString isNull:bannerData.targetParams]) {
            NSData *jsonData = [bannerData.targetParams dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *params = [dict objectForKey:@"params"];
            [MGJRouter openURL:kRouterActivity withUserInfo:params completion:nil];
        }
    }else if ([bannerData.skipType isEqualToString:XKBannerSkipTypeGoods]){
        if (NO == [NSString isNull:bannerData.targetParams]) {
            NSData *jsonData = [bannerData.targetParams dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *params = [dict objectForKey:@"params"];
            [MGJRouter openURL:kRouterGoods withUserInfo:params completion:nil];
        }
    }else if([bannerData.skipType isEqualToString:XKBannerSkipTypeUrl]){
        if (NO == [NSString isNull:bannerData.targetUrl1]) {
            NSDictionary *params = @{@"url":bannerData.targetUrl1?:@""};
            [MGJRouter openURL:kRouterWeb withUserInfo:params completion:nil];
        }
    }else{
        
    }
}

#pragma mark - Public Method
- (void)startLoop{
    if (self.dataSource.count <= 1) {
        return;
    }
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:3.0f]];
}

- (void)stopLoop{
    [self.timer setFireDate:[NSDate distantFuture]];
}
- (void)scrollToCurrentIndex:(NSInteger)currentIndex {
    self.currentIndex = currentIndex;
    [self resetLayoutImages];
}
- (void)setNeedPageControl:(BOOL)needPageControl{
    _needPageControl = needPageControl;
}
- (void)setDataSource:(NSArray *)dataSource{
    [self stopLoop];
    _dataSource = dataSource;
    _pageCount = _dataSource.count;
    if (self.needPageControl) {
        self.pageControl.numberOfPages = self.pageCount;
    }
    if (self.dataSource.count > 0) {
        [self setupImage];
    }else{
        [self.scrollView setContentSize:CGSizeMake(0, 0)];
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    
    if (self.dataSource.count > 1) {
        [self startLoop];
        self.scrollView.scrollEnabled = YES;
    }else{
        [self stopLoop];
        self.scrollView.scrollEnabled = NO;
    }
}

#pragma mark -scrollview Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat w = scrollView.frame.size.width;
    CGFloat lastX = self.lastX;
    CGFloat moveX = scrollView.contentOffset.x;
    self.lastX = moveX;
    CGFloat x1 = 0;
    CGFloat x2 = 2*CGRectGetWidth(scrollView.frame);
    if ((lastX > moveX && MIN(moveX, lastX) <= x1 && MAX(moveX, lastX) >= x1 && lastX != x1) || (lastX < moveX && MIN(moveX, lastX) <= x2 && MAX(moveX, lastX) >= x2 && lastX != x2)) {
        NSInteger index = moveX/w;
        if (self.curIndex != index) {
            if (self.curIndex < index) {//左滑
                _currentIndex +=1;
            }else{//右滑
                _currentIndex -=1;
            }
            if (self.dataSource.count > 0) [self resetLayoutImages];
            self.curIndex = self.scrollView.contentOffset.x/w;
        }
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopLoop];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startLoop];
}
#pragma mark - lazy
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (XKPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[XKPageControl alloc] init];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.pageIndicatorTintColor = HexRGB(0xffffff, 0.3f);
        _pageControl.currentPageIndicatorTintColor = HexRGB(0xffffff, 1.0f);
        _pageControl.hidesForSinglePage = YES;
    }
    return _pageControl;
}

- (UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.clipsToBounds = YES;
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        _leftImageView.clipsToBounds = YES;
        _leftImageView.image = [UIImage imageNamed:kPlaceholderImg];
    }
    return _leftImageView;
}

- (UIImageView *)centerImageView{
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc] init];
        _centerImageView.clipsToBounds = YES;
        _centerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _centerImageView.clipsToBounds = YES;
        _centerImageView.image = [UIImage imageNamed:kPlaceholderImg];
    }
    return _centerImageView;
}

- (UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.clipsToBounds = YES;
        _rightImageView.contentMode = UIViewContentModeScaleAspectFill;
        _rightImageView.clipsToBounds = YES;
        _rightImageView.image = [UIImage imageNamed:kPlaceholderImg];
    }
    return _rightImageView;
}

- (UITapGestureRecognizer *)tapGesture{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    }
    return _tapGesture;
}

@end
