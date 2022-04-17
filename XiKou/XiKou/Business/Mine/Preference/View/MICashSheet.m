//
//  MICashSheet.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/5.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MICashSheet.h"
#import "XKUIUnitls.h"
#import <AFViewShaker.h>

@interface MICashSheet () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UIButton *confirmBtn;

@property (nonatomic,assign)XKCashOutTime outtime;

@property (nonatomic,weak)id<MICashSheetDelegate> delegate;

@end

@implementation MICashSheet


- (instancetype)initWithDelegate:(id<MICashSheetDelegate>)delegate{
    if (self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleHeight = 45.0f;
        self.titleLabel.text = @"请选择";
        [self setup];
        [self autoLayout];
    }
    return self;
}

- (void)setup{
    [self addSubview:self.tableView];
    [self addSubview:self.confirmBtn];
    self.backgroundColor = HexRGB(0xffffff, 1.0f);
    [self.confirmBtn addTarget:self action:@selector(confirAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineBottom = [[UIView alloc] initWithFrame:CGRectMake(15.0f, 0, kScreenWidth-30.0f, 0.5f)];
    lineBottom.backgroundColor = HexRGB(0xe4e4e4, 1.0f);
    UIView *footerView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5f)];
    footerView.backgroundColor = [UIColor clearColor];
    [footerView addSubview:lineBottom];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5f)];
}

- (void)autoLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-60.0f-[XKUIUnitls safeBottom]);
        make.top.mas_equalTo(45.0f);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(20.0f);
        make.right.equalTo(self).mas_offset(-20.0f);
        make.height.mas_equalTo(40.0f);
        make.bottom.equalTo(self).offset(-30.0f-[XKUIUnitls safeBottom]);
    }];
    
}



#pragma mark tableView data source or delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifier"];
        cell.textLabel.textColor = HexRGB(0x444444, 1.0f);
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"即时到账（手续费6%）";
        if (self.outtime == XKCashOutTimeImmediately) {
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Oval_select"]];
        }else{
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Oval_deselect"]];
        }
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"3个工作日到账（手续费5%）";
        if (self.outtime == XKCashOutTimeThreeDay) {
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Oval_select"]];
        }else{
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Oval_deselect"]];
        }
    }else{
        cell.textLabel.text = @"7个工作日到账（手续费4%）";
        if (self.outtime == XKCashOutTimeAWeek) {
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Oval_select"]];
        }else{
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Oval_deselect"]];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        self.outtime = XKCashOutTimeImmediately;
    }else if (indexPath.row == 1) {
        self.outtime = XKCashOutTimeThreeDay;
    }else{
        self.outtime = XKCashOutTimeAWeek;
    }
    [tableView reloadData];
}

#pragma mark action
- (void)confirAction:(id)sender{
    if (self.outtime == XKCashOutTimeNone) {
        AFViewShaker *viewShaker =  [[AFViewShaker alloc] initWithView:self.confirmBtn];
        [viewShaker shake];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(didSelectCashOutTime:)]) {
        [self.delegate didSelectCashOutTime:self.outtime];
    }
    [self dismiss];
}


#pragma mark
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60.0f;
        _tableView.backgroundColor = HexRGB(0xffffff, 1.0f);
        _tableView.separatorColor = HexRGB(0xe4e4e4, 1.0f);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.sectionFooterHeight = 0.0f;
        _tableView.bounces = NO;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}


- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        _confirmBtn.backgroundColor = HexRGB(0x444444, 1.0f);
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    }
    return _confirmBtn;
}



- (CGFloat)sheetWidth{
    return kScreenWidth;
}

- (CGFloat)sheetHeight{
    return  368.0f+[XKUIUnitls safeBottom];
}



@end

