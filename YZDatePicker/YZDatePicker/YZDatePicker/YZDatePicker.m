//
//  YZDatePicker.m
//  WSCloudBoardPartner
//
//  Created by 李艺真 on 16/3/6.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "YZDatePicker.h"
#import "NSDate+Extension.h"

#define kLabelFont [UIFont boldSystemFontOfSize:16]
#define kLabelTextColor [[UIColor blackColor] colorWithAlphaComponent:0.5]

@interface YZDatePicker()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIPickerView *datePickerView;


@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;

@property (nonatomic, strong) NSDate *minDate;              ///< 选择器 起始时间
@property (nonatomic, strong) NSDate *maxDate;              ///< 选择器 结束时间

@end

@implementation YZDatePicker

+(instancetype) datePickerWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate
{
    
    YZDatePicker *datePicker = [[YZDatePicker alloc] init];
    datePicker.minDate = minDate;
    datePicker.maxDate = maxDate;
    datePicker.year = minDate.year;
    datePicker.month = minDate.month;
    datePicker.day = minDate.day;
    
    return datePicker;
}


+(instancetype) datePickerWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate defauleDate:(NSDate *)defaultDate {
    YZDatePicker *datePicker = [YZDatePicker datePickerWithMinDate:minDate maxDate:maxDate];
    if (defaultDate != nil) {
        datePicker.date = defaultDate;
    }
    return datePicker;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.datePickerView];
    }
    return self;
}


- (void)layoutSubviews
{
    self.datePickerView.frame = self.bounds;
    self.contentView.frame = self.bounds;
    self.contentView.layer.masksToBounds = YES;
    self.datePickerView.center = CGPointMake(self.datePickerView.center.x, self.contentView.bounds.size.height /2);
}

#pragma mark get/set method
#pragma mark UI
- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (UIPickerView *)datePickerView {
    if (_datePickerView == nil) {
        _datePickerView = [[UIPickerView alloc] init];
            _datePickerView.frame = CGRectMake(0, 0, 0, 50);
            _datePickerView.backgroundColor = [UIColor whiteColor];
            _datePickerView.delegate = self;
            _datePickerView.dataSource = self;
    }
    return _datePickerView;
}

#pragma mark -  UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:kLabelFont];
        pickerLabel.textColor = kLabelTextColor;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
    }
    
    NSString *labelText = @"";
    
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
    //  年个数
    if (component ==0)
    {
        return _maxDate.year - _minDate.year + 1;
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
    return 0;
}

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
    [self setNeedsLayout];
    _date = [NSDate dateWithYear:_year month:_month day:_day hour:0 minutes:0];
#if DEBUG
    NSString *selectDateStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld (%@)", (long)_year, (long)_month , (long)_day, [NSDate dateWithYear:_year month:_month day:_day].weekday];
    NSLog(@"%@", selectDateStr);
#endif
}

#pragma mark - set/set method
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

- (void)setDate:(NSDate *)date
{
    //  设置的时间是否在 时间区间内
     if (NSOrderedSame >= [NSDate compareOneDay:self.minDate withAnotherDay:date] && NSOrderedSame <= [NSDate compareOneDay:self.maxDate withAnotherDay:date] ) {
         _date = date;
         // 设置默认选择时间
         [self.datePickerView selectRow:date.year - _minDate.year inComponent:0 animated:NO];
         self.year = date.year;
         self.month = date.month;
         self.day = date.day;
         
         if (date.year == _minDate.year) {
             //  当前年
             [self.datePickerView selectRow:date.month - _minDate.month inComponent:1 animated:NO];
             
             if (date.month - _minDate.month == 0) {
                 //  当前月
                 [self.datePickerView selectRow:date.day - _minDate.day inComponent:2 animated:NO];
             } else {
                 //  非当前月
                 [self.datePickerView selectRow:date.day - 1 inComponent:2 animated:NO];
             }
         } else {
             //  非当前年
             [self.datePickerView selectRow:date.month - 1 inComponent:1 animated:NO];
             [self.datePickerView selectRow:date.day - 1 inComponent:2 animated:NO];
         }
     } else {
         NSLog(@"设置的默认时间不在时间选择的时间区间内。");
     }
}

@end
