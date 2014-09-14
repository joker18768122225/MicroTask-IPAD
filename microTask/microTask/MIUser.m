//
//  MIUser.m
//  microTask
//
//  Created by blink_invoker on 8/6/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import "MIUser.h"


@implementation MIUser


static MIUser* instance=nil;
+(MIUser *)getInstance
{
    if (!instance)
    {
        NSLog(@"User Instance未初始化");
    }
    return instance;
}
+(void)initWithUid:(NSString*)uid withNickName:(NSString*)nickName withGender:(NSString*)gender withAvatar:(NSString*)avatar withProfile:(NSString*)profile withCredit:(int)credit withMobile:(NSString*)mobile withFollowercnt:(int)followercnt withFollowcnt:(int)followcnt withUniversity:(NSString*)university withDepartment:(NSString*)department withUnivid:(int)univid withDepid:(int)depid
{
    instance=[[MIUser alloc] init];
    instance->_uid=uid;
    instance->_nickName=nickName;
    instance->_gender=gender;
    instance->_avatar=avatar;
    instance->_credit=credit;
    instance->_mobile=mobile;
    instance->_followcnt=followcnt;
    instance->_followercnt=followercnt;
    instance->_department=department;
    instance->_university=university;
    instance->_profile=profile;
    instance->_univid=univid;
    instance->_depid=depid;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@,%@,%@,%@,%d,%@",self->_uid,self->_nickName,self->_gender,self->_avatar,self->_credit,self->_mobile];
}

@end
