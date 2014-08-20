//
//  MIFindCell.m
//  microTask
//
//  Created by blink_invoker on 8/9/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import "MIFindCell.h"
#import "MIViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation MIFindCell

- (void)awakeFromNib
{
    // Initialization code
}


- (IBAction)forward:(UIButton *)sender
{
     NSLog(@"123213");
}

- (IBAction)userInfo:(UIButton *)sender
{
    NSLog(@"123213");
}

-(void)setImageScale:(UIImageView*)imageDeatailView photoUrl:(NSString*)photoUrl
{
    [imageDeatailView sd_setImageWithURL:[NSURL URLWithString:photoUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        //加载完成后回调，根据图片的size按比例设置显示imageview的size
        float imgWidth=image.size.width,imgHeight=image.size.height;
        while (imgWidth>1024||imgHeight>768)
        {
            float scale=1;//缩放因子
            if (imgWidth>1024)
            {
                scale=1024/imgWidth;
                //更新height和width
                imgHeight*=scale;
                imgWidth=1024;
            }
            if (imgHeight>768)
            {
                scale=768/imgHeight;
                imgWidth*=scale;
                imgHeight=768;
            }
            
        }
        imageDeatailView.frame=CGRectMake(1024/2-imgWidth/2, 768/2-imgHeight/2, imgWidth, imgHeight);
    }];

    
}



///在cell点击图片触发
-(void)tapImage:(MITapGesture*)gesture
{
    //当前被点击图片的下标
    int index=[[gesture.dic objectForKey:@"index"] intValue];
    //同一个cell中的一组图片
    NSArray *photos=[gesture.dic objectForKey:@"photos"];
    //返回主controller单例
    MIViewController *mainController=[MIViewController getInstance];
    //创建全屏view
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    view.backgroundColor=[UIColor blackColor];
    [mainController.view addSubview:view];
    
    UIImageView *imageDeatailView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
    
    [view addSubview:imageDeatailView];

    
    [self setImageScale:imageDeatailView photoUrl:[photos objectAtIndex:index]];
    //添加底部label
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(1024/2-100/2, 768-40, 100, 40)];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    label.text=[NSString stringWithFormat:@"%d/%d",index+1,photos.count];
    
    [view addSubview:label];
    
    //添加点击事件
    UIGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeImageDetail:)];
    view.userInteractionEnabled=YES;
    [view addGestureRecognizer:tap];
    
    //添加滑动事件
    //向右滑
    if (index>0)
    {
        MISwipeGesture *swipeGesture=[[MISwipeGesture alloc] initWithTarget:self action:@selector(swipeRight:)];
        
        [swipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
        
        [view addGestureRecognizer:swipeGesture];
        
        
    }
     //向左边滑
    if (index<photos.count-1)
    {
        MISwipeGesture *swipeGesture=[[MISwipeGesture alloc] initWithTarget:self action:@selector(swipeLeft:)];
        [swipeGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
        
        [view addGestureRecognizer:swipeGesture];
    }
    
}
-(void)closeImageDetail:(UIGestureRecognizer*)gesture
{
    [gesture.view removeFromSuperview];
}

-(void)swipeLeft:(MISwipeGesture*)gesture
{
    NSLog(@"swipeLeft");
}

-(void)swipeRight:(MISwipeGesture*)gesture
{
    NSLog(@"swipeRight");
}
@end
