//
//  MIMyInfoController.m
//  microTask
//
//  Created by blink_invoker on 8/26/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import "MIUserInfoController.h"
#import "MIUser.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+cat.h"
#import "MIUserEditInfoController.h"
#import "MIViewController.h"
@implementation MIUserInfoController
{
    __weak IBOutlet UIButton *_editInfoButton;
    
    __weak IBOutlet UITextView *_profileTextView;
    
    __weak IBOutlet UILabel *_publishCntLabel;
    
    __weak IBOutlet UILabel *_applyCntLabel;
    
    __weak IBOutlet UILabel *_followCntLabel;
    
    __weak IBOutlet UILabel *_followerCntLabel;
    
    __weak IBOutlet UIButton *_avatarButton;
    
    __weak IBOutlet UILabel *_nickNameLabel;
    
    __weak IBOutlet UIImageView *_genderImageView;
    
    
    MIUser* _userInfo;
    
    __weak IBOutlet UIButton *_detailInfoButton;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil userInfo:(MIUser*)user
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _userInfo=user;
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    //淡入
    self.view.alpha = 0.1f;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 1.0f;
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _editInfoButton.layer.borderColor=[[UIColor grayColor] CGColor];
    _editInfoButton.layer.borderWidth=0.3;
    _editInfoButton.layer.cornerRadius=2;
    
    
    [_avatarButton sd_setBackgroundImageWithURL:[NSURL URLWithString:_userInfo.avatar] forState:UIControlStateNormal];

    
    if ([_userInfo.gender isEqualToString:@"m"])
        [_genderImageView setImage:[UIImage imageNamed:@"boy"]];
    else
        [_genderImageView setImage:[UIImage imageNamed:@"girl"]];
    
    _nickNameLabel.text=_userInfo.nickName;
    
    _followCntLabel.text=[NSString stringWithFormat:@"%d",_userInfo.followcnt];
    _followerCntLabel.text=[NSString stringWithFormat:@"%d",_userInfo.followercnt];
    
    if (!_userInfo.profile||[_userInfo.profile isEqualToString:@""])
        _profileTextView.text=@"个性签名:暂无";
    else
        _profileTextView.text= [NSString stringWithFormat:@"个性签名:%@",_userInfo.profile];
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)detailInfo:(UIButton *)sender
{
    NSLog(@"123");
}


- (IBAction)editInfo:(UIButton *)sender
{
    MIUserEditInfoController *editController=[[MIUserEditInfoController alloc] initWithNibName:@"MIUserEditInfoController" bundle:nil userInfo:[MIUser getInstance]];
    
    MIViewController *mainController=[MIViewController getInstance];
    [mainController.rightNController popToRootViewControllerAnimated:NO];
    [mainController.rightNController pushViewController:editController animated:NO];
    
}

@end
