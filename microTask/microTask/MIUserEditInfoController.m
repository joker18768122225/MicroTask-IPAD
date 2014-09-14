//
//  MIUserDetailInfoController.m
//  microTask
//
//  Created by blink_invoker on 8/26/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import "MIUserEditInfoController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "UIView+cat.h"
#import "MIUserEditProfileController.h"
#import "MIViewController.h"
#import "MIUserEditGenderView.h"
#import "MIHttpTool.h"
#import "MIChooseProvinceController.h"
#import "MIChooseDepartmentController.h"
#import "MIEditAvatarController.h"
#import "MIUpLoadFile.h"
#import "MIViewController.h"
#import "MIUserInfoController.h"
#import "MIDialogView.h"
@implementation MIUserEditInfoController
{
    MIUser *_userInfo;
    
    UIImage *_avatar;
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
-(void)setAvatar:(UIImage *)avatar
{
    [_avatarImageView setImage:avatar];
    _avatar=avatar;
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
    
    //初始化院校 院系id用于后面判断
    self.univid=[MIUser getInstance].univid;
    self.depid=[MIUser getInstance].depid;
    
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

//编辑院系
- (IBAction)editDepartment:(UIButton *)sender
{
    
    MIChooseDepartmentController *cdController= [[MIChooseDepartmentController alloc] initWithNibName:@"MIChooseDepartmentController" bundle:nil univid:_univid];
    
    UINavigationController *nController=[[UINavigationController alloc] initWithRootViewController:cdController];
    
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
    //滑出
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    
    
    [params setValue:[MIUser getInstance].uid forKey:@"uid"];
    [params setValue:_nickNameTextField.text forKey:@"nickname"];
    
    if ([_genderLabel.text isEqualToString:@"男"])
    {
        [params setValue:@"m" forKey:@"gender"];
    }
    else
    {
        [params setValue:@"f" forKey:@"gender"];
    }
    
    [params setValue:_profileTextView.text forKey:@"profile"];
    
    if (_univid!=0)
    {
        [params setValue:[NSNumber numberWithInt:_univid] forKey:@"univid"];
        if (_depid!=0) {
            [params setValue:[NSNumber numberWithInt:_depid] forKey:@"depid"];
        }
    }
    NSMutableArray *files=[[NSMutableArray alloc] init];
    if (_avatar)
    {
        MIUpLoadFile *avatar=[[MIUpLoadFile alloc] init];
        avatar.mimeType=@"image/jpeg";
        avatar.fileData=UIImageJPEGRepresentation(_avatar, 1);
        avatar.key=@"avatar";
        avatar.fileName=@"avatar";
        [files addObject:avatar];
    }
    else
    {
        files=nil;
    }
    //弹框
    MIDialogView *dialog=[MIDialogView initForMessage:@"正在修改资料" parentView:self.view];
    
    [MIHttpTool httpRequestWithUrl:USER_EDIT_INFO withParams:params withFiles:files withSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        //清除头像缓存
        NSString *avatarUrl=[NSString stringWithFormat:@"http://192.168.1.108:8080/microTask/image/avatar/%@/avatar",[MIUser getInstance].uid];
        NSLog(@"%@",avatarUrl);
        [[SDImageCache sharedImageCache] removeImageForKey:avatarUrl fromDisk:YES];
        
        NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
        [params setValue:[MIUser getInstance].uid forKey:@"uid"];
        [params setValue:[MIUser getInstance].uid forKey:@"finderuid"];
        
        //更新用户信息
        [MIHttpTool httpRequestWithMethod:@"get" withUrl:USER_SEARCH_BY_UID withParams:params withSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            NSDictionary *userDic=[responseObject objectForKey:@"user"];
            
            [MIUser initWithUid:[userDic objectForKey:@"uid"] withNickName:[userDic objectForKey:@"nickname"] withGender:[userDic objectForKey:@"gender"] withAvatar:[userDic objectForKey:@"avatar"] withProfile:[userDic objectForKey:@"profile"] withCredit:[[userDic objectForKey:@"credit"] intValue] withMobile:[userDic objectForKey:@"mobile"] withFollowercnt:[[userDic objectForKey:@"followercnt"] intValue] withFollowcnt:[[userDic objectForKey:@"followcnt"] intValue] withUniversity:[userDic objectForKey:@"university"] withDepartment:[userDic objectForKey:@"department"] withUnivid:[[userDic objectForKey:@"univid"] intValue] withDepid:[[userDic objectForKey:@"depid"] intValue]];
            
            
            //更新首页和主界面头像
            MIUserInfoController *uiController= [[MIViewController getInstance] leftNController].topViewController;
            [uiController.avatarButton sd_setImageWithURL:[NSURL URLWithString:[MIUser getInstance].avatar] forState:UIControlStateNormal];
            [[MIViewController getInstance].avatarButton sd_setImageWithURL:[NSURL URLWithString:[MIUser getInstance].avatar] forState:UIControlStateNormal];
            

            [dialog setStatusAndMessage:MIDialogViewType::DONE message:@"修改资料完成"];
            
        } withErrorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
        
        
    } withErrorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

- (IBAction)editAvatar:(UIButton *)sender
{
    MIEditAvatarController *eaController=[[MIEditAvatarController alloc] initWithNibName:@"MIEditAvatarController" bundle:nil preController:self];
    [self.navigationController pushViewController:eaController animated:NO];
}
- (IBAction)editNickname:(UIButton *)sender
{
    
}

@end
