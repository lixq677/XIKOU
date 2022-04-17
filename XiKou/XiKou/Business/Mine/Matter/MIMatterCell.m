//
//  MIMatterCell.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/4.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIMatterCell.h"
#import "XKUIUnitls.h"
#import "XCImageCell.h"

@interface  MIMatterFlowLayout: UICollectionViewFlowLayout

@property (nonatomic,strong) NSArray *attrs;

@property (nonatomic,assign,readonly)CGSize esSize;

@end

@implementation MIMatterFlowLayout

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
    _esSize = CGSizeMake(AW, ((cellCount-1)/lineCount)*(height+space) + height);
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrs;
}

@end




@interface MIMatterCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,strong)MIMatterFlowLayout *fl;

@end

@implementation MIMatterCell
@synthesize imageView = _imageView;
@synthesize nameLabel = _nameLabel;
@synthesize timeLabel = _timeLabel;
@synthesize collectionView = _collectionView;
@synthesize signatureLabel = _signatureLabel;
@synthesize saveBtn = _saveBtn;
@synthesize shareBtn = _shareBtn;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self layout];
        
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.signatureLabel];
    [self.contentView addSubview:self.saveBtn];
    [self.contentView addSubview:self.shareBtn];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[XCImageCell class] forCellWithReuseIdentifier:@"XCImageCell"];
}


- (void)layout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.top.mas_equalTo(15.0f);
        make.width.height.mas_equalTo(40.0f);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20.0f);
        make.left.mas_equalTo(self.imageView.mas_right).offset(10.0f);
        make.height.mas_equalTo(14.0f);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(6.0f);
        make.height.mas_equalTo(12.0f);
    }];
    [self.signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20.0f);
        make.right.equalTo(self.contentView).offset(-20.0f);
        make.height.mas_equalTo(40.0f);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(10.0f);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.signatureLabel);
        make.top.mas_equalTo(self.signatureLabel.mas_bottom).offset(10.0f);
        make.height.mas_equalTo(180);
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.collectionView);
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(18.0f);
        make.width.mas_equalTo(90.0f);
        make.height.mas_equalTo(35.0f);
        make.bottom.equalTo(self.contentView).mas_offset(-18.0f);
    }];
    
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.shareBtn.mas_left).offset(-10.0f);
        make.top.width.height.equalTo(self.shareBtn);
    }];
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images.count;
}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XCImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XCImageCell" forIndexPath:indexPath];
    cell.imageView.image = [self.images objectAtIndex:indexPath.row];
    return cell;
}


- (void)sizeToFit{
    NSUInteger cellCount = self.images.count;
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


- (void)setImages:(NSArray<UIImage *> *)images{
    _images = images;
    [self.collectionView reloadData];
}


#pragma mark getter or setter
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.cornerRadius = 20.0f;
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


- (UILabel *)signatureLabel{
    if (!_signatureLabel) {
        _signatureLabel = [[UILabel alloc] init];
        _signatureLabel.textColor = HexRGB(0x444444, 1.0f);
        _signatureLabel.font = [UIFont systemFontOfSize:14.0f];
        _signatureLabel.numberOfLines = 0;
    }
    return _signatureLabel;
}


- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.backgroundColor = COLOR_TEXT_BROWN;
        _saveBtn.layer.cornerRadius = 2.0f;
        [_saveBtn setTitle:@"一键保存" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
        [[_saveBtn titleLabel] setFont:[UIFont systemFontOfSize:12.0f]];
    }
    return _saveBtn;
}

- (UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.backgroundColor = HexRGB(0x444444, 1.0f);
        _shareBtn.layer.cornerRadius = 2.0f;
        [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        [_shareBtn setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
        [[_shareBtn titleLabel] setFont:[UIFont systemFontOfSize:12.0f]];
       
    }
    return _shareBtn;
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
    }
    return _collectionView;
}

- (MIMatterFlowLayout *)fl{
    if (!_fl) {
        _fl = [[MIMatterFlowLayout alloc] init];
    }
    return _fl;
}

@end
