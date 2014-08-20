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
@property(nonatomic,assign) int credit;
@property(nonatomic) NSString *mobile;


+(MIUser*) getInstance;

+(void)initWithUid:(NSString*)uid withNickName:(NSString*)nickName withGender:(NSString*)gender withAvatar:(NSString*)avatar withProfile:(NSString*)profile withCredit:(int)credit withMobile:(NSString*)mobile;

@end
