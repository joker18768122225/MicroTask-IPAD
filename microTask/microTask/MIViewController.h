//
//  MIViewController.h
//  microTask
//
//  Created by blink_invoker on 8/4/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MIViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property UINavigationController *leftNController;
@property UINavigationController *rightNController;
- (IBAction)findAction:(UIButton *)sender;
- (IBAction)addAction:(UIButton *)sender;

+(MIViewController*)getInstance;
-(void)closeImageDetail;
@property (strong, nonatomic) IBOutlet UIControl *control;

@end
