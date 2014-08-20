//
//  MICalendar.m
//  microTask
//
//  Created by blink_invoker on 8/18/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import "MICalendar.h"

@implementation MICalendar
{
    NSCalendar *_calendar;
    NSDate *_date;
    NSDateComponents *_dateComp;
}

-(void)setDate:(NSDate *)date
{
    unsigned unitFlags=NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
    
    _dateComp=[_calendar components:unitFlags fromDate:date];
    _year=_dateComp.year;
    _month=_dateComp.month;
    _day=_dateComp.day;
    _hour=_dateComp.hour;
    _minute=_dateComp.minute;
}


-(void)setYear:(int)year
{
    _dateComp.year=year;
    _year=year;
}
-(int)year
{
    return _year;
}

-(void)setMonth:(int)month
{
    _dateComp.month=month;
    _month=month;
}
-(int)month
{
    return _month;
}

-(void)setDay:(int)day
{
    _dateComp.day=day;
    _day=day;
}
-(int)day
{
    return _day;
}

-(void)setHour:(int)hour
{
    _dateComp.hour=hour;
    _hour=hour;
}

-(int)hour
{
    return _hour;
}

-(void)setMinute:(int)minute
{
    _dateComp.minute=minute;
    _minute=minute;
}
-(int)minute
{
    return _minute;
}

-(id)initWithDate:(NSDate*)date
{
    self=[super init];
    _calendar=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    _date=date;
    [self setDate:date];
    return self;
}

-(id)initWithYear:(int)year withMonth:(int)month withDay:(int)day withHour:(int)hour withMinute:(int)minute
{
    self=[super init];
    _calendar=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    //自定义时间
    _dateComp=[[NSDateComponents alloc] init];
    _dateComp.year=year;
    _dateComp.month=month;
    _dateComp.day=day;
    _dateComp.hour=hour;
    _dateComp.minute=minute;
    
    _year=_dateComp.year;
    _month=_dateComp.month;
    _day=_dateComp.day;
    _hour=_dateComp.hour;
    _minute=_dateComp.minute;
    
    _date=[_calendar dateFromComponents:_dateComp];
    
    
    return self;
    
}

@end
