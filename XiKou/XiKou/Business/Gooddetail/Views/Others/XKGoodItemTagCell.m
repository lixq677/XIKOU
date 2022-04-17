//
//  XKGoodItemTagCell.m
//  XiKou
//
//  Created by L.O.U on 2019/8/5.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKGoodItemTagCell.h"

@implementation XKGoodItemTagCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *titles = @[@"起拍价",@"加价幅度",@"出价费"];
        UIView *lastView;
        for (int i = 0; i < titles.count; i++) {
            
            UILabel *leftLabel = [UILabel new];
            leftLabel.text     = titles[i];
            leftLabel.textColor = COLOR_TEXT_GRAY;
            leftLabel.font = Font(12.f);
            
            UILabel *rightLabel = [UILabel new];
            rightLabel.tag  = 100+i;
            rightLabel.font = Font(12.f);
            rightLabel.textColor = COLOR_TEXT_BLACK;
            
            [self.contentView xk_addSubviews:@[leftLabel,rightLabel]];
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.height.mas_equalTo(14);
                if (i%2 == 0) {
                    make.left.equalTo(self.contentView).offset(20);
                    make.width.mas_equalTo(38);
                    if (!lastView) {
                        make.top.equalTo(self.contentView).offset(10);
                    }else{
                        make.top.equalTo(lastView.mas_bottom).offset(15);
                    }
                }else{
                    make.width.mas_equalTo(62);
                    make.centerX.equalTo(self).offset(30);
                    make.top.equalTo(lastView);
                }
                if (!lastView) {
                    make.top.equalTo(self.contentView).offset(15);
                }else{
                    make.top.equalTo(lastView.mas_bottom).offset(15);
                }
            }];
            [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(leftLabel.mas_right).offset(28);
                make.top.bottom.equalTo(leftLabel);
            }];
            lastView = leftLabel;
        }
        [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-15);
        }];
    }
    return self;
}

- (void)setValues:(NSArray *)values{
    for (int i = 0; i<values.count; i++) {
        if (i < 4) {
            UILabel *label = [self viewWithTag:100+i];
            label.text = values[i];
        }
    }
}

@end
