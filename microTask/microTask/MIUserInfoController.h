//
//  MIMyInfoController.h
//  microTask
//
//  Created by blink_invoker on 8/26/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIUser.h"
@interface MIUserInfoController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *view;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil userInfo:(MIUser*)user;
@end
