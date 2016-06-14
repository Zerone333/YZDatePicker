//
//  NSDate+Extension.m
//  HuaweiCloudPb
//
//  Created by lee on 15/6/30.
//  Copyright (c) 2015年 text. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
/**
 *  是否为今天
 */
- (BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return
    (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}

/**
 *  是否为昨天
 */
- (BOOL)isYesterday
{
    // 2014-05-01
    NSDate *nowDate = [[NSDate date] dateWithYMD];
    
    // 2014-04-30
    NSDate *selfDate = [self dateWithYMD];
    
    // 获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

- (NSDate *)dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger) day
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [NSString stringWithFormat:@"%d-%02d-%02d", (int)year, (int)month, (int)day];
    return [fmt dateFromString:selfStr];
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger) day hour:(NSInteger)hour minutes:(NSInteger) minutes
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMddHHmm";
    NSString *selfStr = [NSString stringWithFormat:@"%d%02d%02d%02d%02d", (int)year, (int)month, (int)day, (int)hour, (int)minutes];
    return [fmt dateFromString:selfStr];
}
/**
 *  是否为今年
 */
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year;
}

- (NSDateComponents *)deltaWithNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}

-(NSDateComponents* )dateDetail
{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
#ifdef __IPHONE_8_0
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0    //Minimum Target iOS 8+
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond
    | NSCalendarUnitWeekday | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitQuarter | NSCalendarUnitWeekOfMonth
    | NSCalendarUnitWeekOfYear | NSCalendarUnitYearForWeekOfYear | NSCalendarUnitCalendar | NSCalendarUnitTimeZone;
    
#else
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit
    | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSQuarterCalendarUnit | NSWeekOfMonthCalendarUnit
    | NSWeekOfYearCalendarUnit | NSYearForWeekOfYearCalendarUnit | NSCalendarCalendarUnit | NSTimeZoneCalendarUnit;
#endif
#endif
    
    
       NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:self];
    return dateComponent;
}

-(NSInteger)year
{
    return [self dateDetail].year;
}

-(NSInteger)month
{
    return [self dateDetail].month;
}

-(NSInteger)day
{
    return [self dateDetail].day;
}

-(NSInteger)hour
{
    return [self dateDetail].hour;
}

-(NSInteger)second
{
    return [self dateDetail].second;
}

-(NSInteger)minute
{
    return [self dateDetail].minute;
}
-(NSString *)weekday
{
    switch ([self dateDetail].weekday) {
        case WeekTypeSun:
            return @"周日";
            break;
        case WeekTypeMon:
            return @"星期一";
            break;
        case WeekTypeTues:
            return @"星期二";
            break;
        case WeekTypeWednes:
            return @"星期三";
            break;
        case WeekTypeThurs:
            return @"星期四";
            break;
        case WeekTypeFri:
            return @"星期五";
            break;
        case WeekTypeSatur:
            return @"星期六";
            break;
        default:
            break;
    }
    return nil;
}

-(LTimeInterval)distance
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *  senddate=[NSDate date];
    //结束时间
    NSDate *endDate = [dateFormatter dateFromString:@"2014-6-24 00:00:00"];
    //当前时间
    NSDate *senderDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:senddate]];
    //得到相差秒数
    
    NSTimeInterval time=[endDate timeIntervalSinceDate:senderDate];
    
    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
    int minute = ((int)time)%(3600*24)/3600/60;
    LTimeInterval timeInterval;
    timeInterval.days = days;
    timeInterval.hours = hours;
    timeInterval.minute = minute;
    return timeInterval;
}

- (NSInteger)numberOfDaysInMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    
    NSUInteger numberOfDaysInMonth = range.length;
    return numberOfDaysInMonth;
}


+(NSComparisonResult)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    
    return result;
////    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
//    if (result == NSOrderedDescending) {
//        //NSLog(@"Date1  is in the future");
//        return 1;
//    }
//    else if (result == NSOrderedAscending){
//        //NSLog(@"Date1 is in the past");
//        return -1;
//    }
//    //NSLog(@"Both dates are the same");
//    return 0;
    
}

@end
