//
//  XKDatePickerView.m
//  XiKou
//
//  Created by L.O.U on 2019/7/11.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKDatePickerView.h"
#import "NSDate+Extension.h"

@interface XKDatePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) XKDatePicker *datePicker;

@property (nonatomic,strong) UILabel *timelabel;

@property (nonatomic, retain) NSDate *scrollToDate;//滚到指定日期

@end

@implementation XKDatePickerView
{
    //日期存储数组
    NSMutableArray *_yearArray;
    NSMutableArray *_monthArray;
    NSString *_dateFormatter;
    //记录位置
    NSInteger yearIndex;
    NSInteger monthIndex;
    
    NSInteger preRow;
    
    NSDate *_startDate;
    
    NSInteger maxYear;
    NSInteger minYear;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
        [self layoutByContentHeight:368];
        
        _datePicker = [[XKDatePicker alloc] init];
        _datePicker.showsSelectionIndicator = YES;
        _datePicker.delegate = self;
        _datePicker.dataSource = self;
        
        _timelabel = [UILabel new];
        _timelabel.font = FontMedium(15.f);
        _timelabel.textColor = COLOR_TEXT_BROWN;
        _timelabel.textAlignment = NSTextAlignmentCenter;
        //_timelabel.text = @"2019年06月";
        
        UIView *line = [UIView new];
        line.backgroundColor = COLOR_TEXT_BROWN;

        [self.contentView xk_addSubviews:@[_datePicker,_timelabel,line]];
        [_timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(100, 50));
            make.top.equalTo(self.titleLabel.mas_bottom).offset(13);
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.timelabel);;
            make.height.mas_equalTo(2);
        }];
        [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.timelabel.mas_bottom).offset(20);
            make.bottom.equalTo(self.sureBtn.mas_top).offset(-20);
            make.right.equalTo(self.contentView);
        }];
        [self defaultConfig];
    }
    return self;
}

- (void)showWithTitle:(NSString *)title
             andSelectDate:(nonnull NSDate *)scrollToDate
          andComplete:(nonnull void (^)(NSDate * _Nonnull))complete{
    
    self.titleLabel.text = title;
    self.scrollToDate = scrollToDate;
    [self.datePicker reloadAllComponents];
    [self getNowDate:scrollToDate animated:NO];
    [self show];
    @weakify(self);
    self.sureBlock = ^{
        @strongify(self);
        [UIView animateWithDuration:.3 animations:^{
            [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(kScreenHeight);
            }];
            self.backgroundColor = COLOR_RGB(0, 0, 0, 0);
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            complete(self.scrollToDate);
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self removeFromSuperview];
        }];
    };
   
}

-(void)defaultConfig {
    
    maxYear = [NSDate date].year;
    minYear = maxYear - 10;
    _dateFormatter = @"yyyy-MM";
    if (!_scrollToDate) {
        _scrollToDate = [NSDate date];
    }
    //循环滚动时需要用到
    preRow = (self.scrollToDate.year-minYear)*12+self.scrollToDate.month-1;

    //设置年月日时分数据
    _yearArray = [self setArray:_yearArray];
    _monthArray = [self setArray:_monthArray];

    for (int i=1; i<=12; i++) {
        NSString *num = [NSString stringWithFormat:@"%02d",i];
        [_monthArray addObject:num];
    }
    for (NSInteger i= minYear; i<=maxYear; i++) {
        NSString *num = [NSString stringWithFormat:@"%ld",(long)i];
        [_yearArray addObject:num];
    }
    yearIndex = self.scrollToDate.year-minYear;
    monthIndex = self.scrollToDate.month-1;
    NSString *dateStr = [NSString stringWithFormat:@"%@年%@月",_yearArray[yearIndex],_monthArray[monthIndex]];
    self.timelabel.text = dateStr;

}

- (NSMutableArray *)setArray:(id)mutableArray
{
    if (mutableArray)
        [mutableArray removeAllObjects];
    else
        mutableArray = [NSMutableArray array];
    return mutableArray;
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *numberArr = [self getNumberOfRowsInComponent];
    return [numberArr[component] integerValue];
}

-(NSArray *)getNumberOfRowsInComponent {
    
    NSInteger yearNum = _yearArray.count;
    NSInteger monthNum = _monthArray.count;
    return @[@(yearNum),@(monthNum)];

}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    // 这里返回的是component的宽度,即每列的宽度
    return 100;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *customLabel = (UILabel *)view;
    if (!customLabel) {
        customLabel = [[UILabel alloc] init];
        [customLabel setFont:[UIFont systemFontOfSize:14]];
    }
    if (component==0) {
        customLabel.text = [NSString stringWithFormat:@"%@年",_yearArray[row]];
        customLabel.textAlignment = NSTextAlignmentLeft;
    }
    if (component==1) {
        customLabel.text = [NSString stringWithFormat:@"%@月",_monthArray[row]];
        customLabel.textAlignment = NSTextAlignmentRight;
    }
    [_datePicker.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.frame.size.height < 1)
        {
            [obj setBackgroundColor:[UIColor clearColor]];
        }
    }];
    return customLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        yearIndex = row;
    }
    if (component == 1) {
        monthIndex = row;
    }
    [pickerView reloadAllComponents];
    
    NSString *dateStr = [NSString stringWithFormat:@"%@年%@月",_yearArray[yearIndex],_monthArray[monthIndex]];
    self.timelabel.text = dateStr;
    
    self.scrollToDate = [[NSDate date:dateStr WithFormat:@"yyyy年MM月"] dateWithFormatter:_dateFormatter];
    
    _startDate = self.scrollToDate;
}

-(void)yearChange:(NSInteger)row {
    
    monthIndex = row%12;
    
    //年份状态变化
    if (row-preRow <12 && row-preRow>0 && [_monthArray[monthIndex] integerValue] < [_monthArray[preRow%12] integerValue]) {
        yearIndex ++;
    } else if(preRow-row <12 && preRow-row > 0 && [_monthArray[monthIndex] integerValue] > [_monthArray[preRow%12] integerValue]) {
        yearIndex --;
    }else {
        NSInteger interval = (row-preRow)/12;
        yearIndex += interval;
    }
    preRow = row;
}

//滚动到指定的时间位置
- (void)getNowDate:(NSDate *)date animated:(BOOL)animated
{
    if (!date) {
        date = [NSDate date];
    }
    
    yearIndex = date.year-minYear;
    monthIndex = date.month-1;
    
    //循环滚动时需要用到
    preRow = (self.scrollToDate.year-minYear)*12+self.scrollToDate.month-1;
    
    NSArray *indexArray = @[@(yearIndex),@(monthIndex)];

    [self.datePicker reloadAllComponents];
    
    for (int i=0; i<indexArray.count; i++) {
        [self.datePicker selectRow:[indexArray[i] integerValue] inComponent:i animated:animated];
    }
}

@end

@implementation XKDatePicker
{
    UIView *_selectBackView;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if(self.subviews.count){
        [self updateSelectView];
    }
}

-(void)updateSelectView
{
    //修改线条颜色
    UIView *line1 = self.subviews[1];
    line1.backgroundColor = [UIColor clearColor];
    UIView *line2 = self.subviews[2];
    line2.backgroundColor = [UIColor clearColor];
    
    //修改选中行的背景色
    for (UIView *subView in self.subviews) {
        if(subView.subviews.count){
            UIView *contentView = subView.subviews[0];
            for (UIView *contentSubView in contentView.subviews) {
                if(contentSubView.center.y == contentView.center.y){
                    if(_selectBackView != contentSubView){
                        _selectBackView.backgroundColor = [UIColor clearColor];
                        _selectBackView = contentSubView;
                        _selectBackView.backgroundColor = COLOR_VIEW_GRAY;
                    }
                    break;
                }
            }
            break;
        }
    }
}

@end
