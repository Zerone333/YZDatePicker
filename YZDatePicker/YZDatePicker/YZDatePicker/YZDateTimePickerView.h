//
//  YZDateTimePickerView.h
//  WSCloudBoardPartner
//
//  Created by 李艺真 on 16/5/13.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZDateTimePickerView : UIView
@property (nonatomic, strong) NSDate *date;


+ (instancetype)dateTimePickerMinDate:(NSDate *)minDate
                              maxDate:(NSDate *)maxDate
                                 date:(NSDate *)date;
@end
