//
//  MIProperties.m
//  microTask
//
//  Created by blink_invoker on 8/15/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import "MIProperties.h"

static NSString *HOST=@"10.82.81.156:8080";
//static NSString *HOST=@"10.82.25.74:8080";
static NSString *REGISTER_URL=@"/microTask/user/register.action";
static NSString *WEIBOLOGIN_URL=@"/microTask/user/login.action";
static NSString *TASK_ACTIVITY_SEARCH_URL=@"/microTask/task_activity/search.action";

@implementation MIProperties

+(NSString*)HOST
{
    return HOST;
}
+(NSString *)REGISTER_URL
{
    return REGISTER_URL;
}
+(NSString *)WEIBOLOGIN_URL
{
    return WEIBOLOGIN_URL;
}
+(NSString *)TASK_ACTIVITY_SEARCH_URL
{
    return TASK_ACTIVITY_SEARCH_URL;
}
@end
