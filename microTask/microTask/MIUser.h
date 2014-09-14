//
//  MIUser.h
//  microTask
//
//  Created by blink_invoker on 8/6/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIUser : NSObject
@property(nonatomic) NSString *uid;
@property(nonatomic) NSString *nickName;
@property(nonatomic) NSString *gender;
@property(nonatomic) NSString *avatar;
@property(nonatomic) NSString *profile;
@property(nonatomic) NSString *mobile;
@property(nonatomic) NSString *university;
@property(nonatomic) NSString *department;
@property(nonatomic,assign) int credit;

@property(nonatomic,assign) int followercnt;
@property(nonatomic,assign) int followcnt;
@property(nonatomic,assign) int univid;
@property(nonatomic,assign) int depid;

+(MIUser*) getInstance;

+(void)initWithUid:(NSString*)uid withNickName:(NSString*)nickName withGender:(NSString*)gender withAvatar:(NSString*)avatar withProfile:(NSString*)profile withCredit:(int)credit withMobile:(NSString*)mobile withFollowercnt:(int)followercnt withFollowcnt:(int)followcnt withUniversity:(NSString*)university withDepartment:(NSString*)department withUnivid:(int)univid withDepid:(int)depid;

@end
