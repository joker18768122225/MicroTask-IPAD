//
//  MILoginController.m
//  microTask
//
//  Created by blink_invoker on 8/4/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//


#import "MILoginController.h"
#import <ShareSDK/ShareSDK.h>

#import "MIUser.h"
#import "MIProperties.h"
#import "MIUpLoadFile.h"

#import "MIHttpTool.h"

@interface MILoginController ()
@end


@implementation MILoginController
@synthesize _weiboLoginButton=_weiboLoginButton;
- (void)viewDidLoad
{
    [super viewDidLoad];
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置点击done和背景关闭键盘
- (IBAction)phoneDone:(UITextField *)sender
{
    [sender resignFirstResponder];
}

- (IBAction)passwordDone:(UITextField *)sender
{
    [sender resignFirstResponder];
}

- (IBAction)tapBack:(UIControl *)sender
{
    [self._phoneField resignFirstResponder];
    [self._passwordField resignFirstResponder];
    
}

//接收通知的方法
-(void)forwardToMain:(NSDictionary*) dic
{
    
    //跳转到主界面

    if (dic==nil)
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"网络请求错误" message:@"请检查网络连接!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alertView show];
        [self._weiboLoginButton setEnabled:YES];
        
    }
    else if([[dic objectForKey:@"status"] isEqualToString:@"success"])
    {
        
        NSDictionary *userDic=[dic objectForKey:@"user"];
        
        //初始化用户实例
        [MIUser initWithUid:[userDic objectForKey:@"uid"] withNickName:[userDic objectForKey:@"nickname"] withGender:[userDic objectForKey:@"gender"] withAvatar:[userDic objectForKey:@"avatar"] withProfile:[userDic objectForKey:@"profile"] withCredit:[[userDic objectForKey:@"credit"] intValue] withMobile:[userDic objectForKey:@"mobile"] withFollowercnt:[[userDic objectForKey:@"followercnt"] intValue] withFollowcnt:[[userDic objectForKey:@"followcnt"] intValue] withUniversity:[userDic objectForKey:@"university"] withDepartment:[userDic objectForKey:@"department"]];
        
        NSLog(@"%@",[MIUser getInstance]);
        
        [self performSegueWithIdentifier:@"LoginToMain" sender:self];
    }
    else if ([[dic objectForKey:@"status"] isEqualToString:@"error"])
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"登录失败" message:@"未知原因!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alertView show];
        [self._weiboLoginButton setEnabled:YES];
        
        
    }
    
}

-(void)reloadStateWithTypeAndLogin:(ShareType)type
{
    
    //现实授权信息，包括授权ID、授权有效期等。
    //此处可以在用户进入应用的时候直接调用，如授权信息不为空且不过期可帮用户自动实现登录。
    id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:type];
    
    NSString *uid=[credential uid];
    NSString *token=[credential token];
    
    //设置参数
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    [params setValue:uid forKey:@"id"];
    [params setValue:token forKey:@"token"];
    [params setValue:@"weibo" forKey:@"mode"];
    
    SuccessBlock success=^(AFHTTPRequestOperation *operation, id responseObject)
    {
         NSLog(@"%@",responseObject);
        [self forwardToMain:responseObject];
        
    };
    ErrorBlock error=^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"%@",error);
        
    };
    
    [MIHttpTool httpRequestWithMethod:@"post" withUrl:WEIBOLOGIN withParams:params withSuccessBlock:success withErrorBlock:error];
  
}



- (IBAction)weiboLogin:(UIButton *)sender
{
    
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        
        if (result) {
            //成功登录后，判断该用户的ID是否在自己的数据库中。
            //如果有直接登录，没有就将该用户的ID和相关资料在数据库中创建新用户。
            [self reloadStateWithTypeAndLogin:ShareTypeSinaWeibo];
        }
    }];
    
    
}

- (IBAction)qqLogin:(UIButton *)sender
{
    
}

@end
