//
//  XKSearchResultView.m
//  XiKou
//
//  Created by majia on 2019/11/4.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKSearchResultView.h"
@interface XKSearchResultView ()
@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) UILabel *rightLabel;
@property (nonatomic,strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic,strong) NSString *currentUserId;
@end
@implementation XKSearchResultView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setDefaultUI];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:self.tapGesture];
    }
    return self;
}
#pragma mark - private method
- (void)setDefaultUI {
    [self addSubview:self.textLabel];
    [self addSubview:self.rightLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self);
    }];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.equalTo(self);
    }];
}
#pragma mark - public method
- (void)reloadSearchResult:(NSString *)phone userId:(nonnull NSString *)userId  nickName:(NSString *)nickname {
    self.textLabel.text = phone.length > 0 ? phone : @"您的好友还未注册喜扣";
    self.rightLabel.text = nickname.length > 0 ? nickname : @"立即推广";
    if (nickname.length <= 0) {
        self.rightLabel.textColor = COLOR_HEX(0x20ABE5);
    }else{
        self.rightLabel.textColor = COLOR_TEXT_GRAY;
    }
    self.currentUserId = userId;
}
- (void)tapAction {
    if ([self.rightLabel.text isEqualToString:@"立即推广"]) { //没有搜到
        [MGJRouter openURL:kRouterAdvertising];
        return;
    }
    if (self.tapActionBlock) {
        self.tapActionBlock(self.textLabel.text,self.rightLabel.text,self.currentUserId);
    }
}
#pragma mark - lazy
- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = Font(16);
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.textColor = COLOR_TEXT_GRAY;
    }
    return _textLabel;
}
- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.text = @"";
        _rightLabel.textColor = COLOR_TEXT_GRAY;
        _rightLabel.font = Font(15);
    }
    return _rightLabel;
}
- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    }
    return _tapGesture;
}
@end
