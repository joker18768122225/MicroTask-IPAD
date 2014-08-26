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
#import "UIView+cat.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "MISearchUTAController.h"
#import "MIUserInfoController.h"

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
    
    [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:[MIUser getInstance].avatar]  forState:UIControlStateNormal];

    mainControllerInstance=self;
    
    //左边navigatController
    MIFindController *findController=[[MIFindController alloc] initWithNibName:@"findView" bundle:nil];
    _leftNController=[[UINavigationController alloc] initWithRootViewController:findController];
    //不知道为什么width要设置成244
    _leftNController.view.x=74;
    _leftNController.view.width=220;
    
    [self addChildViewController:_leftNController];
    [self.view addSubview:_leftNController.view];
    
    //隐藏工具栏
    [_leftNController setToolbarHidden:YES];
    [_leftNController setNavigationBarHidden:YES];
    
    //右边navigatController
    
    
    /*
    _rightNController=[[MInavigationControllerViewController alloc] initWithNibName:@"MInavigationControllerViewController" bundle:nil];
     */
    
    UIViewController *controller=[[UIViewController alloc] init];
    controller.view.backgroundColor=[UIColor clearColor];
    
    _rightNController=[[UINavigationController alloc] initWithRootViewController:controller];
    
    //不知道为什么width要设置成244
    _rightNController.view.x=549;
    _rightNController.view.width=219;
    
    [self addChildViewController:_rightNController];
    [self.view addSubview:_rightNController.view];
    
    //隐藏工具栏
    [_rightNController setToolbarHidden:YES];
    [_rightNController setNavigationBarHidden:YES];
    
    _rightNController.view.layer.shadowColor=[[UIColor blackColor] CGColor];
    //self.view.layer.shadowOffset=CGSizeMake(-5.0, 0);//好像不加也行
    _rightNController.view.layer.shadowRadius=5;
    _rightNController.view.layer.shadowOpacity = 0.8;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)findAction:(UIButton *)sender
{
    
    MIFindController *findController=[[MIFindController alloc]initWithNibName:@"findView" bundle:nil];
    
  
    [_leftNController popToRootViewControllerAnimated:NO];
    [_rightNController popToRootViewControllerAnimated:NO];
   
  
    
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
    MIPublishTaskActivityController *taController=[[MIPublishTaskActivityController alloc]initWithNibName:@"publishTaskActivityView" bundle:nil Can_need_activity:can_need_activity];
    
    [_leftNController popViewControllerAnimated:NO];//一定要NO，不然出错(动画切太快导致错误)
    [_leftNController pushViewController:taController animated:NO];
    
    //左边切换后，与左边关联的右边的controller需要释放
    [_rightNController popToRootViewControllerAnimated:NO];
    
    
}

- (IBAction)tapBack:(UIControl *)sender
{
    //如果是发布任务的controller 则取消键盘
    if ([_leftNController.topViewController isKindOfClass:MIPublishTaskActivityController.class])
    {
        MIPublishTaskActivityController *pController=_leftNController.topViewController;
        
        [pController.titleField resignFirstResponder];
        [pController.contentTextView resignFirstResponder];
        [pController.rewardTextView resignFirstResponder];
        [pController.mobileTextView resignFirstResponder];
    }
    
}

///点击搜索用户，任务活动
- (IBAction)searchUTA:(UIButton *)sender
{
    
    MISearchUTAController *sc=[[MISearchUTAController alloc] initWithNibName:@"searchUTAView" bundle:nil];
    [_leftNController pushViewController:sc animated:NO];
    
    [_rightNController popToRootViewControllerAnimated:NO];
}

///点击头像
- (IBAction)myInfo:(id)sender
{
    MIUserInfoController *myInfo=[[MIUserInfoController alloc] initWithNibName:@"UserInfoController" bundle:nil userInfo:[MIUser getInstance]];
    [_leftNController popViewControllerAnimated:NO];
    [_leftNController pushViewController:myInfo animated:NO];
    
    [_rightNController popToRootViewControllerAnimated:NO];
}


@end
