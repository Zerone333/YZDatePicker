//
//  YZDateTimePickerView.m
//  WSCloudBoardPartner
//
//  Created by 李艺真 on 16/5/13.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "YZDateTimePickerView.h"
#import "NSDate+Extension.h"


@interface YZDateTimePickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIPickerView *datePickerView;
@property (nonatomic, strong) UIPickerView *timePickerView;


@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger hours;
@property (nonatomic, assign) NSInteger minutes;

@property (nonatomic, strong) NSDate *minDate;            ///< 选择器 起始时间
@property (nonatomic, strong) NSDate *maxDate;              ///< 选择器 结束时间


@end
@implementation YZDateTimePickerView
+ (instancetype)dateTimePickerMinDate:(NSDate *)minDate
                              maxDate:(NSDate *)maxDate
                                 date:(NSDate *)date
{
    YZDateTimePickerView *picker = [[YZDateTimePickerView alloc] init];
    picker.minDate = minDate;
    picker.maxDate = maxDate;
    picker.date = date;
    return picker;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
    
    CGFloat pickerH = self.contentView.bounds.size.height /2;
    CGFloat pickerW = self.contentView.bounds.size.width;
    
    self.datePickerView.frame = CGRectMake(0, 0, pickerW, pickerH);
    self.timePickerView.frame = CGRectMake(0, pickerH, pickerW, pickerH);
}

#pragma mark - setup UI
- (void)setupUI
{
    [self addSubview:self.contentView];
    
    [self.contentView addSubview:self.datePickerView];
    [self.contentView addSubview:self.timePickerView];
}

#pragma mark - set/set method
#pragma mark UI
- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.layer.masksToBounds = YES;
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UIPickerView *)datePickerView {
    if (_datePickerView == nil) {
        
        _datePickerView = [[UIPickerView alloc] init];
        _datePickerView.backgroundColor = [UIColor whiteColor];
        _datePickerView.delegate = self;
        _datePickerView.dataSource = self;
    }
    return _datePickerView;
}

- (UIPickerView *)timePickerView {
    if (_timePickerView == nil) {
        _timePickerView = [[UIPickerView alloc] init];
        _timePickerView.delegate = self;
        _timePickerView.backgroundColor = [UIColor whiteColor];
        _timePickerView.dataSource = self;
    }
    return _timePickerView;
}

#pragma mark Data
- (void)setDate:(NSDate *)date {
    
    if (NSOrderedDescending != [NSDate compareOneDay:self.minDate withAnotherDay:date] && NSOrderedAscending != [NSDate compareOneDay:self.maxDate withAnotherDay:date] ) {
        _date = date;
        // 设置默认选择时间
        self.year = date.year;
        self.month = date.month;
        self.day = date.day;
        self.hours = date.hour;
        self.minutes = date.minute;
        
        [self.datePickerView selectRow:date.year - _minDate.year inComponent:0 animated:NO];
        
        if (date.year == _minDate.year) {
            //  当前年
            [self.datePickerView selectRow:date.month - _minDate.month inComponent:1 animated:NO];
            
            if (date.month - _minDate.month == 0) {
                //  当前月
                [self.datePickerView selectRow:date.day - _minDate.day inComponent:2 animated:NO];
                if (date.day - _minDate.day == 0) {
                    //  当前日
                    [self.timePickerView selectRow:date.hour - _minDate.hour inComponent:0 animated:NO];
                    if (date.hour - _minDate.hour ==0) {
                        //  当前时
                        [self.timePickerView selectRow:date.minute - _minDate.minute inComponent:1 animated:NO];
                    } else {
                        //  非当前时
                        [self.timePickerView selectRow:date.minute inComponent:1 animated:NO];
                    }
                } else {
                    //  非当前日
                    self.hours = date.hour;
                    [self.timePickerView selectRow:date.hour inComponent:0 animated:NO];
                    
                    self.minutes = date.minute;
                    [self.timePickerView selectRow:date.minute inComponent:1 animated:NO];
                }
            } else {
                //  非当前月
                [self.datePickerView selectRow:date.day - 1 inComponent:2 animated:NO];
                [self.timePickerView selectRow:date.hour inComponent:0 animated:NO];
                [self.timePickerView selectRow:date.minute inComponent:1 animated:NO];
            }
        } else {
            //  非当前年
            
            [self.datePickerView selectRow:date.month - 1 inComponent:1 animated:NO];
            [self.datePickerView selectRow:date.day - 1 inComponent:2 animated:NO];
            [self.timePickerView selectRow:date.hour inComponent:0 animated:NO];
            [self.timePickerView selectRow:date.minute inComponent:1 animated:NO];
        }
//        [self updateSelectTime];
    } else {
        NSLog(@"设置的时间超过了选择的区间范围");
    }
    
}

/**
 *  刷新选择 年 （刷新月数据）
 *
 *  @param year 年
 */
- (void)setYear:(NSInteger)year
{
    _year = year;
    
    [self.datePickerView reloadComponent:1];
    
}

/**
 *  刷新选择  月 （刷新日数据）
 *
 *  @param month 月
 */
- (void)setMonth:(NSInteger)month
{
    _month = month;
    [self.datePickerView reloadComponent:2];
    
}

/**
 *  刷新选择 日 （刷新 时，分数据）
 *
 *  @param day 日
 */
- (void)setDay:(NSInteger)day
{
    _day = day;
    [self.timePickerView reloadComponent:0];
    [self.timePickerView reloadComponent:1];
}

/**
 *  刷新选择 时 （刷新分数据）
 *
 *  @param hours 时
 */
- (void)setHours:(NSInteger)hours
{
    _hours = hours;
    [self.timePickerView reloadComponent:1];
}

#pragma mark -  UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
    }
    
    NSString *labelText = @"";
    
    if (pickerView == self.datePickerView) {// 年、月、日
        if (component == 0) {// 年
            labelText = [NSString stringWithFormat:@"%d年", (int)(_minDate.year + row)];
        } else if (component == 1) {// 月
            NSInteger startY;
            if (_year == _minDate.year) {
                startY = _minDate.month;
            } else {
                startY = 1;
            }
            labelText = [NSString stringWithFormat:@"%d月", (int)(startY + row)];
        } else {// 日
            NSInteger startD;
            if (_year == _minDate.year && _month == _minDate.month) {
                startD =  _minDate.day;
            } else {
                startD = 1;
            }
            labelText = [NSString stringWithFormat:@"%d日", (int)(startD + row)];
        }
    } else {// 时、分
        
        if (component == 0) {// 时
            if (_year == _minDate.year && _month == _minDate.month && _day == _minDate.day) {
                NSInteger currentH = _minDate.hour;
                
                labelText = [NSString stringWithFormat:@"%02d时", (int)(currentH + row)];
            } else
            {
                labelText = [NSString stringWithFormat:@"%02d时", (int)(row)];
            }
        } else {// 分
            NSInteger startM;
            if (_year == _minDate.year && _month == _minDate.month && _day == _minDate.day &&  _hours == _minDate.hour) {
                startM = _minDate.minute;
            } else {
                startM =0;
            }
            labelText = [NSString stringWithFormat:@"%02d分", (int)(startM + row)];
        }
    }
    
    pickerLabel.text = labelText;
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self updateSelectTime];
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.datePickerView)
    {
        //  年个数
        if (component ==0)
        {
            return _maxDate.year - _minDate.year + 1
            ;
        }
        //  月个数
        else if (component == 1)
        {
            //  同年,判断月份个数
            if (_year == _minDate.year && _year == _maxDate.year)
            {
                return _maxDate.month - _minDate.month + 1;
            }
            else
            {
                if (_year == _minDate.year)
                {
                    return 12 - _minDate.month + 1;
                }
                else if (_year == _maxDate.year)
                {
                    return _maxDate.month;
                }
                else
                {
                    return 12;
                }
            }
            
        }
        //  日个数
        else
        {
            //  同年，同月，判断日电个数
            if (_year == _minDate.year && _month == _minDate.month && _year == _maxDate.year && _month == _maxDate.month)
            {
                return _maxDate.day - _minDate.day +1;
            }
            else if (_year == _minDate.year && _month == _minDate.month)
            {
                return _minDate.numberOfDaysInMonth - _minDate.day + 1;
            }
            else if(_year == _maxDate.year && _month == _maxDate.month)
            {
                return _maxDate.day;
            }
            else
            {
                NSDate *date = [NSDate dateWithYear:_year month:_month day:1];
                return [date numberOfDaysInMonth];
            }
        }
    }
    //  时间选择器
    else
    {
        //  hours
        if (component == 0)
        {
            if (_year == _minDate.year && _month == _minDate.month && _day == _minDate.day)
            {
                return 24 - _minDate.hour;
            }
            else
            {
                return 24;
            }
        }
        //  minutes
        else if(component == 1)
        {
            if (_year == _minDate.year && _month == _minDate.month && _day == _minDate.day &&  _hours == _minDate.hour)
            {
                return 60 - _minDate.minute;
            }
            else
            {
                return 60;
            }
        }
    }
    return 0;
}

#pragma mark - private
- (void) updateSelectTime
{
    //year
    NSInteger yearRowIndex =[self.datePickerView selectedRowInComponent:0];
    self.year = _minDate.year + yearRowIndex;
    
    
    //month
    NSInteger monthRowIndex =[self.datePickerView selectedRowInComponent:1];
    NSInteger startM;
    if (_year == _minDate.year) {
        startM = _minDate.month;
    } else {
        startM = 1;
    }
    self.month = startM + monthRowIndex;
    
    
    //day
    NSInteger dayRowRowIndex =[self.datePickerView selectedRowInComponent:2];
    
    NSInteger startD;
    if (_year == _minDate.year && _month == _minDate.month) {
        startD =  _minDate.day;
    } else {
        startD = 1;
    }
    self.day = startD + dayRowRowIndex;
    
    //hours
    NSInteger hourRowIndex = [self.timePickerView selectedRowInComponent:0];
    if (_year == _minDate.year && _month == _minDate.month && _day == _minDate.day) {
        NSInteger currentH = _minDate.hour;
        self.hours = currentH + hourRowIndex;
    } else
    {
        self.hours = hourRowIndex;
    }
    
    //minutes
    NSInteger minutesRowIndex = [self.timePickerView selectedRowInComponent:1];
    NSInteger startMin;
    if (_year == _minDate.year && _month == _minDate.month && _day == _minDate.day &&  _hours == _minDate.hour) {
        startMin = _minDate.minute + minutesRowIndex;
    } else
    {
        startMin =minutesRowIndex;
    }
    self.minutes = startMin;
    
    
    NSDate *selectDate = [NSDate dateWithYear:_year month:_month day:_day hour:_hours minutes:_minutes];
    _date = selectDate;
    [self setNeedsLayout];
    
#if DEBUG
    NSString *selectDateStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld (%@) %02ld : %02ld", (long)_year, (long)_month , (long)_day, [NSDate dateWithYear:_year month:_month day:_day].weekday,(long)_hours, (long)_minutes];
    NSLog(@"%@", selectDateStr);
#endif
    
}

@end
