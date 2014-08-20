//
//  MIHttpToll.m
//  microTask
//
//  Created by blink_invoker on 8/17/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//
#import "MIHttpTool.h"
#import "MIUpLoadFile.h"
static AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

@implementation MIHttpTool

+(void)httpRequestWithMethod:(NSString*)method withUrl:(NSString*)url withParams:(NSDictionary*)params withSuccessBlock:(SuccessBlock)success withErrorBlock:(ErrorBlock)error
{
    method=[method uppercaseString];
    if ([method isEqualToString:@"POST"])
    {
        [manager POST:url parameters:params success:success failure:error];
    }
    else
    {
        [manager GET:url parameters:params success:success failure:error];
    }
    
    
}

+(void)httpRequestWithUrl:(NSString*)url withParams:(NSDictionary*)params withFiles:(NSArray*)files withSuccessBlock:(SuccessBlock)success withErrorBlock:(ErrorBlock)error

{
    manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         //添加多个文件
         if (files)
         {
             for (MIUpLoadFile *file in files)
             {
                 [formData appendPartWithFileData:file.fileData name:file.key fileName:file.fileName mimeType:file.mimeType];
             }
         }
         
     }
          success:success failure:error];
}
@end
