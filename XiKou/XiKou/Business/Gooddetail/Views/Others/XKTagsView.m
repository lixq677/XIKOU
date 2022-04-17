//
//  XKTagsView.m
//  XiKou
//
//  Created by L.O.U on 2019/7/8.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKTagsView.h"

@implementation XKTagsView
{
    NSMutableArray *_labels;
    UIView *_topLine;
    UIView *_bottomLine;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _labels = [NSMutableArray array];
        
        _topLine = [UIView new];
        _topLine.backgroundColor = COLOR_LINE_GRAY;

        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = COLOR_LINE_GRAY;

        [self xk_addSubviews:@[_topLine,_bottomLine]];
        [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self);
            make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        }];
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self).offset(-1/[UIScreen mainScreen].scale);
            make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        }];
        _topLine.hidden = YES;
        _topLine.hidden = YES;
    }
    return self;
}

- (void)setTitles:(NSArray<NSString *> *)titles{
    _titles = titles;
    _topLine.hidden = NO;
    _topLine.hidden = NO;
    [_labels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger orginalCount = _labels.count;
    NSInteger nowCount     = _titles.count;
    NSInteger needAddCount = nowCount - orginalCount;
    if (needAddCount > 0) {
        for (int i = 0; i<needAddCount; i++) {
            XKTagVew *tagView = [[XKTagVew alloc]init];
            tagView.tag = i;
            [_labels addObject:tagView];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [tagView addGestureRecognizer:tapGesture];
        }
    }
    [self layout];
}

- (void)tapAction:(UIGestureRecognizer *)gesture{
    if ([self.delegate respondsToSelector:@selector(clickTagView:atIndex:)]) {
        [self.delegate clickTagView:self atIndex:gesture.view.tag];
    }
}

- (void)layout{
    CGFloat hInsert      = 2;//水平内边距
    CGFloat tagLineWidth = hInsert;//当前行所有tag总宽度
    CGFloat tagHMargin   = 25;//标签行间距
    CGFloat tagVMargin   = 8;//标签列间距
    CGFloat selfWidth    = kScreenWidth - 2*15;
    NSUInteger count     = _titles.count;
    
    __block BOOL isChange = NO;  //是否需要换行
    
    UIView *lastLabel = nil;
    
    for (NSUInteger i = 0; i<count; i ++) {
        
        XKTagVew *tagView = _labels[i];
        [self addSubview:tagView];
        tagView.value = _titles[i];
        
        CGFloat tagWidth = tagView.tagWidth;
        
        tagLineWidth +=  tagWidth;
        //当标签长度过长 限制
        if (tagLineWidth + hInsert > selfWidth) {
            isChange = YES;
            //标签的长度+整体左右间距 >= 总宽度
            if (tagView.tagWidth +2 * hInsert >= kScreenWidth) {
                tagWidth = kScreenWidth -2 * hInsert;
            }
            //换行从新设置当前行的长度
            tagLineWidth = hInsert;
        }
        
        [tagView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(tagWidth);
            
            //第一个tag设置
            if (!lastLabel) {
                make.left.mas_equalTo(hInsert);
                make.top.mas_equalTo(tagVMargin);
            }else{
                //是否换行
                if (isChange) {
                    make.left.mas_equalTo(hInsert);
                    make.top.mas_equalTo(lastLabel.mas_bottom).offset(tagVMargin);
                    isChange = NO;
                }else{
                    make.left.mas_equalTo(lastLabel.mas_right).offset(tagHMargin);
                    make.top.mas_equalTo(lastLabel.mas_top);
                }
            }
        }];
        lastLabel = tagView;
    }
    //最后一个距离底部的距离
    [lastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-tagVMargin).with.priorityHigh();
    }];
}
@end

@implementation XKTagVew
{
    UILabel *_textLabel;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        UIView *dot = [UIView new];
        dot.layer.masksToBounds = YES;
        dot.layer.cornerRadius  = 2.f;
        dot.backgroundColor = COLOR_TEXT_GRAY;
        
        _textLabel = [UILabel new];
        _textLabel.textColor = COLOR_TEXT_GRAY;
        _textLabel.font = Font(11.f);
        
        [self xk_addSubviews:@[dot,_textLabel]];
        [dot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.width.height.mas_equalTo(4);
            make.left.equalTo(self);
        }];
        [_textLabel setContentHuggingPriority:MASLayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(dot.mas_right).offset(5);
            make.right.equalTo(self);
        }];
    }
    return self;
}

- (void)setValue:(NSString *)value{
    _value = value;
    if([value isEqualToString:@"全国包邮"]){
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:value attributes:@{NSFontAttributeName:Font(11.f),NSForegroundColorAttributeName:COLOR_TEXT_GRAY}];
        //设置Attachment
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        //使用一张图片作为Attachment数据
        attachment.image = [UIImage imageNamed:@"tips"];
        attachment.bounds = CGRectMake(5.0f, -3, 15, 15);
        [attr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
        _textLabel.attributedText = attr;
    }else{
        _textLabel.text = value;
    }
}
- (CGFloat)tagWidth{
    if(_textLabel.attributedText){
        CGSize size  = [_textLabel.attributedText boundingRectWithSize:CGSizeMake(MAXFLOAT, 12.0f) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        return size.width + 15.0f;
    }else{
        return [_textLabel.text sizeWithFont:_textLabel.font].width + 10;
    }
    
}
@end
