//
//  XKButtonTagsView.m
//  XiKou
//
//  Created by L.O.U on 2019/7/9.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKButtonTagsView.h"

@implementation XKButtonTagsView
{
    NSMutableArray *_buttons;
    
}
- (instancetype)init{
    self = [super init];
    if (self) {
        _buttons = [NSMutableArray array];
    }
    return self;
}

- (void)setTitles:(NSArray *)titles{
    _titles = titles;
    
    [_buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger orginalCount = _buttons.count;
    NSInteger nowCount     = _titles.count;
    NSInteger needAddCount = nowCount - orginalCount;
    if (needAddCount > 0) {
        for (int i = 0; i<needAddCount; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.layer.borderColor   = COLOR_LINE_GRAY.CGColor;
            button.layer.borderWidth   = 0.5;
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius  = 2.f;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button setTitleColor:COLOR_TEXT_BLACK forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:COLOR_TEXT_BLACK] forState:UIControlStateSelected];
            [button.titleLabel setFont:FontMedium(13.f)];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_buttons addObject:button];
        }
    }
    [self layout];
}

- (void)layout{
    CGFloat hInsert      = 16;//水平内边距
    CGFloat tagLineWidth = hInsert;//当前行所有tag总宽度
    CGFloat tagHMargin   = 10;//标签行间距
    CGFloat tagVMargin   = 10;//标签列间距
    CGFloat maxWidth     = kScreenWidth;
    NSUInteger count     = _titles.count;
    
    __block BOOL isChange = NO;  //是否需要换行
    UIView *lastView = nil;
    
    for (NSUInteger i = 0; i<count; i ++) {
        
        UIButton *button = _buttons[i];
        [self addSubview:button];
        button.selected  = (i == 0);
        button.tag = 100 + i;
        [button setTitle:_titles[i] forState:UIControlStateNormal];
        [button sizeToFit];
    
        CGFloat btnWidth = button.width < 75 ? 75 : button.width;
        
        tagLineWidth +=  btnWidth;
        //标签长度过长 限制
        if (tagLineWidth + hInsert > maxWidth) {
            isChange = YES;
            //标签的长度+整体左右间距 >= 总宽度
            if (btnWidth +2 * hInsert >= maxWidth) {
                btnWidth = kScreenWidth -2 * hInsert;
            }
            tagLineWidth  = hInsert;
        }
        
        [button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(35);
            make.width.mas_equalTo(btnWidth);
            
            //第一个tag设置
            if (!lastView) {
                make.left.mas_equalTo(hInsert);
                make.top.equalTo(self);
            }else{
                //是否换行
                if (isChange) {
                    make.left.mas_equalTo(hInsert);
                    make.top.mas_equalTo(lastView.mas_bottom).offset(tagVMargin);
                    isChange = NO;
                }else{
                    make.left.mas_equalTo(lastView.mas_right).offset(tagHMargin);
                    make.top.mas_equalTo(lastView.mas_top);
                }
            }
        }];
        lastView = button;
    }
    //最后一个距离底部的距离
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
    }];
}

- (void)buttonAction:(UIButton *)button{
    self.currentIndex = button.tag - 100;
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    if (_currentIndex == currentIndex) {
        return;
    }
    _currentIndex = currentIndex;
    for (UIButton *button in _buttons) {
        button.selected = (button.tag == 100 + currentIndex);
    }
}
@end
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
