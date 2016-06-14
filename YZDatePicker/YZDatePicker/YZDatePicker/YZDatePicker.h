//
//  YZDatePicker.h
//  WSCloudBoardPartner
//
//  Created by 李艺真 on 16/3/6.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZDatePicker : UIView
/**
 *  日期选择器的日期
 */
@property (nonatomic, strong) NSDate *date;

/**
 *  创建一个日期选择器
 *
 *  @param minDate 最小选择日期
 *  @param maxDate 最大选择日期
 *
 *  @return  YZDatePicker 时间选择器。 默认时间选择器高度为246.0，这里可以随意设置时间选择器的高度
 */
+(instancetype) datePickerWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate;


/**
 *  创建一个日期选择器
 *
 *  @param minDate 最小选择日期
 *  @param maxDate 最大选择日期
 *  @param defaultDate 默认选择日期, 当为 nil 的时候，默认选择最小日期
 *
 *  @return YZDatePicker 日期选择器。 默认时间选择器高度为246.0，这里可以随意设置时间选择器的高度
 */
+(instancetype) datePickerWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate defauleDate:(NSDate *)defaultDate;
@end
