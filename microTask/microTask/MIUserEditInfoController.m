//
//  MIUserDetailInfoController.m
//  microTask
//
//  Created by blink_invoker on 8/26/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import "MIUserEditInfoController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+cat.h"
#import "MIUserEditProfileController.h"
#import "MIViewController.h"
#import "MIUserEditGenderView.h"
#import "MIHttpTool.h"
#import "MIChooseProvinceController.h"

@implementation MIUserEditInfoController
{
    MIUser *_userInfo;
    
    __weak IBOutlet UIImageView *_avatarImageView;
    

    __weak IBOutlet UITextField *_nickNameTextField;
    
    __weak IBOutlet UILabel *_genderLabel;
    
    
    __weak IBOutlet UITextView *_profileTextView;
    
    
    __weak IBOutlet UILabel *_universityLabel;
    
    __weak IBOutlet UILabel *_departmentLabel;
    
    IBOutletCollection(UIButton) NSArray *_editButtons;
    
    __weak IBOutlet UIView *_educationInfoView;
    
    __weak IBOutlet UIButton *_profileButton;
    
    __weak IBOutlet UIButton *_genderButton;
    
    __weak IBOutlet UIButton *_universityButton;
    
}
-(void)activateUIController
{
    for (UIButton *button in _editButtons) {
        button.userInteractionEnabled=YES;
    }
    _nickNameTextField.userInteractionEnabled=YES;
}
-(void)dismissUIController
{
    for (UIButton *button in _editButtons) {
        button.userInteractionEnabled=NO;
    }
    _nickNameTextField.userInteractionEnabled=NO;

}
-(void)viewWillAppear:(BOOL)animated
{
    //滑入
    self.view.x=450;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.x=0;
    }];

    
    ///下面代码放在这是因为不知一次加载不能放在viewdidload中
    if (!_userInfo.profile||[_userInfo.profile isEqualToString:@""])
        _profileTextView.text=@"点击设置个性签名";
    else
    {
        //动态设置个性签名高度
        //设置content高度
        //将文字限制在这个size之内
        CGSize constraintSize = CGSizeMake(290.f,CGFLOAT_MAX);
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
        //计算contentsize
        CGSize size = [_profileTextView.text boundingRectWithSize:constraintSize options: NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
        
        size.height+=10;
        
        _profileTextView.height=size.height;
        _profileButton.height=_profileTextView.height+10;
        
        _educationInfoView.y=_profileButton.y+_profileButton.height+10;
    }
    
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  userInfo:(MIUser *)userInfo
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _userInfo=userInfo;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //outletcollecton里的button设置边框
    for (UIButton *button in _editButtons)
    {
        button.layer.borderColor=[[UIColor lightGrayColor] CGColor];
        button.layer.borderWidth=0.3;
        
        [button setBackgroundImage:[UIImage imageNamed:@"highlightedBG"]  forState:UIControlStateHighlighted];
    }
    
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:_userInfo.avatar]];
    
    //设置placeholder颜色

    _nickNameTextField.attributedPlaceholder=[[NSAttributedString alloc] initWithString:_userInfo.nickName attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    
    if ([_userInfo.gender isEqualToString:@"m"])
        _genderLabel.text=@"男";
    else
        _genderLabel.text=@"女";
    
    _universityLabel.text=_userInfo.university;
    _departmentLabel.text=_userInfo.department;
    
    _profileTextView.text=_userInfo.profile;

}
- (IBAction)editProfile:(UIButton *)sender
{
    MIUserEditProfileController *editPc=[[MIUserEditProfileController alloc] initWithNibName:@"MIUserEditProfileController" bundle:nil textView:_profileTextView];
    
    [[MIViewController getInstance].rightNController pushViewController:editPc animated:NO];
    
}
- (IBAction)editGender:(UIButton *)sender
{
    MIUserEditGenderView *editGV=[[[NSBundle mainBundle] loadNibNamed:@"editGenderView" owner:self options:nil] firstObject];
    
    editGV.genderLabel=_genderLabel;
    editGV.gender=_genderLabel.text;
    editGV.buttons=_editButtons;
    [self.view addSubview:editGV];
    
    //滑入
     editGV.y=768;
    [UIView animateWithDuration:0.25 animations:^{
        editGV.y=568;
    }];
    
    [self dismissUIController];
}

//用UINavigationController展示院校选择
- (IBAction)editUniversity:(UIButton *)sender
{
    
    UINavigationController *nController=[[UINavigationController alloc] initWithRootViewController:[[MIChooseProvinceController alloc] initWithNibName:@"MIChoosePronvinceController" bundle:nil]];
    
    //隐藏工具栏
    [nController setToolbarHidden:YES];
    [nController setNavigationBarHidden:YES];
    
    nController.view.y=_educationInfoView.y+_educationInfoView.height;
    nController.view.height=400;
    [self addChildViewController:nController];
    [self.view addSubview:nController.view];
    
    //使按钮失效
    [self dismissUIController];
}

- (IBAction)close:(UIButton *)sender
{
    //滑出
    [UIView animateWithDuration:0.25 animations:^{
        self.view.x=self.view.width;
        //动画结束回调
    } completion:^(BOOL finished) {
        [[MIViewController getInstance].rightNController popViewControllerAnimated:NO];
    }];
    
}
-(void)setUniversity:(NSString*)university
{
    _universityLabel.text=university;
}
-(void)setDepartment:(NSString*)department
{
    _departmentLabel.text=department;
}
- (IBAction)confirm:(UIButton *)sender
{
    
}
@end
