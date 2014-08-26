//
//  MIUserEditProfileController.m
//  microTask
//
//  Created by blink_invoker on 8/26/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import "MIUserEditProfileController.h"
#import "MIViewController.h"
#import "UIView+cat.h"
@implementation MIUserEditProfileController

{
    __weak IBOutlet UITextView *_profileTextView;
    
    __weak IBOutlet UILabel *_wordCntLabel;
    
    UITextView *_preTextView;
}
-(void)viewWillAppear:(BOOL)animated
{
    //滑入
    self.view.x=450;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.x=0;
    }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil textView:(UITextView*)preTextView
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _preTextView=preTextView;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _profileTextView.text=_preTextView.text;
    
    //剩余可填写字数
    long availableCnt=50-_profileTextView.text.length;
    
    if (availableCnt<0)
        _wordCntLabel.textColor=[UIColor redColor];
    else
        _wordCntLabel.textColor=[UIColor greenColor];
    
    //动态改变字体
    _wordCntLabel.text=[NSString stringWithFormat:@"%ld",availableCnt];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)confirm:(UIButton *)sender
{
    //更新上一页的个性签名
    _preTextView.text=_profileTextView.text;
    
    [self back:sender];
    
}

- (IBAction)back:(UIButton *)sender
{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.x=450;
    } completion:^(BOOL finished) {
        [[MIViewController getInstance].rightNController popViewControllerAnimated:NO];
    }];
    
    
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    //剩余可填写字数
    long availableCnt=50-_profileTextView.text.length;
    
    if (availableCnt<0)
        _wordCntLabel.textColor=[UIColor redColor];
    else
        _wordCntLabel.textColor=[UIColor greenColor];

    //动态改变字体
    _wordCntLabel.text=[NSString stringWithFormat:@"%ld",availableCnt];
}


@end
