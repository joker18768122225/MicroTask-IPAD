//
//  MIEditAvatarController.m
//  microTask
//
//  Created by blink_invoker on 9/14/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import "MIEditAvatarController.h"
#import "UIView+cat.h"
#import "MIUserEditInfoController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MIUser.h"

@implementation MIEditAvatarController
{
    UIImage *_avatar;
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UIScrollView *_scrollView;
    MIUserEditInfoController *_preController;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil preController:(MIUserEditInfoController*)edController
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _preController=edController;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    //滑入
    self.view.x=self.view.width;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.x=0;
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _scrollView.layer.borderColor=[[UIColor grayColor] CGColor];
    _scrollView.layer.borderWidth=0.3;
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[[MIUser getInstance] avatar]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)camera:(id)sender
{
        [self changeAvatar:UIImagePickerControllerSourceTypeCamera];
}

- (IBAction)photos:(id)sender
{
        [self changeAvatar:UIImagePickerControllerSourceTypePhotoLibrary];
}

-(void)changeAvatar:(UIImagePickerControllerSourceType) type
{
    
    //先设定sourceType 相机或相册
    UIImagePickerControllerSourceType sourceType = type;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate=self;
    picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = sourceType;
    
    //跳转到照相页面
    [self presentViewController:picker animated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //关闭照相界面
    [picker dismissViewControllerAnimated:YES completion:nil];
    //获取原始照片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSData *imageData=UIImageJPEGRepresentation(image, 0.5);
    NSLog(@"%lu",(unsigned long)[imageData length]);
    
    image=[UIImage imageWithData:imageData];
    
    [_imageView setImage:image];
    _avatar=image;
}

- (IBAction)back:(UIButton *)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.x=self.view.width;
    } completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:NO];
    }];
}
- (IBAction)confirm:(UIButton *)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.x=self.view.width;
    } completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:NO];
        [_preController setAvatar:_avatar];
        [self.navigationController popViewControllerAnimated:NO];
    }];
}


@end
