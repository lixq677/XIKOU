//
//  ACTBagainPersonCell.m
//  XiKou
//
//  Created by L.O.U on 2019/7/10.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTBagainPersonCell.h"
#import "XKBargainInfoModel.h"
#import "NSDate+Extension.h"

@interface ACTBagainPersonCell ()

@property (nonatomic, strong) UIImageView *coverView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *moneyLabel;

@end

@implementation ACTBagainPersonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView xk_addSubviews:@[self.coverView,self.titleLabel,self.timeLabel,self.moneyLabel]];
        [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25);
            make.width.height.mas_equalTo(35);
            make.top.equalTo(self.contentView).offset(13);
            make.bottom.equalTo(self.contentView).offset(-13);
        }];
        self.coverView.layer.masksToBounds = YES;
        self.coverView.layer.cornerRadius  = 35/2.f;
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-25);
            make.centerY.equalTo(self.contentView);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.coverView).offset(-4);
            make.height.mas_equalTo(10);
            make.left.equalTo(self.coverView.mas_right).offset(10);
            make.right.equalTo(self.moneyLabel.mas_left).offset(-10);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.coverView).offset(4);
            make.left.right.equalTo(self.timeLabel);
            make.height.mas_equalTo(12);
        }];
    }
    return self;
}

- (void)setModel:(XKBargainPersonModel *)model{
    _model = model;
    self.titleLabel.text = model.assistUserName;
    self.timeLabel.text  = [NSDate compareCurrentTime:model.createTime];
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",[model.bargainPrice doubleValue]/100];
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:model.assistUserHeadImageUrl] placeholderImage:[UIImage imageNamed:@"touxiang"] options:SDWebImageAvoidDecodeImage];
}

- (UIImageView *)coverView{
    if (!_coverView) {
        _coverView = [UIImageView new];
        _coverView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = FontMedium(12.f);
        _titleLabel.textColor = COLOR_TEXT_BLACK;
    }
    return _titleLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = Font(10.f);
        _timeLabel.textColor = COLOR_TEXT_GRAY;
    }
    return _timeLabel;
}

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.font = Font(13.f);
        _moneyLabel.textColor = COLOR_TEXT_RED;
        _moneyLabel.textAlignment = NSTextAlignmentRight;
    }
    return _moneyLabel;
}

@end

@interface ACTBagainUserCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic,strong)UILabel *textLabel;

@property (nonatomic,strong)UILabel *detailTextLabel;

@end

@implementation ACTBagainUserCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.detailTextLabel];
        CGFloat width = 0.25*(kScreenWidth-60);
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(35.0f, 35.0f));
            make.centerX.equalTo(self.contentView);
            make.top.mas_equalTo(10.0f);
        }];
        
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.imageView);
            make.left.right.equalTo(self.contentView);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(10);
            make.top.mas_equalTo(self.imageView.mas_bottom).offset(5);
        }];
        
        [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.imageView);
            make.left.right.equalTo(self.contentView);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(10);
            make.top.mas_equalTo(self.textLabel.mas_bottom).offset(10);
            make.bottom.mas_equalTo(-10);
        }];
    }
    return self;
}


- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:12.0f];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.font = [UIFont systemFontOfSize:13.0f];
        _detailTextLabel.textColor = HexRGB(0xF94119, 1.0f);
        _detailTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _detailTextLabel;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.cornerRadius = 17.5f;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}


@end


@interface ACTBagainUsersCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,strong)UICollectionViewFlowLayout *flowLayout;

@end

@implementation ACTBagainUsersCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.collectionView];
        [self.collectionView registerClass:[ACTBagainUserCell class] forCellWithReuseIdentifier:@"ACTBagainUserCell"];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(200);
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        }];
    }
    return self;
}

#pragma mark collectionView 的代理和数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.maxCount;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ACTBagainUserCell *userCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ACTBagainUserCell" forIndexPath:indexPath];
    if (indexPath.row < self.models.count) {
        XKBargainPersonModel *model = [self.models objectAtIndex:indexPath.row];
         [userCell.imageView sd_setImageWithURL:[NSURL URLWithString:model.assistUserHeadImageUrl] placeholderImage:[UIImage imageNamed:@"touxiang"] options:SDWebImageAvoidDecodeImage];
        userCell.textLabel.text = model.assistUserName;
        userCell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f元",[model.bargainPrice doubleValue]/100];
        userCell.textLabel.textColor = HexRGB(0x444444, 1.0f);
    }else{
        userCell.imageView.backgroundColor = HexRGB(0xf4f4f4, 1.0f);
        userCell.textLabel.text = @"等待助力";
        userCell.textLabel.textColor = HexRGB(0xcccccc, 1.0f);
        userCell.detailTextLabel.text = nil;
    }
    return userCell;
}

- (void)reloadData{
    [self.collectionView reloadData];
}

- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        CGFloat width = 0.25*(kScreenWidth-60);
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.estimatedItemSize = CGSizeMake(width, 100);
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HexRGB(0xffffff, 1.0f);
    }
    return _collectionView;
}

@end
