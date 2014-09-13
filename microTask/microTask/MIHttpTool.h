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

//注册&登录
static NSString *WEIBOLOGIN=@"http://127.0.0.1:8080/microTask/user/login.action";

//任务&活动
static NSString *TASK_ACTIVITY_PUBLISH=@"http://127.0.0.1:8080/microTask/task_activity/publish.action";
static NSString *TASK_ACTIVITY_FINDNEAR=@"http://127.0.0.1:8080/microTask/task_activity/search.action";
static NSString *TASK_ACTIVITY_FINDBYTITLE=@"http://127.0.0.1:8080/microTask/task_activity/findbytitle.action";
static NSString *TASK_ACTIVITY_APPLY=@"http://127.0.0.1:8080/microTask/task_activity/apply.action";

//用户
static NSString *USER_SEARCH_BY_NICKNAME=@"http://127.0.0.1:8080/microTask/user/search.action";

//院校
static NSString *PROVINCE_ALL=@"http://127.0.0.1:8080/microTask/department/provinceAll.action";
static NSString *UNIVERSITY_SEARCH_BYPID=@"http://127.0.0.1:8080/microTask/department/findUniversity.action";


@interface MIHttpTool : NSObject

///post或get请求
+(void)httpRequestWithMethod:(NSString*)method withUrl:(NSString*)url withParams:(NSDictionary*)params withSuccessBlock:(SuccessBlock)success withErrorBlock:(ErrorBlock)error
;


///post请求，可传多个文件
+(void)httpRequestWithUrl:(NSString*)url withParams:(NSDictionary*)params withFiles:(NSArray*)files withSuccessBlock:(SuccessBlock)success withErrorBlock:(ErrorBlock)error
;



@end
