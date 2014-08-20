//
//  MICalendar.h
//  microTask
//
//  Created by blink_invoker on 8/18/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MICalendar : NSObject

{
@private
     int _year;
     int _month;
     int _day;
     int _hour;
     int _minute;
}

-(int)hour;
-(int)minute;
-(int)year;
-(int)month;
-(int)day;

-(void)setDate:(NSDate *)date;
//生成date对应的calendar
-(id)initWithDate:(NSDate*)date;
//自定义calendar
-(id)initWithYear:(int)year withMonth:(int)month withDay:(int)day withHour:(int)hour withMinute:(int)minute;
@end
