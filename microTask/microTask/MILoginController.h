//
//  MILoginController.h
//  microTask
//
//  Created by blink_invoker on 8/4/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MILoginController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *_backGround;
@property (weak, nonatomic) IBOutlet UITextField *_phoneField;
@property (weak, nonatomic) IBOutlet UITextField *_passwordField;
@property (weak, nonatomic) IBOutlet UIButton *_weiboLoginButton;

- (IBAction)phoneDone:(UITextField *)sender;
- (IBAction)passwordDone:(UITextField *)sender;
- (IBAction)tapBack:(UIControl *)sender;
- (IBAction)weiboLogin:(UIButton *)sender;
- (IBAction)qqLogin:(UIButton *)sender;


@end
