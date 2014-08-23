//
//  MIAddTaskController.m
//  microTask
//
//  Created by blink_invoker on 8/10/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import "MIPublishTaskActivityController.h"
#import "MYButton.h"
#import "MIUpLoadFile.h"
#import "KxMenu.h"
#import "MICalendar.h"
#import "MIHttpTool.h"
#import "MIUser.h"
#import "MIViewController.h"
@implementation MIPublishTaskActivityController
{
    int day;
    int hour;
    NSMutableArray *images;
    
    NSString *type;//小分类
 
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Can_need_activity:(NSString*)can_need_activity
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.can_need_activity=can_need_activity;
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animatedAppear
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
    day=hour=0;
    
    images=[[NSMutableArray alloc]init];
    
    //改变图片列表边框
    self.imageTableView.contentSize=CGSizeMake(410, 0);
    self.imageTableView.layer.borderColor=self.contentTextView.layer.borderColor=[UIColor grayColor].CGColor;
    self.imageTableView.layer.borderWidth=self.contentTextView.layer.borderWidth=0.2;
    self.imageTableView.layer.cornerRadius=self.contentTextView.layer.cornerRadius=5.0;
    
    //旋转图片列表
    self.imageTableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    self.imageTableView.frame=CGRectMake(84, 420, 400, 200);
    
    //滑块图片
    UIImage *img= [UIImage imageNamed:@"point.png"];
    [self.slider1 setThumbImage:img forState:UIControlStateNormal];
    [self.slider2 setThumbImage:img  forState:UIControlStateNormal];
  
    self.slider2.minimumValue=self.slider1.minimumValue=0;
    self.slider2.maximumValue=self.slider1.maximumValue=100;
    self.slider2.value=self.slider1.value=0;
    
    //隐藏时间提示
    [self.timeImageView1 setHidden:YES];
    [self.timeImageView2 setHidden:YES];
    
    if ([self.can_need_activity isEqualToString:@"can"])
        self.can_need_activityLabel.text=@"我可以帮忙";
    else if (([self.can_need_activity isEqualToString:@"need"]))
        self.can_need_activityLabel.text=@"我需要帮忙";
    //发布活动则隐藏报酬
    else
    {
        [self.rewardLabel removeFromSuperview];
       [self.rewardTextView removeFromSuperview];
        self.can_need_activityLabel.text=@"发布活动";
        
        self.contentTextView.frame=CGRectMake(self.contentTextView.frame.origin.x, self.contentTextView.frame.origin.y, self.contentTextView.frame.size.width, 200);
    }
    
    //填写默认手机
    MIUser *user=[MIUser getInstance];


    if ((NSNull*)user.mobile!=[NSNull null]&& user.mobile!=nil&&![user.mobile isEqualToString:@""]&&![user.mobile isEqualToString:@"<null>"])
        self.mobileTextView.text=[MIUser getInstance].mobile;

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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll");
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        
    }
    NSUInteger row=indexPath.row;
    
    //旋转cell
    cell.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    cell.frame=CGRectMake(0, 0, 200, 200);
    
    UIImageView *image=[[UIImageView alloc] initWithImage:[images objectAtIndex:row]];
    
    image.frame=CGRectMake(0, 0, 200, 200);
    image.transform=CGAffineTransformMakeRotation(M_PI);
    
    MYButton *subButton=[[MYButton alloc] initWithFrame:CGRectMake(0 , 0, 32, 32)];
   
    [subButton setImage:[UIImage imageNamed:@"subImage.png"] forState:UIControlStateNormal];
    subButton.userData=indexPath;
    [subButton addTarget:self action:@selector(deletePicture:) forControlEvents:UIControlEventTouchUpInside];
   
    [cell addSubview:image];
    [cell addSubview:subButton];
   
    
    return cell;
    
}
-(void)deletePicture:(MYButton*)sender
{
    NSIndexPath *index=sender.userData;
    NSArray *arr=[NSArray arrayWithObject:index];
    
    [images removeObjectAtIndex:index.row];
    
    [self.imageTableView deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationLeft];
    
    [self.imageTableView reloadData];
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return images.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //  NSLog(@"123");

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (IBAction)titleDone:(UITextField *)sender
{
     [sender resignFirstResponder];
}

- (IBAction)tapBack:(UIControl *)sender
{
    [self.contentTextView resignFirstResponder];
    [self.titleField resignFirstResponder];
}

//滑动时触发
- (IBAction)slider1Change:(UISlider *)sender
{
     [_timeImageView1 setHidden:NO];
    float rate=sender.value/100;
    float offset=rate*340;
    
    _timeImageView1.frame=CGRectMake(100+offset, _timeImageView1.frame.origin.y, _timeImageView1.frame.size.width, _timeImageView1.frame.size.height);
    
    _hourLabel.frame=CGRectMake(100+offset, _hourLabel.frame.origin.y, _hourLabel.frame.size.width, _hourLabel.frame.size.height);
    
    hour=rate*24;
    _hourLabel.text=[NSString stringWithFormat:@"%d小时",hour];
    
    
}

- (IBAction)slider2Change:(UISlider *)sender
{
    [_timeImageView2 setHidden:NO];
    float rate=sender.value/100;
    float offset=rate*340;
    
    _timeImageView2.frame=CGRectMake(100+offset, _timeImageView2.frame.origin.y, _timeImageView2.frame.size.width, _timeImageView2.frame.size.height);
    
    _dayLabel.frame=CGRectMake(100+offset, _dayLabel.frame.origin.y, _dayLabel.frame.size.width, _dayLabel.frame.size.height);
    
    day=rate*30;
    _dayLabel.text=[NSString stringWithFormat:@"%d天",day];
   
    
}


-(void)setExpireDate
{
    
    NSString *res;
    if (hour==0&&day==0)
    {
        res=@"选择有效时间:";
        _validateDateLabel.text=res;
        return;
    }
    //如果0分钟
    if (hour==0)
    {
        res=[NSString stringWithFormat:@"有效期:%d天",day];
        _validateDateLabel.text=res;
        return;
    }
    
    //如果0天
    if (day==0)
    {
        res=[NSString stringWithFormat:@"有效期:%d小时",hour];
        _validateDateLabel.text=res;
        return;
    }
    
    _validateDateLabel.text=[NSString stringWithFormat:@"有效期:%d天%d小时",day,hour];
    
}
//滑动结束触发
- (IBAction)slider1Done:(UISlider *)sender
{
    [_timeImageView1 setHidden:YES];
    [self setExpireDate];
    
}

- (IBAction)slider2Done:(UISlider *)sender
{
    [_timeImageView2 setHidden:YES];
    [self setExpireDate];
    
    NSCalendar *calendar= [[NSCalendar alloc] init];
    
}

-(void)camera
{
    [self startAddPhoto:UIImagePickerControllerSourceTypeCamera];
}

-(void)photoLib
{
    [self startAddPhoto:UIImagePickerControllerSourceTypePhotoLibrary];

}

-(void)startAddPhoto:(UIImagePickerControllerSourceType) type
{
    
    //先设定sourceType 相机或相册
    UIImagePickerControllerSourceType sourceType = type;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate=self;
    picker.allowsEditing = NO;//设置可编辑
    picker.sourceType = sourceType;
    
    //跳转到照相页面
    [self presentViewController:picker animated:YES completion:nil];
    
}


- (IBAction)addPhoto:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"拍照"
                     image:nil
                    target:self
                    action:@selector(camera)],
      [KxMenuItem menuItem:@"相册"
                     image:nil
                    target:self
                    action:@selector(photoLib)],
      ];
    
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuItems];
  
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
    [images addObject:image];

    [self.imageTableView reloadData];
 
}

- (IBAction)close:(UIButton *)sender
{
    [[MIViewController getInstance].leftNController popViewControllerAnimated:NO];
  
}

///上传任务/活动
- (IBAction)submit:(UIButton *)sender
{
    
    NSString *title= self.titleField.text;
    NSString *content=self.contentTextView.text;
    
    //封装文件数组
    NSMutableArray *files= [[NSMutableArray alloc] init];
    for (int i=0; i<[images count]; i++)
    {
        NSData *fileData= UIImagePNGRepresentation([images objectAtIndex:i]);
        MIUpLoadFile *file=[[MIUpLoadFile alloc] init];
        file.fileData=fileData;
        file.fileName=[NSString stringWithFormat:@"%@%d",@"photo",i];
        file.mimeType=@"image/jpeg";
        file.key=@"images";
        
        [files addObject:file];
    }
    
    //当前时间
    MICalendar *publishCalendar=[[MICalendar alloc] initWithDate:[NSDate date]];
    
    double timeInterval=day*24*3600+hour*3600;
    
    //算出截止时间
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *expireDate=[NSDate dateWithTimeIntervalSinceNow:timeInterval];
    NSString *expiredate=[dateFormatter stringFromDate:expireDate];
    NSString *reward=self.rewardTextView.text;
    NSString *mobile=self.mobileTextView.text;
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setValue:[MIUser getInstance].uid forKey:@"uid"];
    [params setValue:self.can_need_activity forKey:@"can_need_activity"];
    [params setValue:type forKey:@"type"];
    [params setValue:title forKey:@"title"];
    [params setValue:content forKey:@"content"];
    [params setValue:expiredate forKey:@"expiredate"];
    if (![self.can_need_activity isEqualToString:@"activity"]) {
        [params setValue:reward forKey:@"reward"];
    }
    
    [params setValue:mobile forKey:@"mobile"];
    [params setValue:[NSNumber numberWithDouble:111.11111] forKey:@"longtitude"];
    [params setValue:[NSNumber numberWithDouble:22.222222] forKey:@"latitude"];
    
    
    SuccessBlock success=^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"%@",responseObject);
    };
    
    ErrorBlock error=^(AFHTTPRequestOperation *operation, NSError *error)
    {
         NSLog(@"%@",error);
    };

    [MIHttpTool httpRequestWithUrl:TASK_ACTIVITY_PUBLISH withParams:params withFiles:files withSuccessBlock:success withErrorBlock:error];
}




- (IBAction)chooseType:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"学习"
                     image:nil
                    target:self
                    action:@selector(chooseStudy)],
      [KxMenuItem menuItem:@"生活"
                     image:nil
                    target:self
                    action:@selector(chooseLife)],
      [KxMenuItem menuItem:@"娱乐"
                     image:nil
                    target:self
                    action:@selector(chooseEntertainment)],
      
      ];
    
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuItems];
    
}
-(void)chooseStudy
{
    self.typeLabel.text=@"学习";
    type=@"study";
}

-(void)chooseLife
{
    self.typeLabel.text=@"生活";
     type=@"life";
}

-(void)chooseEntertainment
{
    self.typeLabel.text=@"娱乐";
     type=@"entertainment";
}
@end
