//
//  CTBaseCell.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/24.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "CTBaseCell.h"
#import "XKUIUnitls.h"
#import "XCImageCell.h"
#import <SDWebImage.h>

/***********设计师************/
@interface CTDesignerCell ()

@property (nonatomic,strong)UIImageView *ornamentImageView;

@end

@implementation CTDesignerCell
@synthesize imageView = _imageView;
@synthesize nameLabel = _nameLabel;
@synthesize pinyinLabel = _pinyinLabel;
@synthesize addBtn = _addBtn;
@synthesize commentsBtn = _commentsBtn;
@synthesize thumbsupBtn = _thumbsupBtn;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.pinyinLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.commentsBtn];
    [self.contentView addSubview:self.thumbsupBtn];
    [self.contentView addSubview:self.addBtn];
    [self.contentView addSubview:self.ornamentImageView];
}

#pragma mark getter or setter
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UIImageView *)ornamentImageView{
    if (!_ornamentImageView) {
        _ornamentImageView = [[UIImageView alloc] init];
        _ornamentImageView.image = [UIImage imageNamed:@"ornament"];
    }
    return _ornamentImageView;
}

- (UILabel *)pinyinLabel{
    if (!_pinyinLabel) {
        _pinyinLabel = [[UILabel alloc] init];
        _pinyinLabel.textColor = HexRGB(0x444444, 1.0f);
        _pinyinLabel.font = [UIFont systemFontOfSize:18.0f];
    }
    return _pinyinLabel;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HexRGB(0x444444, 1.0f);
        _nameLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _nameLabel;
}

- (UIButton *)commentsBtn{
    if (!_commentsBtn) {
        _commentsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentsBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [_commentsBtn setTitleColor:HexRGB(0x999999, 1.0f) forState:UIControlStateNormal];
        [[_commentsBtn titleLabel] setFont:[UIFont systemFontOfSize:12.0f]];
        _commentsBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _commentsBtn.userInteractionEnabled = NO;
    }
    return _commentsBtn;
}

- (UIButton *)thumbsupBtn{
    if (!_thumbsupBtn) {
        _thumbsupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_thumbsupBtn setImage:[UIImage imageNamed:@"thumb"] forState:UIControlStateNormal];
        [_thumbsupBtn setTitleColor:HexRGB(0x999999, 1.0f) forState:UIControlStateNormal];
        [[_thumbsupBtn titleLabel] setFont:[UIFont systemFontOfSize:12.0f]];
        _thumbsupBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _thumbsupBtn.userInteractionEnabled = NO;
    }
    return _thumbsupBtn;
}

- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.userInteractionEnabled = NO;
        [_addBtn setImage:[UIImage imageNamed:@"custom_add"] forState:UIControlStateNormal];
    }
    return _addBtn;
}

@end

@implementation CTDesignerCellStyle1Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layout];
        self.ornamentImageView.hidden = YES;
    }
    return self;
}

- (void)layout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0.0f);
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(scalef(310.0f));
        make.height.mas_equalTo(scalef(375.0f));
    }];
    [self.pinyinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView);
        make.height.mas_equalTo(18.0f);
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_equalTo(15.0f);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pinyinLabel);
        make.height.mas_equalTo(12.0f);
        make.top.mas_equalTo(self.pinyinLabel.mas_bottom).mas_equalTo(7.0f);
    }];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.imageView.mas_right).offset(-6.0f);
        make.height.with.mas_equalTo(16.0f);
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(15.0f);
    }];
    
    [self.commentsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel).offset(-5.0f);
        make.height.mas_equalTo(15.0f);
        make.width.mas_greaterThanOrEqualTo(50.0f);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_equalTo(20.0f);
        make.bottom.equalTo(self.contentView).offset(-30.0f);
    }];
    
    [self.thumbsupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.commentsBtn.mas_right).offset(45.0f);
        make.height.top.equalTo(self.commentsBtn);
        make.width.mas_greaterThanOrEqualTo(50.0f);
    }];
}

@end

@implementation CTDesignerCellStyle2Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layout];
        self.ornamentImageView.hidden = NO;
    }
    return self;
}

- (void)layout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(scalef(33.0f));
        make.width.mas_equalTo(scalef(215.0f));
        make.top.mas_equalTo(0.0f);
        make.height.mas_equalTo(scalef(260.0f));
    }];
    [self.ornamentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-scalef(55.0f));
        make.width.mas_equalTo(scalef(20.0f));
        make.top.mas_equalTo(0.0f);
        make.height.mas_equalTo(scalef(167.0f));
    }];
    
    [self.pinyinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView);
        make.height.mas_equalTo(18.0f);
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_equalTo(15.0f);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pinyinLabel);
        make.height.mas_equalTo(12.0f);
        make.top.mas_equalTo(self.pinyinLabel.mas_bottom).mas_equalTo(7.0f);
    }];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.imageView.mas_right).offset(-6.0f);
        make.height.with.mas_equalTo(16.0f);
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(15.0f);
    }];
    
    [self.commentsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel).offset(-5.0f);
        make.height.mas_equalTo(15.0f);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_equalTo(20.0f);
        make.bottom.equalTo(self.contentView).offset(-30.0f);
        make.width.mas_greaterThanOrEqualTo(50.0f);
    }];
    
    [self.thumbsupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.commentsBtn.mas_right).offset(45.0f);
        make.height.top.equalTo(self.commentsBtn);
        make.width.mas_greaterThanOrEqualTo(50.0f);
    }];
}

@end

@implementation CTDesignerCellStyle3Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layout];
    }
    return self;
}

- (void)layout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-scalef(33.0f));
        make.width.mas_equalTo(scalef(215.0f));
        make.top.mas_equalTo(0.0f);
        make.height.mas_equalTo(scalef(260.0f));
    }];
    [self.ornamentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(scalef(55.0f));
        //make.width.mas_equalTo(scalef(20.0f));
        make.top.mas_equalTo(0.0f);
       // make.height.mas_equalTo(scalef(260.0f));
    }];
    
    [self.pinyinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView);
        make.height.mas_equalTo(18.0f);
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_equalTo(15.0f);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pinyinLabel);
        make.height.mas_equalTo(12.0f);
        make.top.mas_equalTo(self.pinyinLabel.mas_bottom).mas_equalTo(7.0f);
    }];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.imageView.mas_right).offset(-6.0f);
        make.height.with.mas_equalTo(16.0f);
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(15.0f);
    }];
    
    [self.commentsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel).offset(-5.0f);
        make.height.mas_equalTo(15.0f);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_equalTo(20.0f);
        make.bottom.equalTo(self.contentView).offset(-30.0f);
        make.width.mas_greaterThanOrEqualTo(50.0f);
    }];
    
    [self.thumbsupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.commentsBtn.mas_right).offset(45.0f);
        make.height.top.equalTo(self.commentsBtn);
        make.width.mas_greaterThanOrEqualTo(50.0f);
    }];
}

@end

/****************商品cell******************/
@interface CTGoodsCell ()


@end

@implementation CTGoodsCell
@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize priceLabel = _priceLabel;
@synthesize progressView = _progressView;
@synthesize leftGoodsLabel = _leftGoodsLabel;
@synthesize buyBtn = _buyBtn;
@synthesize verifyLabel = _verifyLabel;
@synthesize origPriceLabel = _origPriceLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        [self autoLayout];
    }
    return self;
}

- (void)setup{
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.detailTextLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.origPriceLabel];
    [self.contentView addSubview:self.progressView];
    [self.contentView addSubview:self.leftGoodsLabel];
    [self.contentView addSubview:self.buyBtn];
    [self.imageView addSubview:self.verifyLabel];
    
    /*添加一个圆角*/
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 42.0f, 15.0f) byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(6.0f, 6.0f)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = bezierPath.CGPath;
    layer.fillColor = [HexRGB(0xbb9445, 0.6f) CGColor];
    [self.verifyLabel.layer insertSublayer:layer atIndex:0];
    
   
}

- (void)autoLayout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.mas_equalTo(14.0f);
        make.width.height.mas_equalTo(110.0f);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_equalTo(-15.0f);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(10.0f);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15.0f);
        make.top.mas_equalTo(18.0f);
    }];
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel);
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(6.0f);
        make.height.mas_equalTo(12.0f);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailTextLabel);
        make.top.mas_equalTo(self.detailTextLabel.mas_bottom).offset(19.0f);
        make.height.mas_equalTo(17.0f);
    }];
    [self.origPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.priceLabel);
        make.left.equalTo(self.priceLabel.mas_right).offset(4);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel);
        make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(10.0f);
        make.height.mas_equalTo(9.0f);
        make.width.mas_lessThanOrEqualTo(95.0f);
        make.bottom.equalTo(self.contentView).offset(-17.0f);
    }];
    [self.leftGoodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.progressView);
        make.left.mas_equalTo(self.progressView.mas_right).offset(5.0f);
        make.right.mas_equalTo(self.buyBtn.mas_left).offset(-5.0f);
    }];
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.textLabel);
        make.bottom.equalTo(self.progressView);
        make.width.mas_equalTo(70.0f);
        make.height.mas_equalTo(29.0f);
    }];
    [self.verifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0.0f);
        make.width.mas_equalTo(42.0f);
        make.height.mas_equalTo(15.0f);
    }];
    
}



#pragma mark getter or setter
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = 2.f;
    }
    return _imageView;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.font = [UIFont systemFontOfSize:14.0f];
        _textLabel.numberOfLines = 0;
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

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = COLOR_TEXT_RED;
        _priceLabel.font = FontSemibold(17.f);
    }
    return _priceLabel;
}

- (XKProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[XKProgressView alloc] init];
        _progressView.backgroundColor = HexRGB(0xfff0ed, 1.0f);
        _progressView.trackColor = HexRGB(0xf94119, 1.0f);
    }
    return _progressView;
}

- (UILabel *)leftGoodsLabel{
    if (!_leftGoodsLabel) {
        _leftGoodsLabel = [[UILabel alloc] init];
        _leftGoodsLabel.textColor = HexRGB(0x999999, 1.0f);
        _leftGoodsLabel.font = [UIFont systemFontOfSize:8.0f];
    }
    return _leftGoodsLabel;
}

- (UIButton *)buyBtn{
    if (!_buyBtn) {
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyBtn.backgroundColor = HexRGB(0x444444, 1.0f);
        _buyBtn.layer.cornerRadius = 2.0f;
        [_buyBtn setTitle:@"马上抢" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
        [_buyBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    }
    return _buyBtn;
}

- (UILabel *)verifyLabel{
    if (!_verifyLabel) {
        _verifyLabel = [[UILabel alloc] init];
        _verifyLabel.backgroundColor = [UIColor clearColor];
        _verifyLabel.textColor = HexRGB(0xffffff, 1.0f);
        _verifyLabel.text = @"已通过认证";
        _verifyLabel.font = [UIFont systemFontOfSize:9.0f];
        _verifyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _verifyLabel;
}

- (UILabel *)origPriceLabel{
    if (!_origPriceLabel) {
        _origPriceLabel = [[UILabel alloc] init];
        _origPriceLabel.textColor = COLOR_PRICE_GRAY;
        _origPriceLabel.font = Font(10.f);
    }
    return _origPriceLabel;
}

@end







@interface  CTImageFlowLayout: UICollectionViewFlowLayout

@property (nonatomic,strong) NSArray *attrs;

@end

@implementation CTImageFlowLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

- (void)prepareLayout{
    [super prepareLayout];
    NSUInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    CGFloat AW  =   [self.collectionView width];
    CGFloat width = 0;
    CGFloat height = 0;
    CGFloat space = 5.0f;
    NSUInteger lineCount = 1;
    do{
        if (cellCount == 0)break;
        if (cellCount == 1) {
            width = AW;
            height = AW;
            lineCount = 1;
        }else if (cellCount == 2 || cellCount == 4){
            width = (AW-space)/2.0f;
            height = width;
            lineCount = 2;
        }else{
            width = (AW-2*space)/3.0f;
            height = width;
            lineCount = 3;
        }
    }while(0);
    NSMutableArray *attrs = [[NSMutableArray alloc] initWithCapacity:cellCount];
    for (int row = 0; row < cellCount; row++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        CGPoint center = CGPointMake((width+space)*(row%lineCount)+0.5*width, (row/lineCount)*(height+space) + 0.5*height);
        attr.size = CGSizeMake(width, height);
        attr.center = center;
        [attrs addObject:attr];
    }
    self.attrs = attrs;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrs;
}

@end


/***************定制馆*********************/

@interface CTDesignerHallCell ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong,readonly)UICollectionView *collectionView;

@property (nonatomic,strong,readonly)UIButton *concernBtn;

@property (nonatomic,strong)CTImageFlowLayout *fl;

@end

@implementation CTDesignerHallCell
@synthesize avatarBtn = _avatarBtn;
@synthesize nameLabel = _nameLabel;
@synthesize timeLabel = _timeLabel;
@synthesize concernBtn = _concernBtn;
@synthesize collectionView = _collectionView;
@synthesize commentsBtn = _commentsBtn;
@synthesize thumbsupBtn = _thumbsupBtn;
@synthesize signatureLabel = _signatureLabel;
@synthesize worksLabel = _worksLabel;
@synthesize countLabel = _countLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self layout];
        [self.collectionView registerClass:[XCImageCell class] forCellWithReuseIdentifier:@"XCImageCell"];
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.avatarBtn];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.concernBtn];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.signatureLabel];
    [self.contentView addSubview:self.commentsBtn];
    [self.contentView addSubview:self.thumbsupBtn];
    [self.contentView addSubview:self.worksLabel];
    [self.contentView addSubview:self.countLabel];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.concernBtn addTarget:self action:@selector(concernAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.thumbsupBtn addTarget:self action:@selector(thumbsupAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentsBtn addTarget:self action:@selector(commentsAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.avatarBtn addTarget:self action:@selector(avatarAction:) forControlEvents:UIControlEventTouchUpInside];
}



- (void)layout{
    [self.avatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.top.mas_equalTo(15.0f);
        make.width.height.mas_equalTo(40.0f);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20.0f);
        make.left.mas_equalTo(self.avatarBtn.mas_right).offset(10.0f);
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
        make.top.mas_equalTo(22.0f);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20.0f);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarBtn.mas_left);
        make.right.mas_equalTo(self.concernBtn.mas_right);
        make.top.mas_equalTo(self.avatarBtn.mas_bottom).offset(15.0f);
        make.height.mas_equalTo(self.collectionView.mas_width);
    }];
    [self.worksLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.collectionView);
        make.height.mas_equalTo(15.0f);
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(18.0f);
    }];
    [self.signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.worksLabel);
        make.height.mas_lessThanOrEqualTo(40.0f);
        make.top.mas_equalTo(self.worksLabel.mas_bottom).offset(8.0f);
    }];
    [self.thumbsupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.collectionView.mas_right).offset(-20.0f);
        make.height.mas_equalTo(31.0f);
        make.width.mas_greaterThanOrEqualTo(50.0f);
        make.top.mas_equalTo(self.signatureLabel.mas_bottom).mas_offset(16.0f);
        make.bottom.equalTo(self.contentView).offset(-14.0f);
    }];
    
    [self.commentsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.thumbsupBtn.mas_left).offset(-45.0f);
        make.bottom.top.equalTo(self.thumbsupBtn);
        make.width.mas_greaterThanOrEqualTo(60.0f);
    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30.0f);
        make.right.bottom.equalTo(self.collectionView);
    }];
    
}

#pragma mark  设置CollectionView的组数
#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageUrls.count;
}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XCImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XCImageCell" forIndexPath:indexPath];
    NSURL *url = [self.imageUrls objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    return cell;
}


#pragma mark action
- (void)concernAction:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(designerHallCell:concernAction:)]) {
        [self.delegate designerHallCell:self concernAction:btn];
    }
}

- (void)thumbsupAction:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(designerHallCell:thumbupAction:)]) {
        [self.delegate designerHallCell:self thumbupAction:btn];
    }
}

- (void)commentsAction:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(designerHallCell:commentsAction:)]) {
        [self.delegate designerHallCell:self commentsAction:btn];
    }
}

- (void)avatarAction:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(designerHallCell:avatarAction:)]) {
        [self.delegate designerHallCell:self avatarAction:btn];
    }
}


- (void)sizeToFit{
    NSUInteger cellCount = self.imageUrls.count;
    CGFloat AW  =   kScreenWidth-40.0f;
    CGFloat width = 0;
    CGFloat height = 0;
    CGFloat space = 5.0f;
    NSUInteger lineCount = 1;
    do{
        if (cellCount == 0)break;
        if (cellCount == 1) {
            width = AW;
            height = AW;
            lineCount = 1;
        }else if (cellCount == 2 || cellCount == 4){
            width = (AW-space)/2.0f;
            height = width;
            lineCount = 2;
        }else{
            width = (AW-2*space)/3.0f;
            height = width;
            lineCount = 3;
        }
    }while(0);
    CGSize size = CGSizeMake(AW, ((cellCount-1)/lineCount)*(height+space) + height);
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height);
    }];
}

#pragma mark getter or setter
- (void)setImageUrls:(NSArray<NSURL *> *)imageUrls{
    if (imageUrls.count == 0) {
         _imageUrls = imageUrls;
    }else if(imageUrls.count < 4){
        _imageUrls = [imageUrls subarrayWithRange:NSMakeRange(0, 1)];
    }else{
        _imageUrls = [imageUrls subarrayWithRange:NSMakeRange(0, 4)];
    }
    [self.collectionView reloadData];
}


- (UIButton *)avatarBtn{
    if (!_avatarBtn) {
        _avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _avatarBtn.layer.cornerRadius = 20.0f;
        _avatarBtn.clipsToBounds = YES;
    }
    return _avatarBtn;
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

- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = HexRGB(0xffffff, 1.0f);
        _countLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    return _countLabel;
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
        [_concernBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_concernBtn setTitleColor:COLOR_TEXT_BROWN forState:UIControlStateNormal];
        [_concernBtn setImage:[UIImage imageNamed:@"custom_add_bt"] forState:UIControlStateNormal];
        
        [_concernBtn setTitle:@"取消关注" forState:UIControlStateSelected];
        [_concernBtn setTitleColor:HexRGB(0x444444, 1.0f) forState:UIControlStateSelected];
        [[_concernBtn titleLabel] setFont:[UIFont systemFontOfSize:12.0f]];
        _concernBtn.layer.cornerRadius = 14.5f;
        _concernBtn.layer.borderWidth = 1.0f;
        _concernBtn.layer.borderColor = [COLOR_TEXT_BROWN CGColor];
        _concernBtn.clipsToBounds = YES;
    }
    return _concernBtn;
}

- (UIButton *)commentsBtn{
    if (!_commentsBtn) {
        _commentsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentsBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [_commentsBtn setTitleColor:HexRGB(0x999999, 1.0f) forState:UIControlStateNormal];
        [[_commentsBtn titleLabel] setFont:[UIFont systemFontOfSize:12.0f]];
        _commentsBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
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
    }
    return _thumbsupBtn;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.fl];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.alwaysBounceHorizontal = NO;
        _collectionView.alwaysBounceVertical = NO;
        _collectionView.userInteractionEnabled = NO;
    }
    return _collectionView;
}

- (void)setConcern:(BOOL)concern{
    _concern = concern;
    if (concern) {
        self.concernBtn.selected = YES;
        [self.concernBtn setImage:nil forState:UIControlStateNormal];
        self.concernBtn.titleEdgeInsets = UIEdgeInsetsZero;
    }else{
        self.concernBtn.selected = NO;
        [self.concernBtn setImage:[UIImage imageNamed:@"custom_add_bt"] forState:UIControlStateNormal];
        self.concernBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    }
}

- (CTImageFlowLayout *)fl{
    if (!_fl) {
        _fl = [[CTImageFlowLayout alloc] init];
    }
    return _fl;
}

- (void)reloadData{
    [self.collectionView reloadData];
}

@end


@interface CTWorkCell ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong,readonly)UICollectionView *collectionView;

@property (nonatomic,strong)CTImageFlowLayout *fl;

@end

@implementation CTWorkCell
@synthesize timeLabel = _timeLabel;
@synthesize collectionView = _collectionView;
@synthesize commentsBtn = _commentsBtn;
@synthesize thumbsupBtn = _thumbsupBtn;
@synthesize signatureLabel = _signatureLabel;
@synthesize worksLabel = _worksLabel;
@synthesize countLabel = _countLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self layout];
        [self.collectionView registerClass:[XCImageCell class] forCellWithReuseIdentifier:@"XCImageCell"];
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.signatureLabel];
    [self.contentView addSubview:self.commentsBtn];
    [self.contentView addSubview:self.thumbsupBtn];
    [self.contentView addSubview:self.worksLabel];
    [self.contentView addSubview:self.countLabel];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.thumbsupBtn addTarget:self action:@selector(thumbsupAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentsBtn addTarget:self action:@selector(commentsAction:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)layout{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(100);
    }];
    [self.worksLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.collectionView);
        make.height.mas_equalTo(15.0f);
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(18.0f);
    }];
    [self.signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.worksLabel);
        make.height.mas_lessThanOrEqualTo(40.0f);
        make.top.mas_equalTo(self.worksLabel.mas_bottom).offset(8.0f);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.signatureLabel);
        make.top.mas_equalTo(self.signatureLabel.mas_bottom).offset(24.0f);
        make.height.mas_equalTo(12.0f);
    }];
    [self.thumbsupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.collectionView);
        make.height.mas_equalTo(31.0f);
        make.width.mas_greaterThanOrEqualTo(50.0f);
        make.top.mas_equalTo(self.signatureLabel.mas_bottom).mas_equalTo(23.0f);
        make.bottom.mas_equalTo(-14.0f);
    }];
    
    [self.commentsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.thumbsupBtn.mas_left).offset(-45.0f);
        make.bottom.top.equalTo(self.thumbsupBtn);
        make.width.mas_greaterThanOrEqualTo(60.0f);
    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30.0f);
        make.right.bottom.equalTo(self.collectionView);
    }];
    
}

#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageUrls.count;
}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XCImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XCImageCell" forIndexPath:indexPath];
    NSURL *url = [self.imageUrls objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    return cell;
}

- (void)sizeToFit{
    NSUInteger cellCount = self.imageUrls.count;
    CGFloat AW  =   kScreenWidth-40.0f;
    CGFloat width = 0;
    CGFloat height = 0;
    CGFloat space = 5.0f;
    NSUInteger lineCount = 1;
    do{
        if (cellCount == 0)break;
        if (cellCount == 1) {
            width = AW;
            height = AW;
            lineCount = 1;
        }else if (cellCount == 2 || cellCount == 4){
            width = (AW-space)/2.0f;
            height = width;
            lineCount = 2;
        }else{
            width = (AW-2*space)/3.0f;
            height = width;
            lineCount = 3;
        }
    }while(0);
    CGSize size = CGSizeMake(AW, ((cellCount-1)/lineCount)*(height+space) + height);
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height);
    }];
}

- (void)reloadData{
    [self.collectionView reloadData];
}

#pragma mark action

- (void)thumbsupAction:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(workCell:thumbupAction:)]) {
        [self.delegate workCell:self thumbupAction:btn];
    }
}

- (void)commentsAction:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(workCell:commentsAction:)]) {
        [self.delegate workCell:self commentsAction:btn];
    }
}


#pragma mark getter or setter

- (void)setImageUrls:(NSArray<NSURL *> *)imageUrls{
    if (imageUrls.count == 0) {
        _imageUrls = imageUrls;
    }else if(imageUrls.count < 4){
        _imageUrls = [imageUrls subarrayWithRange:NSMakeRange(0, 1)];
    }else{
        _imageUrls = [imageUrls subarrayWithRange:NSMakeRange(0, 4)];
    }
    [self.collectionView reloadData];
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

- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = HexRGB(0xffffff, 1.0f);
        _countLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    return _countLabel;
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


- (UIButton *)commentsBtn{
    if (!_commentsBtn) {
        _commentsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentsBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [_commentsBtn setTitleColor:HexRGB(0x999999, 1.0f) forState:UIControlStateNormal];
        [[_commentsBtn titleLabel] setFont:[UIFont systemFontOfSize:12.0f]];
        _commentsBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
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
    }
    return _thumbsupBtn;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.fl];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.alwaysBounceHorizontal = NO;
        _collectionView.alwaysBounceVertical = NO;
        _collectionView.scrollEnabled = NO;
        _collectionView.userInteractionEnabled = NO;
    }
    return _collectionView;
}

- (CTImageFlowLayout *)fl{
    if (!_fl) {
        _fl = [[CTImageFlowLayout alloc] init];
    }
    return _fl;
}

@end


@interface CTCommentsCell ()

@property (nonatomic,strong,readonly)XKDesignerCommentVoModel *voModel;

@end

@implementation CTCommentsCell
@synthesize imageView = _imageView;
@synthesize nameLabel = _nameLabel;
@synthesize timeLabel = _timeLabel;
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize retryBtn = _retryBtn;
@synthesize voModel = _voModel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        [self layout];
    }
    return self;
}

- (void)setup{
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.detailTextLabel];
    
    [self.contentView addSubview:self.retryBtn];
    
    [self.retryBtn addTarget:self action:@selector(retryAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.top.mas_equalTo(15.0f);
        make.width.height.mas_equalTo(30.0f);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView);
        make.height.mas_equalTo(12.0f);
        make.left.mas_equalTo(self.imageView.mas_right).offset(10.0f);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10.0f);
        make.height.mas_equalTo(10.0f);
        make.left.equalTo(self.nameLabel);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).offset(-20.0f);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(10.0f);
    }];
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.textLabel);
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(10.0f);
    }];
    
    [self.retryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailTextLabel);
        make.top.mas_equalTo(self.detailTextLabel.mas_bottom).offset(10.0f);
        make.width.mas_equalTo(70.0f);
        make.height.mas_equalTo(12.0f);
        make.bottom.mas_equalTo(-14.0f);
    }];
}

- (void)retryAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(commentsCell:retryAction:)]) {
        [self.delegate commentsCell:self retryAction:sender];
    }
}


- (void)setCommentVoModel:(XKDesignerCommentVoModel *)voModel{
    _voModel = voModel;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:voModel.headUrl]];
    self.nameLabel.text = voModel.userName;
    self.timeLabel.text = voModel.commentTime;
    self.textLabel.text = voModel.commentContent;
    
    if (voModel.commentStatus == XKCommentStatusFailed) {
        self.retryBtn.hidden = NO;
        self.retryBtn.enabled = YES;
    }else if (voModel.commentStatus == XKCommentStatusSending){
        self.retryBtn.hidden = NO;
        self.retryBtn.enabled = NO;
    }else{
        self.retryBtn.hidden = YES;
    }
    if([NSString isNull:voModel.replayContent]){
        self.detailTextLabel.text = nil;
    }else{
        self.detailTextLabel.text = [NSString stringWithFormat:@"%@回复:%@",voModel.name,voModel.replayContent];
    }
    if ([NSString isNull:self.detailTextLabel.text]) {
        [self.detailTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.textLabel.mas_bottom);
        }];
    }else{
        [self.detailTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.textLabel.mas_bottom).offset(10.0f);
        }];
    }
    if (self.retryBtn.hidden) {
        [self.retryBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
            make.top.mas_equalTo(self.detailTextLabel.mas_bottom);
        }];
    }else{
        [self.retryBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(14.0f);
            make.top.mas_equalTo(self.detailTextLabel.mas_bottom).offset(10.0f);
        }];
    }
    
}

#pragma mark getter or setter
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.cornerRadius = 15.0f;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
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

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.numberOfLines = 0;
        _textLabel.textColor = HexRGB(0X444444, 1.0f);
        _textLabel.font = [UIFont systemFontOfSize:14.0f];
        
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.numberOfLines = 0;
        _detailTextLabel.textColor = COLOR_TEXT_BROWN;
        _detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _detailTextLabel;
}

- (UIButton *)retryBtn{
    if (!_retryBtn) {
        _retryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_retryBtn setTitle:@"点击重试" forState:UIControlStateNormal];
        [_retryBtn setTitleColor:HexRGB(0xF94119, 1.0f) forState:UIControlStateNormal];
        [_retryBtn setTitle:@"发送中..." forState:UIControlStateDisabled];
        [_retryBtn setTitleColor:HexRGB(0xcccccc, 1.0f) forState:UIControlStateDisabled];
        _retryBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _retryBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        _retryBtn.hidden = YES;
    }
    return _retryBtn;
}

@end
