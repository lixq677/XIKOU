//
//  NBShopDetailTagCell.m
//  XiKou
//
//  Created by L.O.U on 2019/7/11.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "NBShopDetailTagCell.h"
#import "XKShopData.h"

@interface NBShopDetailTagCell ()

@property (nonatomic,strong,readonly)NSMutableArray<NBTagCell *> *cells;

@end

@implementation NBShopDetailTagCell
@synthesize cells = _cells;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setServiceModels:(NSArray<XKShopServiceModel *> *)serviceModels{
    [self.cells enumerateObjectsUsingBlock:^(NBTagCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.cells removeAllObjects];
    NSArray *names = @[@"好停车",@"免预约",@"24h服务",@"其它服务",@"地铁周边",@"无线WIFI",@"茶水免费",@"儿童餐椅",@"包装袋"];
    NSArray *imgs = @[@"storeTag1",@"storeTag2",@"storeTag3",@"storeTag6",@"storeTag4",@"storeTag5",@"storeTag6",@"storeTag7",@"storeTag8"];
    CGFloat insert = 42;
    CGFloat width  = 45;
    CGFloat space  = (kScreenWidth - insert*2 - width*4)/3;
    __block UIView *lastView = nil;
    [serviceModels enumerateObjectsUsingBlock:^(XKShopServiceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger index = 0;
        switch (obj.serviceId.intValue) {
            case 12:
                index = 0;
                break;
                
            case 13:
                index = 1;
                break;
                
            case 14:
                index = 2;
                break;
                
            case 15:
                index = 3;
                break;
                
            default:
                index = 3;
                break;
        }
        NBTagCell *cell = [NBTagCell new];
        cell.imageView.image = [UIImage imageNamed:imgs[index]];
        cell.titleLabel.text = names[index];
        [self.contentView addSubview:cell];
        [cell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(53);
            make.top.equalTo(self.contentView);
            if (idx == 0) {
                make.left.equalTo(self.contentView).offset(insert);
            }else{
                make.left.equalTo(lastView.mas_right).offset(space);
            }
        }];
        lastView = cell;
        [self.cells addObject:cell];
    }];
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-16);
    }];
}

- (NSMutableArray<NBTagCell *> *)cells{
    if (!_cells) {
        _cells = [NSMutableArray array];
    }
    return _cells;
}

@end

@implementation NBTagCell

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.height.with.mas_equalTo(35);
            make.centerX.equalTo(self);
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
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
        _titleLabel.textColor = COLOR_TEXT_GRAY;
        _titleLabel.font = Font(10.f);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
