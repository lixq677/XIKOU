//
//  XKRowPopView.m
//  XiKou
//
//  Created by L.O.U on 2019/7/11.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKRowPopView.h"

@interface XKRowCell : UITableViewCell

@end
@implementation XKRowCell
{
    UIButton *_selectBtn;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.font = Font(14.f);
        self.textLabel.textColor = COLOR_TEXT_BLACK;
        
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setImage:[UIImage imageNamed:@"Oval_deselect"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"Oval_deselect"] forState:UIControlStateHighlighted];
        [_selectBtn setImage:[UIImage imageNamed:@"Oval_select"] forState:UIControlStateSelected];
        [self.contentView addSubview:_selectBtn];
        [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(18);
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
        }];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self->_selectBtn.mas_left).offset(-10);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    _selectBtn.selected = selected;
}
@end

@interface XKRowPopView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *rows;

@property (nonatomic, assign) NSInteger selectIndex;
@end

@implementation XKRowPopView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self layoutByContentHeight:323];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60.0f;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorColor = COLOR_LINE_GRAY;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[XKRowCell class] forCellReuseIdentifier:@"XKRowCell"];
        
        [self.contentView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.sureBtn.mas_top).offset(-13);
        }];
    }
    return self;
}

- (void)showWithTitle:(NSString *)title
             andItems:(NSArray <NSString *>*)rows
       andSelectIndex:(NSInteger)selectIndex
          andComplete:(void(^)(NSInteger index))complete{
    _selectIndex = selectIndex;
    self.titleLabel.text = title;
    self.rows = rows;
    [self.tableView reloadData];
    if (rows.count > 0 && _selectIndex < rows.count) {
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
    
    [self show];
    
    @weakify(self);
    self.sureBlock  = ^{
        @strongify(self);
        if (rows.count == 0) {
            [self dismiss];
            return ;
        }
        [UIView animateWithDuration:.3 animations:^{
            [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(kScreenHeight);
            }];
            self.backgroundColor = COLOR_RGB(0, 0, 0, 0);
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            complete(self.selectIndex);
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self removeFromSuperview];
        }];
    };
    
}

#pragma mark UITableView delegate && dataSouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XKRowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKRowCell" forIndexPath:indexPath];
//    if (!cell) {
//        cell = [[XKRowCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XKRowCell"];
//    }
    cell.textLabel.text = _rows[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    NSArray *cells = [tableView visibleCells];
    for (UITableViewCell *cell in cells) {
        cell.selected = ([tableView indexPathForCell:cell] == indexPath);
    }
    self.selectIndex = indexPath.row;
}

@end

