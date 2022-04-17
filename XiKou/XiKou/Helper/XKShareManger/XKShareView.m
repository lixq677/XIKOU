//
//  XKShareView.m
//  XiKou
//
//  Created by L.O.U on 2019/7/10.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKShareView.h"
#import "XKShareManger.h"

typedef void(^completBlock)(ShareType type);

@interface XKShareView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *cancleBtn;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) ShareUIType type;

@property (nonatomic, strong) completBlock doneBlock;

@property (nonatomic, assign) CGFloat topConstant;

@property (nonatomic, assign) CGFloat contentH;

@property (nonatomic, assign) CGFloat contentW;

@property (nonatomic, strong) NSArray *plaforms;

@end

@implementation XKShareView
{
    BOOL _needPhoto;
}
- (instancetype)initWithType:(ShareUIType)type{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (self) {
        _type = type;
        _needPhoto = NO;
        self.backgroundColor = COLOR_RGB(0, 0, 0, 0.6);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];

        [self creatSubviews];

    }
    return self;
}


- (void)creatSubviews{
    
    switch (_type) {
        case ShareUICenter:
        {
            _topConstant = kScreenHeight + 32 + 20;
            _contentH    = 235 + 32 + 20;
            _contentW    = 285;
            self.contentView.layer.masksToBounds = YES;
            self.contentView.layer.cornerRadius  = 5.f;
            
            UIView *line = [UIView new];
            line.backgroundColor = COLOR_LINE_GRAY;
            
            [self xk_addSubviews:@[self.contentView,self.cancleBtn,line]];
            [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(285, 235));
                make.top.equalTo(self).offset(self.topConstant);
                make.centerX.equalTo(self);
            }];
            [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(32, 32));
                make.right.equalTo(self.contentView);
                make.bottom.equalTo(self.contentView.mas_top).offset(-20);
            }];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0.5);
                make.centerX.mas_equalTo(self.cancleBtn);
                make.top.equalTo(self.cancleBtn.mas_bottom);
                make.bottom.equalTo(self.contentView.mas_top);
            }];
            [self.contentView xk_addSubviews:@[self.titleLabel,self.contentLabel,self.collectionView]];
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView);
                make.height.mas_equalTo(46);
                make.left.equalTo(self.contentView).offset(15);
                make.right.equalTo(self.contentView).offset(-15);
            }];
            [self.contentLabel setContentHuggingPriority:MASLayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
            [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(33);
                make.right.equalTo(self.contentView).offset(-33);
                make.top.equalTo(self.titleLabel.mas_bottom).offset(25);
            }];
            [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.contentView);
                make.bottom.equalTo(self.contentView).offset(-32);
                make.height.mas_equalTo(66);
            }];
        }
            break;
        case ShareUIBottom:
        {
            [self.cancleBtn setImage:[UIImage imageNamed:@"car_cancel"] forState:UIControlStateNormal];
            [_cancleBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [_cancleBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
            
            _topConstant = kScreenHeight;
            _contentH    = 226 + [XKUIUnitls safeTop];
            _contentW    = kScreenWidth;
            [self addSubview:self.contentView];
            [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.height.mas_equalTo(self.contentH);
                make.top.equalTo(self).offset(self.topConstant);
            }];
            [self.contentView xk_addSubviews:@[self.titleLabel,self.cancleBtn,self.contentLabel,self.collectionView]];
            [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.equalTo(self.contentView);
                make.width.height.mas_equalTo(27);
            }];
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView);
                make.height.mas_equalTo(50);
                make.left.equalTo(self.contentView).offset(15);
                make.right.equalTo(self.contentView).offset(-15);
            }];
            [self.contentLabel setContentHuggingPriority:MASLayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
            [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(33);
                make.right.equalTo(self.contentView).offset(-33);
                make.top.equalTo(self.titleLabel.mas_bottom);
                make.height.mas_lessThanOrEqualTo(40.0f);
            }];
            [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.contentView);
                make.top.equalTo(self.contentLabel.mas_bottom).offset(40);
                make.height.mas_equalTo(66);
            }];
        }
            break;
        default:
            break;
    }
    [self layoutIfNeeded];
}

- (void)showWithTitle:(NSString *)title
           andContent:(NSString *__nullable)content
          andPlaforms:(NSArray <XKShareItemData *> *)plaforms
          andComplete:(void(^)(ShareType type))complete{
    
    if (title) {
        self.titleLabel.text = title;
    }
    if (content) {
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = 10;
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:content attributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:HexRGB(0x9b9b9b, 1.0f)}];

        self.contentLabel.attributedText = attString;
        self.contentLabel.textAlignment  = NSTextAlignmentCenter;
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(25.0f);
        }];
    }
    self.plaforms = plaforms;
    [self.collectionView reloadData];
    @weakify(self);
    self.doneBlock = ^(ShareType type) {
        if (type == SharePhoto) {
            @strongify(self);
            [UIView animateWithDuration:.3 animations:^{
                [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self).offset(self.topConstant);
                }];
                self.backgroundColor = COLOR_RGB(0, 0, 0, 0);
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                complete(type);
                [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [self removeFromSuperview];
            }];
        }else{
            complete(type);
        }
    };
    [self show];
}

- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.3 animations:^{
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (self.type == ShareUICenter) {
                make.top.equalTo(self).offset(kScreenHeight/2-self.contentH/2);
            }else{
                make.top.equalTo(self).offset(kScreenHeight - self.contentH);
            }
        }];
        self.backgroundColor = COLOR_RGB(0, 0, 0, 0.6);
        [self layoutIfNeeded];
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:.3 animations:^{
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(self.topConstant);
        }];
        self.backgroundColor = COLOR_RGB(0, 0, 0, 0);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}
#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.contentView]) {
        return NO;
    }
    return YES;
}

#pragma mark collcetionView delegate && dataSouce
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.plaforms.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XKShareCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKShareCell" forIndexPath:indexPath];

    XKShareItemData *itemData = self.plaforms[indexPath.item];
    cell.titleLabel.text = itemData.title;
    cell.imageView.image = [UIImage imageNamed:itemData.imgName];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(50,66);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    NSInteger itemNum = self.plaforms.count;
    NSInteger spaceNum = itemNum + 1;
    CGFloat magin = (_contentW - 50*itemNum)/spaceNum;
    
    return magin;

}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    NSInteger itemNum = self.plaforms.count;
    
    NSInteger spaceNum = itemNum + 1;
    CGFloat magin = (_contentW - 50*itemNum)/spaceNum;
    
    return UIEdgeInsetsMake(0, magin, 0, magin);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.doneBlock(indexPath.item);
}

#pragma mark lazy ------------
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = FontMedium(16.f);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"提示";
        _titleLabel.backgroundColor     = [UIColor whiteColor];
        _titleLabel.layer.shadowColor   = COLOR_RGB(228, 228, 228, 1).CGColor;
        _titleLabel.layer.shadowOffset  = CGSizeMake(0,0.5);
        _titleLabel.layer.shadowOpacity = 1;
        _titleLabel.layer.shadowRadius  = 0;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.font = Font(13.f);
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIButton *)cancleBtn{
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleBtn setImage:[UIImage imageNamed:@"cancle"] forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[XKShareCell class] forCellWithReuseIdentifier:@"XKShareCell"];
    }
    return _collectionView;
}
@end

@implementation XKShareCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLabel];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.height.with.mas_equalTo(40);
            make.centerX.equalTo(self.contentView);
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.top.equalTo(self.imageView.mas_bottom);
        }];
    }
    return self;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius  = 2.f;
    }
    return _imageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 10];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end

@implementation XKShareItemData

@end
