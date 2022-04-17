//
//  MIBasicCell.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/12.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIBasicCell.h"
#import "XKUIUnitls.h"
#import "UIButton+FillColor.h"
#import "XKCustomAlertView.h"

@implementation MIBasicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        self.textLabel.font = [UIFont systemFontOfSize:15.0f];
        self.textLabel.textColor = HexRGB(0x444444, 1.0f);
        self.detailTextLabel.textColor = HexRGB(0xcccccc, 1.0f);
        self.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.left = 20.0f;
    if (self.detailTextLabel.left < self.textLabel.right) {
        NSInteger dif = self.textLabel.right + 20.0f - self.detailTextLabel.left;
        self.detailTextLabel.left = self.textLabel.right + 20.0f;
        self.detailTextLabel.width -= dif;
    }
}

@end

@implementation MIBasicAvatarCell

- (void)layoutSubviews{
    [super layoutSubviews];
    self.detailTextLabel.left = 72.0f;
    self.imageView.width = 50.0f;
    self.imageView.height = 50.0f;
    self.imageView.right = CGRectGetWidth(self.bounds) - 43.0f;
    self.imageView.centerY = CGRectGetHeight(self.bounds)/2.0f;
    self.imageView.layer.cornerRadius = 25.0f;
    self.imageView.clipsToBounds = YES;
}

@end

@implementation MIBasicAddressCell
@synthesize nameLabel = _nameLabel;
@synthesize telLabel = _telLabel;
@synthesize addrLabel = _addrLabel;
@synthesize editBtn = _editBtn;
@synthesize defaultLabel = _defaultLabel;
@synthesize detailTextLabel = _detailTextLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.telLabel];
    [self.contentView addSubview:self.addrLabel];
    [self.contentView addSubview:self.editBtn];
    [self.contentView addSubview:self.defaultLabel];
    [self.contentView addSubview:self.detailTextLabel];
    [self.editBtn setImage:[UIImage imageNamed:@"editor"] forState:UIControlStateNormal];
    [self.editBtn addTarget:self action:@selector(editAddressAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.detailTextLabel addGestureRecognizer:tapGesture];
}

- (void)autoLayout{
     self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    [self.nameLabel setContentHuggingPriority:MASLayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.top.mas_equalTo(20.0f);
        make.height.mas_equalTo(16.0f);
        make.width.mas_lessThanOrEqualTo(100.0f);
    }];
    
    [self.telLabel setContentHuggingPriority:MASLayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.telLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.nameLabel);
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(15.0f);
        make.right.mas_lessThanOrEqualTo(self.editBtn.mas_left).offset(-20.0f);
    }];
    [self.defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(26, 15));
        make.centerY.equalTo(self.nameLabel);
        make.left.equalTo(self.telLabel.mas_right).offset(15);
    }];
    
    [self.addrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-60.0f);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10.0f);
        make.height.mas_equalTo(20.0f);
       // make.bottom.mas_equalTo(-20.f);
    }];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-25.0f);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(20.0f);
    }];
    
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-80.0f);
        make.top.mas_equalTo(self.addrLabel.mas_bottom).offset(5.0f);
        make.height.mas_equalTo(15.0f);
        make.bottom.mas_equalTo(-5.f);
    }];
}


#pragma mark action

- (void)editAddressAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(cell:editAddressWithSender:)]) {
        [self.delegate cell:self editAddressWithSender:sender];
    }
}

- (void)tapAction:(id)sender{
    XKCustomAlertView *alertView = [[XKCustomAlertView alloc] initWithType:CanleAndTitle andTitle:@"包邮范围" andContent:@"除以下地区，全国范围内包邮。新疆、西藏、海南、宁夏、青海、内蒙古以及港澳台、海外暂不支持发货，如果有需要，请联系客服。" andBtnTitle:@"知道了"];
    alertView.btnStyle = AlertBtnStyle1;
    [alertView show];
//    if ([self.delegate respondsToSelector:@selector(cell:watchAddressBoundaryWithSender:)]) {
//        [self.delegate cell:self watchAddressBoundaryWithSender:sender];
//    }
}

#pragma mark getter or setter

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = Font(15.f);
        _nameLabel.textColor = COLOR_TEXT_BLACK;
    }
    return _nameLabel;
}

- (UILabel *)telLabel{
    if (!_telLabel) {
        _telLabel = [[UILabel alloc] init];
        _telLabel.font = Font(15.f);
        _telLabel.textColor = COLOR_TEXT_BLACK;
    }
    return _telLabel;
}

- (UILabel *)addrLabel{
    if (!_addrLabel) {
        _addrLabel = [[UILabel alloc] init];
        _addrLabel.font = Font(12.f);
        _addrLabel.textColor = COLOR_TEXT_GRAY;
        _addrLabel.numberOfLines = 0;
    }
    return _addrLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.font = Font(12.f);
        _detailTextLabel.userInteractionEnabled = YES;
        
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        //使用一张图片作为Attachment数据
        attachment.image = [UIImage imageNamed:@"jingshi-2"];
        attachment.bounds = CGRectMake(0, 0, 12, 10.5);
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@" 超出配送范围，请更换地址" attributes:@{NSForegroundColorAttributeName:HexRGB(0xBB9445, 1.0f),NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}];
        [attributedString insertAttributedString:[NSAttributedString attributedStringWithAttachment:attachment] atIndex:0];
        _detailTextLabel.attributedText = attributedString;
    }
    return _detailTextLabel;
}

- (UILabel *)defaultLabel{
    if (!_defaultLabel) {
        _defaultLabel = [[UILabel alloc] init];
        _defaultLabel.font = Font(9.f);
        _defaultLabel.textColor = [UIColor whiteColor];
        _defaultLabel.backgroundColor = COLOR_TEXT_BROWN;
        _defaultLabel.textAlignment = NSTextAlignmentCenter;
        _defaultLabel.layer.masksToBounds = YES;
        _defaultLabel.layer.cornerRadius  = 2.f;
        _defaultLabel.text = @"默认";
    }
    return _defaultLabel;
}
    
- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _editBtn;
}

@end

@implementation MIPreferenceCell
@synthesize backgroud = _backgroud;
@synthesize icon = _icon;
@synthesize pricelabel = _pricelabel;
@synthesize validitylabel = _validitylabel;
@synthesize lineView = _lineView;
@synthesize scopelabel = _scopelabel;
@synthesize detailBtn = _detailBtn;
@synthesize imageView = _imageView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.backgroud];
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.pricelabel];
    [self.contentView addSubview:self.validitylabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.scopelabel];
    [self.contentView addSubview:self.detailBtn];
    [self.contentView addSubview:self.imageView];
    self.detailBtn.layer.cornerRadius = 10.5;
    self.detailBtn.layer.borderWidth = 0.5;
    [self.detailBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self.detailBtn setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
    [[self.detailBtn titleLabel] setFont:[UIFont systemFontOfSize:10.0f]];
    [self.detailBtn addTarget:self action:@selector(detailAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)autoLayout{
    self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    CGFloat left = 0,right = 0;
    if (IS_IPHONE_MIN) {
        left = scalef(25.0f);
        right = -scalef(25.0f);
    }else{
        left = 25.0f;
        right = -25.0f;
    }
    [self.backgroud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.right.mas_equalTo(right);
        make.height.mas_equalTo(120.0f);
        make.top.equalTo(self.contentView).offset(10.0f);
       // make.bottom.equalTo(self.contentView);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backgroud.mas_left).offset(20.0f);
        make.top.mas_equalTo(self.backgroud.mas_top).offset(20.0f);
        make.width.mas_equalTo(40.0f);
        make.height.mas_equalTo(40.0f);
    }];
    [self.pricelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backgroud.mas_left).offset(70.0f);
        make.top.mas_equalTo(self.backgroud.mas_top).offset(23.0f);
        make.height.mas_equalTo(18.0f);
    }];
    
    [self.validitylabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pricelabel);
        make.top.equalTo(self.backgroud).offset(49.0f);
        make.height.mas_equalTo(10.0f);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.backgroud).offset(70.0f);
        make.top.equalTo(self.backgroud).offset(80.0f);
        make.right.equalTo(self.backgroud).offset(-16.0f);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    [self.scopelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backgroud).offset(70.0f);
        make.top.equalTo(self.backgroud).offset(93.0f);
        make.height.mas_equalTo(14.0f);
    }];
    
    [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backgroud).offset(-15.0f);
        make.top.equalTo(self.backgroud).offset(20.0f);
        make.width.mas_equalTo(50.0f);
        make.height.mas_equalTo(21.0f);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(64.0f);
        make.top.right.equalTo(self.backgroud);
    }];
}

#pragma mark action

- (void)detailAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(cell:detailWithSender:)]) {
        [self.delegate cell:self detailWithSender:sender];
    }
}

#pragma mark getter or setter

- (UIImageView *)backgroud{
    if (!_backgroud) {
        _backgroud = [[UIImageView alloc] init];
    }
    return _backgroud;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
}

- (UILabel *)pricelabel{
    if (!_pricelabel) {
        _pricelabel = [[UILabel alloc] init];
        _pricelabel.font = [UIFont systemFontOfSize:10.0f];
        _pricelabel.textColor = HexRGB(0xffffff, 1.0f);
    }
    return _pricelabel;
}

- (UILabel *)validitylabel{
    if (!_validitylabel) {
        _validitylabel = [[UILabel alloc] init];
        _validitylabel.font = [UIFont systemFontOfSize:13.0f];
        _validitylabel.textColor = HexRGB(0xffffff, 1.0f);
    }
    return _validitylabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HexRGB(0xffffff, 0.2f);
    }
    return _lineView;
}

- (UILabel *)scopelabel{
    if (!_scopelabel) {
        _scopelabel = [[UILabel alloc] init];
        _scopelabel.font = [UIFont systemFontOfSize:11.0f];
        _scopelabel.textColor = HexRGB(0xffffff, 1.0f);
        _scopelabel.numberOfLines = 0;
    }
    return _scopelabel;
}

- (UIButton *)detailBtn{
    if (!_detailBtn) {
        _detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailBtn.clipsToBounds = YES;
        _detailBtn.layer.cornerRadius = 10.5f;
        _detailBtn.userInteractionEnabled = NO;
    }
    return _detailBtn;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_p_unvalid"]];
    }
    return _imageView;
}

@end


@interface MIConcernCell ()

@property (nonatomic,strong)UITapGestureRecognizer *tapGesture;

@end

@implementation MIConcernCell
@synthesize icon = _icon;
@synthesize namelabel = _namelabel;
@synthesize describelabel = _describelabel;
@synthesize concernBtn = _concernBtn;
@synthesize tapGesture = _tapGesture;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.namelabel];
    [self.contentView addSubview:self.describelabel];
    [self.contentView addSubview:self.concernBtn];
    
    self.icon.userInteractionEnabled = YES;
    [self.icon addGestureRecognizer:self.tapGesture];

    self.concernBtn.layer.cornerRadius = 14.5;
    self.concernBtn.layer.borderWidth = 1.0;
    self.concernBtn.layer.borderColor = HexRGB(0x999999, 1.0f).CGColor;
    [self.concernBtn setTitle:@"取消关注" forState:UIControlStateNormal];
    [self.concernBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    self.concernBtn.clipsToBounds = YES;
    [self.concernBtn setTitleColor:HexRGB(0x999999, 1.0f) forState:UIControlStateNormal];
    [self.concernBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.concernBtn setBackgroundColor:HexRGB(0x444444, 1.0f) forState:UIControlStateHighlighted];
    
    [self.concernBtn addTarget:self action:@selector(concernAction:) forControlEvents:UIControlEventTouchUpInside];
    
    @weakify(self);
    [RACObserve(self.concernBtn,highlighted) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([(NSNumber *)x boolValue]) {
            self.concernBtn.layer.borderColor = [HexRGB(0x444444, 1.0f) CGColor];
        }else{
            self.concernBtn.layer.borderColor = [HexRGB(0x999999, 1.0f) CGColor];
        }
    }];
}

- (void)autoLayout{
    self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);

    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(20.0f);
        make.top.mas_equalTo(self.contentView.mas_top).offset(19.0f);
        make.width.mas_equalTo(42.0f);
        make.height.mas_equalTo(42.0f);
    }];
    
    [self.namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(77.0f);
        make.top.mas_equalTo(self.contentView.mas_top).offset(22.0f);
        make.width.mas_equalTo(self.contentView.mas_width).offset(-70.0f-109.0f);
        make.height.mas_equalTo(17.0f);
    }];
    
    [self.describelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.namelabel);
        make.top.mas_equalTo(self.contentView.mas_top).offset(46.0f);
        make.width.equalTo(self.namelabel);
        make.height.mas_equalTo(12.0f);
    }];
    
    [self.concernBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(25.0f);
        make.right.mas_equalTo(self.contentView.right).offset(-20.0f);
        make.width.mas_equalTo(70.0f);
        make.height.mas_equalTo(29.0f);
    }];
}

#pragma mark action

- (void)concernAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(cell:clickConcernWithSender:)]) {
        [self.delegate cell:self clickConcernWithSender:sender];
    }
}


- (void)tapAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(cell:clickAvatarWithSender:)]) {
        [self.delegate cell:self clickAvatarWithSender:sender];
    }
}

#pragma mark getter or setter

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.layer.cornerRadius = 21;
        _icon.layer.masksToBounds = YES;
    }
    return _icon;
}

- (UILabel *)namelabel{
    if (!_namelabel) {
        _namelabel = [[UILabel alloc] init];
        _namelabel.font = [UIFont systemFontOfSize:15.0f];
        _namelabel.textColor = HexRGB(0x444444, 1.0f);
    }
    return _namelabel;
}

- (UILabel *)describelabel{
    if (!_describelabel) {
        _describelabel = [[UILabel alloc] init];
        _describelabel.font = [UIFont systemFontOfSize:11.0f];
        _describelabel.textColor = HexRGB(0x999999, 1.0f);
    }
    return _describelabel;
}

- (UIButton *)concernBtn{
    if (!_concernBtn) {
        _concernBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _concernBtn;
}

- (UITapGestureRecognizer *)tapGesture{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    }
    return _tapGesture;
}

@end

@interface MITaskCell ()

@end

@implementation MITaskCell
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize imageView = _imageView;
@synthesize finishBtn = _finishBtn;
@synthesize taskValueLabel = _taskValueLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self layout];
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.detailTextLabel];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.finishBtn];
    [self.contentView addSubview:self.taskValueLabel];
}


- (void)layout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.width.height.mas_equalTo(35.0f);
        make.top.mas_equalTo(18.0f);
        make.centerY.equalTo(self.contentView);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(10.0f);
        make.top.equalTo(self.imageView);
        make.height.mas_equalTo(14.0f);
    }];
    
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel);
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(8.0f);
        make.height.mas_equalTo(12.0f);
    }];
    
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15.0f);
        make.height.mas_equalTo(scalef(25.0f));
        make.width.mas_equalTo(60.0f);
        make.centerY.equalTo(self.contentView);
    }];
    [self.taskValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.finishBtn.mas_left).offset(-10.0f);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)clickForFinish:(id)sender{
    if (self.finishBlock) {
        self.finishBlock();
    }
}

#pragma mark getter
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
        _detailTextLabel.textColor = HexRGB(0x999999, 1.0f);
        _detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        
    }
    return _detailTextLabel;
}

- (UILabel *)taskValueLabel{
    if (!_taskValueLabel) {
        _taskValueLabel = [[UILabel alloc] init];
        _taskValueLabel.textColor = HexRGB(0xcccccc, 1.0f);
        _taskValueLabel.font = [UIFont systemFontOfSize:14.0f];
        _taskValueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _taskValueLabel;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _finishBtn.layer.cornerRadius = scalef(12.5f);
        _finishBtn.clipsToBounds = YES;
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [_finishBtn setTitle:@"去完成" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
        [_finishBtn setBackgroundColor:HexRGB(0x444444, 1.0f) forState:UIControlStateNormal];
        
        [_finishBtn setTitle:@"已完成" forState:UIControlStateDisabled];
        [_finishBtn setTitleColor:HexRGB(0x999999, 1.0f) forState:UIControlStateDisabled];
        [_finishBtn setBackgroundColor:COLOR_VIEW_GRAY forState:UIControlStateDisabled];
        
        [_finishBtn addTarget:self action:@selector(clickForFinish:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}
@end
