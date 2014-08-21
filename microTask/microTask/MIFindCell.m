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
#import "MIImageScrollController.h"
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

    //主controller单例
    MIViewController *mainController=[MIViewController getInstance];
    MIImageScrollController *imageSController=[[MIImageScrollController alloc] initWithNibName:@"imageScrollView" bundle:nil withPhotos:photos withInitIndex:index];
    [mainController addChildViewController:imageSController];
    [mainController.view addSubview:imageSController.view];
    
    
  }
-(void)closeImageDetail:(UIGestureRecognizer*)gesture
{
    [gesture.view removeFromSuperview];
}
@end
