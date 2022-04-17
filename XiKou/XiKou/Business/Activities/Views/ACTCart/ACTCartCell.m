//
//  ACTCartCell.m
//  XiKou
//
//  Created by L.O.U on 2019/7/9.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTCartCell.h"
#import "XKActivityCartService.h"
@interface ACTCartCell ()

@property (nonatomic, strong) UIImageView *coverView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *desLabel;

@property (nonatomic, strong) UILabel *bargainLabel;

@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, strong) UIButton *increaseBtn;

@property (nonatomic, strong) UIButton *decreaseBtn;

@property (nonatomic, strong) UILabel *numLabel;

@end

@implementation ACTCartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = COLOR_VIEW_GRAY;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = COLOR_LINE_GRAY;
    
    [self.contentView xk_addSubviews:@[self.coverView,self.nameLabel,self.bargainLabel,
                                    self.desLabel,self.priceLabel,self.selectBtn,
                                    self.increaseBtn,self.decreaseBtn,self.numLabel,line]];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.height.mas_equalTo(.5);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line);
        make.width.mas_equalTo(21);
        make.height.mas_equalTo(70);
        make.top.equalTo(line.mas_bottom).offset(15);
        make.bottom.equalTo(self.contentView).offset(-25);
    }];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(70);
        make.left.equalTo(self.selectBtn.mas_right).offset(10);
        make.top.equalTo(self.selectBtn);
    }];
    [self.priceLabel setPreferredMaxLayoutWidth:150];
    [self.priceLabel setContentCompressionResistancePriority:MASLayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(line);
        make.height.mas_equalTo(10);
        make.top.equalTo(self.coverView).offset(9);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverView).offset(5);
        make.left.equalTo(self.coverView.mas_right).offset(10);
        make.right.equalTo(self.priceLabel.mas_left).offset(-10);
    }];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceLabel);
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
    }];
    
    [self.bargainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.bottom.equalTo(self.coverView).offset(-5);
        make.height.mas_equalTo(15);
    }];
    
    [self.increaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(26);
        make.right.equalTo(self.priceLabel);
        make.bottom.equalTo(self.coverView);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.increaseBtn);
        make.width.mas_equalTo(29);
        make.right.equalTo(self.increaseBtn.mas_left);
    }];
    [self.decreaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(self.increaseBtn);
        make.right.equalTo(self.numLabel.mas_left);
    }];
}

- (void)setModel:(ACTCartGoodModel *)model{
    _model = model;
    _nameLabel.text  = _model.commodityName;
    [_coverView sd_setImageWithURL:[NSURL URLWithString:_model.goodsImageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    _priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[_model.activityPrice doubleValue]/100];
    _desLabel.text   = [NSString stringWithFormat:@"%@ %@ 原价:¥%.2f ",_model.commodityModel,_model.commoditySpec,[_model.salePrice doubleValue]/100];
    _numLabel.text   = [NSString stringWithFormat:@"%ld",model.selectNum];
    if (model.selected) {
        _selectBtn.selected = YES;
        _bargainLabel.hidden = NO;
        
        NSArray *strings = @[[NSString stringWithFormat:@" 折扣: %@折 ",_model.rateOne],
                             [NSString stringWithFormat:@" 折扣: %@折 ",_model.rateTwo],
                             [NSString stringWithFormat:@" 折扣: %@折 ",_model.rateThree]];
        NSArray *imgs = @[@"selected1",@"selected2",@"selected3"];
        _bargainLabel.text = strings[[_model.indexs.lastObject integerValue]];
        [_selectBtn setImage:[UIImage imageNamed:imgs[[_model.indexs.lastObject integerValue]]] forState:UIControlStateSelected];
    }else{
        
        _bargainLabel.hidden = YES;
        _selectBtn.selected = NO;
    }
}

#pragma mark action
- (void)selectAction:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(cartSelected:andSelected:)]) {
        [_delegate cartSelected:self andSelected:!_model.selected];
    }
}

- (void)numChangeAction:(UIButton *)sender{
    if (sender == self.increaseBtn) {
        if (_model.maxNum == 3 && _model.selected) {
            XKShowToast(@"最多选择三个产品");
            return;
        }
        _model.selectNum ++;
    }else{
        if (_model.selectNum == 1) {
            return;
        }
        _model.selectNum --;
    }
    sender.enabled = NO;
    if (_delegate && [_delegate respondsToSelector:@selector(cartNumberUpdate:andNumber:complete:)]) {
        [_delegate cartNumberUpdate:self andNumber:_model.selectNum complete:^{
            sender.enabled = YES;
        }];
    }
}
#pragma mark lazy
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = Font(12.f);
        _nameLabel.textColor = COLOR_TEXT_BLACK;
    }
    return _nameLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.font = FontMedium(12.f);
        _priceLabel.textColor = COLOR_TEXT_BLACK;
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}

- (UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel = [UILabel new];
        _desLabel.font = Font(10.f);
        _desLabel.textColor = COLOR_TEXT_GRAY;
    }
    return _desLabel;
}

- (UILabel *)bargainLabel{
    if (!_bargainLabel) {
        _bargainLabel = [UILabel new];
        _bargainLabel.font = Font(10.f);
        _bargainLabel.textColor = COLOR_TEXT_RED;
        _bargainLabel.textAlignment = NSTextAlignmentCenter;
        _bargainLabel.layer.cornerRadius = 1.f;
        _bargainLabel.layer.borderColor  = COLOR_TEXT_RED.CGColor;
        _bargainLabel.layer.borderWidth  = 0.5;
    }
    return _bargainLabel;
}

- (UIImageView *)coverView{
    if (!_coverView) {
        _coverView = [UIImageView new];
        _coverView.contentMode = UIViewContentModeScaleAspectFill;
        _coverView.layer.masksToBounds = YES;
        _coverView.layer.cornerRadius  = 2.f;
    }
    return _coverView;
}

- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
        [_selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (UIButton *)increaseBtn{
    if (!_increaseBtn) {
        _increaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_increaseBtn setImage:[UIImage imageNamed:@"increase"] forState:UIControlStateNormal];
        [_increaseBtn addTarget:self action:@selector(numChangeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _increaseBtn;
}

- (UIButton *)decreaseBtn{
    if (!_decreaseBtn) {
        _decreaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_decreaseBtn setImage:[UIImage imageNamed:@"decrease"] forState:UIControlStateNormal];
        [_decreaseBtn addTarget:self action:@selector(numChangeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _decreaseBtn;
}

- (UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [UILabel new];
        _numLabel.font = FontMedium(15.f);
        _numLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numLabel;
}
@end
