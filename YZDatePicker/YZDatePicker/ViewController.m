//
//  ViewController.m
//  YZDatePicker
//
//  Created by 李艺真 on 16/6/12.
//  Copyright © 2016年 李艺真. All rights reserved.
//

#import "ViewController.h"
#import "YZDatePicker.h"
#import "NSDate+Extension.h"
#import "YZDateTimePickerView.h"

@interface ViewController ()
@property (nonatomic, weak)  YZDateTimePickerView *dateTimePickerView;
@property (nonatomic, assign) NSInteger day;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _day = 1;
    NSCalendar *calender = [NSCalendar currentCalendar];
   
#ifdef __IPHONE_8_0
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0    //Minimum Target iOS 8+
    NSDateComponents *cmp = [calender components:(NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate date]];
    [cmp setDay:1];
    NSDate *startDate = [NSDate date];
    [cmp setYear:2030];
    [cmp setMonth:3];
    [cmp setDay:18];
    NSDate *endDate =[calender dateFromComponents:cmp];
#else
    NSDateComponents *cmp = [calender components:(NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];
    [cmp setDay:1];
    NSDate *startDate = [NSDate date];
    [cmp setYear:2030];
    [cmp setMonth:3];
    [cmp setDay:18];
    NSDate *endDate =[calender dateFromComponents:cmp];
    
#endif
#endif
    YZDatePicker *picker = [YZDatePicker datePickerWithMinDate:startDate maxDate:startDate];
    [self.view addSubview:picker];
    picker.frame = CGRectMake(20, 100, 280, 100);
    picker.date = endDate;
    
    
    YZDateTimePickerView *dateTimePickerView = [YZDateTimePickerView dateTimePickerMinDate:startDate maxDate:startDate date:startDate];
        dateTimePickerView.frame = CGRectMake(20, 200, 280, 100);
    [self.view addSubview:dateTimePickerView];
    _dateTimePickerView = dateTimePickerView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClick:(id)sender {
    NSLog(@"%@", self.dateTimePickerView.date);
    
    
    // 1. set start time
    NSDate *localDate = [NSDate date];
    NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
    NSDate *date = [localDate initWithTimeIntervalSinceNow: _day * oneDay];
    _day += 1;
    self.dateTimePickerView.date = date;
}


@end
