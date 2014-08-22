//
//  MIViewController.m
//  microTask
//
//  Created by blink_invoker on 8/4/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import "MIViewController.h"
#import "MIUser.h"
#import "MIPublishTaskActivityController.h"
#import "MIFindController.h"
#import "MIPublishTaskActivityController.h"
#import "KxMenu.h"

#import <SDWebImage/UIButton+WebCache.h>

static MIViewController *mainControllerInstance=nil;
@implementation MIViewController

//单例模式
+(MIViewController*)getInstance
{
    if (mainControllerInstance==nil)
    {
        NSLog(@"mainController单例未初始化");
        return nil;
    }
    return mainControllerInstance;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    _middleView=nil;
    
    [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:[MIUser getInstance].avatar]  forState:UIControlStateNormal];

    mainControllerInstance=self;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) fadeIn
{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.5f ;  // 动画持续时间(秒)
    // animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;//淡入淡出效果
    [[self.view layer] addAnimation:animation forKey:@"animation"];
    
}


- (IBAction)findAction:(UIButton *)sender
{
    [_middleView removeFromSuperview];
    [_middleController removeFromParentViewController];
    
    MIFindController *findController=[[MIFindController alloc]initWithNibName:@"findView" bundle:nil];
    [self addChildViewController:findController];
    UIView *findView=[findController view];
    _middleView=findView;
    _middleController=findController;
    [findView setFrame:CGRectMake(74, 0, 500, 768)];
    [self.view addSubview:_middleView];
    [self fadeIn];

    
}

//选择发布类型
- (IBAction)addAction:(UIButton *)sender
{
    
    
    NSArray *menuItems =
    @[

      [KxMenuItem menuItem:@"我需要帮忙"
                     image:nil
                    target:self
                    action:@selector(publishNeed)],
      [KxMenuItem menuItem:@"我可以帮忙"
                     image:nil
                    target:self
                    action:@selector(publishCan)],
      [KxMenuItem menuItem:@"发布活动"
                     image:nil
                    target:self
                    action:@selector(publishActivity)]
      
      ];
    
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuItems];
    
    
}
//设置发布类型
-(void)publishCan
{
    [self publishTaskActivity:@"can"];
}
-(void)publishNeed
{
    
    [self publishTaskActivity:@"need"];
}
-(void)publishActivity
{
    [self publishTaskActivity:@"activity"];
    

}


///发布活动或任务
-(void)publishTaskActivity:(NSString*)can_need_activity
{
    [_middleView removeFromSuperview];
    [_middleController removeFromParentViewController];
    
    MIPublishTaskActivityController *taskController=[[MIPublishTaskActivityController alloc]initWithNibName:@"publishTaskActivityView" bundle:nil Can_need_activity:can_need_activity];
    
    [self addChildViewController:taskController];
    UIView *taskView=[taskController view];
    _middleView=taskView;
    _middleController=taskController;
    [taskView setFrame:CGRectMake(74, 0, 500, 768)];
    [self.view addSubview:_middleView];
    [self fadeIn];

}
- (IBAction)tapBack:(UIControl *)sender
{
    //如果是发布任务的controller 则取消键盘
    if ([_middleController isKindOfClass:MIPublishTaskActivityController.class])
    {
        MIPublishTaskActivityController *pController=_middleController;
        [pController.titleField resignFirstResponder];
        [pController.contentTextView resignFirstResponder];
        [pController.rewardTextView resignFirstResponder];
        [pController.mobileTextView resignFirstResponder];
    }
    
}
-(void)closeImageDetail
{
    NSLog(@"123");
}

@end
