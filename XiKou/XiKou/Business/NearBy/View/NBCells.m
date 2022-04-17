//
//  NBShopBriefCell.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/19.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "NBCells.h"
#import "XKUIUnitls.h"

@implementation NBShopBriefCell
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize distanceLabel = _distanceLabel;
@synthesize imageView = _imageView;
@synthesize imageView2 = _imageView2;
@synthesize imageView3 = _imageView3;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.detailTextLabel];
    [self.contentView addSubview:self.distanceLabel];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.imageView2];
    [self.contentView addSubview:self.imageView3];
    self.layer.cornerRadius = 10.0f;
    self.layer.masksToBounds = YES;
}


#pragma mark getter
- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.textColor = COLOR_TEXT_BROWN;
        _detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        _detailTextLabel.textAlignment = NSTextAlignmentRight;
        
    }
    return _detailTextLabel;
}

- (UILabel *)distanceLabel{
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.textColor = HexRGB(0x999999, 1.0f);
        _distanceLabel.textAlignment = NSTextAlignmentLeft;
        _distanceLabel.font = [UIFont systemFontOfSize:10.0f];
    }
    return _distanceLabel;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 2.f;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UIImageView *)imageView2{
    if (!_imageView2) {
        _imageView2 = [[UIImageView alloc] init];
        _imageView2.layer.masksToBounds = YES;
        _imageView2.layer.cornerRadius = 2.f;
        _imageView2.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView2;
}

- (UIImageView *)imageView3{
    if (!_imageView3) {
        _imageView3 = [[UIImageView alloc] init];
        _imageView3.layer.masksToBounds = YES;
        _imageView3.layer.cornerRadius = 2.f;
        _imageView3.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView3;
}

@end

@implementation NBShopBriefStyle1Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layout];
    }
    return self;
}

- (void)layout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.0f);
        make.width.mas_equalTo(scalef(200.0f));
        make.height.mas_equalTo(scalef(175.0f));
    }];
    
    [self.imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(5.0f);
        make.top.equalTo(self.imageView);
        make.width.mas_equalTo(scalef(110.0f));
        make.height.mas_equalTo(scalef(85.0f));
    }];
    
    [self.imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.width.height.equalTo(self.imageView2);
        make.bottom.equalTo(self.imageView);
    }];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView);
        make.bottom.equalTo(self.imageView.mas_top).offset(-15.0f);
        
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15.0f);
        make.top.equalTo(self.contentView).offset(21.0f);
        make.bottom.equalTo(self.distanceLabel.mas_top).offset(-7);
    }];
    
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(26.0f);
        make.right.equalTo(self.contentView).offset(-15.0f);
        make.height.mas_equalTo(12.0f);
        make.left.equalTo(self.textLabel.mas_right).offset(20);
    }];
    
   
    [self.detailTextLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];

   
   
    
    
}

@end

@implementation NBShopBriefStyle2Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layout];
    }
    return self;
}

- (void)layout{
    CGFloat width = (kScreenWidth-80.0f)/3.0f;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.0f);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(width/102.0f*80.0f);
    }];
    
    [self.imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(self.imageView);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.bottom.equalTo(self.imageView);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView);
        make.bottom.equalTo(self.imageView.mas_top).offset(-15.0f);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15.0f);
        make.top.equalTo(self.contentView).offset(21.0f);
        make.bottom.equalTo(self.distanceLabel.mas_top).offset(-7);
    }];
    
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(26.0f);
        make.right.equalTo(self.contentView).offset(-15.0f);
        make.height.mas_equalTo(12.0f);
        make.left.equalTo(self.textLabel.mas_right).offset(20);
    }];
    
    [self.detailTextLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];



}

@end

@implementation NBConsumeCell
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize textField = _textField;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.detailTextLabel];
        [self layout];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    static CGFloat margin = 15.0f;
    frame.origin.x = margin;
    frame.size.width -= 2 * frame.origin.x;
    [super setFrame:frame];
}

- (void)layout{
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20.0f);
        make.top.equalTo(self.contentView).offset(25.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel);
        make.top.equalTo(self.textLabel.mas_bottom).offset(15.0f);
        make.height.mas_equalTo(19.0f);
        make.bottom.equalTo(self.contentView).offset(-25.0f);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailTextLabel.mas_right).offset(10.0f);
        make.height.mas_equalTo(20.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-30.0f);
        make.bottom.equalTo(self.detailTextLabel);
    }];
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.textColor = HexRGB(0x444444, 1.0f);
        _detailTextLabel.font = [UIFont boldSystemFontOfSize:25.0f];
        
    }
    return _detailTextLabel;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.textColor = HexRGB(0x444444, 1.0f);
        _textField.font = [UIFont boldSystemFontOfSize:25.0f];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _textField.xk_monitor = YES;
        _textField.xk_supportWords = @"^[0-9]{1}[0-9.]*";
        _textField.xk_supportContent = XKTextSupportContentCustom;
       
    }
    return _textField;
}


@end

@implementation NBPreferentialCell
@synthesize textLabel = _textLabel;
@synthesize selectBtn = _selectBtn;
@synthesize textField = _textField;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.selectBtn];
        [self.selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self layout];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    static CGFloat margin = 15.0f;
    frame.origin.x = margin;
    frame.size.width -= 2 * frame.origin.x;
    [super setFrame:frame];
}

- (void)layout{
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20.0f);
        make.top.equalTo(self.contentView).offset(21.0f);
        make.width.height.mas_equalTo(18.0f);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectBtn.mas_right).offset(10.0f);
        make.height.mas_equalTo(14.0f);
        make.centerY.equalTo(self.selectBtn);
    }];
   
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel.mas_right).offset(10.0f);
        make.right.equalTo(self.contentView).offset(-20.0f);
        make.height.mas_equalTo(14.0f);
        make.centerY.equalTo(self.textLabel);
    }];
}

- (void)selectAction:(id)sender{
    if (self.selectBtn.isSelected) {
        self.selectBtn.selected = NO;
        self.textField.hidden = YES;
    }else{
        self.selectBtn.selected = YES;
        self.textField.hidden = NO;
    }
    if (self.selectBlock) {
        self.selectBlock();
    }
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _textLabel;
}

- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] init];
        [_selectBtn setImage:[UIImage imageNamed:@"Oval_deselect"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"Oval_select"] forState:UIControlStateSelected];
    }
    return _selectBtn;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.font = [UIFont systemFontOfSize:12.0f];
        _textField.textColor = HexRGB(0x444444, 1.0f);
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.hidden = YES;
        _textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _textField.xk_monitor = YES;
        _textField.xk_supportWords = @"^[0-9]{1}[0-9.]*";
        _textField.xk_supportContent = XKTextSupportContentCustom;
    }
    return _textField;
}


@end

@implementation NBBalanceCell
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize bottomLine = _bottomLine;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.detailTextLabel];
        [self.contentView addSubview:self.bottomLine];
        [self layout];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    static CGFloat margin = 15.0f;
    frame.origin.x = margin;
    frame.size.width -= 2 * frame.origin.x;
    [super setFrame:frame];
}

- (void)layout{
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20.0f);
        make.top.equalTo(self.contentView).offset(23.0f);
        make.height.mas_equalTo(15.0f);
        make.centerY.equalTo(self.contentView);
    }];
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-20.0f);
        make.height.mas_equalTo(14.0f);
        make.width.mas_equalTo(200.0f);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-20.0f);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5f);
    }];
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.textAlignment = NSTextAlignmentRight;
        _detailTextLabel.textColor = HexRGB(0xcccccc, 1.0f);
        _detailTextLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        
    }
    return _detailTextLabel;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = HexRGB(0xe4e4e4, 1.0f);
    }
    return _bottomLine;
}

@end

