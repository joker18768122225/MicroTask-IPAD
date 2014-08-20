//
//  MIViewController.h
//  microTask
//
//  Created by blink_invoker on 8/4/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface MIViewController : UIViewController

@property UIView *middleView;
@property UIViewController *middleController;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

@property (weak, nonatomic) IBOutlet UIImageView *_bgView;
- (IBAction)findAction:(UIButton *)sender;
- (IBAction)addAction:(UIButton *)sender;

+(MIViewController*)getInstance;
-(void)closeImageDetail;
@property (strong, nonatomic) IBOutlet UIControl *control;

@end
