//
//  MIAddTaskController.h
//  microTask
//
//  Created by blink_invoker on 8/10/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
@interface MIPublishTaskActivityController : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,BMKLocationServiceDelegate>
{
    
    int x;
}
@property NSString *can_need_activity;
@property (weak, nonatomic) IBOutlet UITextField *titleField;

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UITableView *imageTableView;
@property (weak, nonatomic) IBOutlet UILabel *validateDateLabel;
- (IBAction)titleDone:(UITextField *)sender;

- (IBAction)tapBack:(UIControl *)sender;
@property (weak, nonatomic) IBOutlet UISlider *slider1;
@property (weak, nonatomic) IBOutlet UISlider *slider2;

- (IBAction)slider1Change:(UISlider *)sender;
- (IBAction)slider2Change:(UISlider *)sender;

- (IBAction)slider1Done:(UISlider *)sender;

- (IBAction)slider2Done:(UISlider *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *timeImageView1;

@property (weak, nonatomic) IBOutlet UIImageView *timeImageView2;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;

@property (weak, nonatomic) IBOutlet UILabel *hourLabel;

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *can_need_activityLabel;
- (IBAction)addPhoto:(UIButton *)sender;

- (IBAction)submit:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextView *rewardTextView;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Can_need_activity:(NSString*)can_need_activity;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
- (IBAction)chooseType:(UIButton *)sender;

@end
