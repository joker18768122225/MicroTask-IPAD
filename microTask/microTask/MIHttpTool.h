//
//  MIHttpToll.h
//  microTask
//
//  Created by blink_invoker on 8/17/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//


#import <AFNetworking.h>

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(AFHTTPRequestOperation *operation, id responseObject) ;
typedef void (^ErrorBlock)(AFHTTPRequestOperation *operation, NSError *error);

static NSString *WEIBOLOGIN=@"http://10.82.81.156:8080/microTask/user/login.action";
static NSString *TASK_ACTIVITY_SEARCH=@"http://10.82.81.156:8080/microTask/task_activity/search.action";

static NSString *TASK_ACTIVITY_PUBLISH=@"http://10.82.81.156:8080/microTask/task_activity/publish.action";
static NSString *TASK_ACTIVITY_APPLY=@"http://10.82.81.156:8080/microTask/task_activity/apply.action";


@interface MIHttpTool : NSObject

///post或get请求
+(void)httpRequestWithMethod:(NSString*)method withUrl:(NSString*)url withParams:(NSDictionary*)params withSuccessBlock:(SuccessBlock)success withErrorBlock:(ErrorBlock)error
;


///post请求，可传多个文件
+(void)httpRequestWithUrl:(NSString*)url withParams:(NSDictionary*)params withFiles:(NSArray*)files withSuccessBlock:(SuccessBlock)success withErrorBlock:(ErrorBlock)error
;



@end
