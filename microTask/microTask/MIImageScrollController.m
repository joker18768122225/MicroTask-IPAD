//
//  MIImageScrollController.m
//  microTask
//
//  Created by blink_invoker on 8/21/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import "MIImageScrollController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface MIImageScrollController ()
{
    NSArray *_photos;//图片url数组
    int _curIndex;//记录当前显示图片的下标
    int _count;
    NSMutableArray *_views;//scrollView的子view，这个子view里放imageView
}
@end

@implementation MIImageScrollController



///注意关于view的设置不要放在这里！！
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withPhotos:(NSArray*)photos withInitIndex:(int)index
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _photos=photos;
        _curIndex=index;
        _count=_photos.count;
        
    }
    return self;
}

///点击关闭
-(void)tap
{
    //注意要先移除view再移除controller
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
}
//不能添加手势会冲突
/*
 ///左滑（进入下一张）
 -(void)swipeLeft
 {
 NSLog(@"swipeLeft");
 if (_curIndex+1<_count)
 {
 [self.scrollView setContentOffset:CGPointMake((_curIndex+1)*1024, 0) animated:YES];
 }
 
 }
 
 
 ///右滑（进入上一张）
 -(void)swipeRight
 {
 NSLog(@"swipeRight");
 if (_curIndex-1>0)
 {
 [self.scrollView setContentOffset:CGPointMake((_curIndex-1)*1024, 0) animated:YES];
 }
 
 
 }
 */



- (void)viewDidLoad
{
    [super viewDidLoad];
    _views=[[NSMutableArray alloc] init];
    for (int i=0; i<_count; i++)
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(i*1024, 0, 1024, 768)];
        [_views addObject:view];
        view.backgroundColor=[UIColor blackColor];
        [self.scrollView addSubview:view];
        //添加imageView
        UIImageView *imageDetailView=[[UIImageView alloc] init];
        [self setImageScaleAndContent:imageDetailView photoUrl:[_photos objectAtIndex:i]];
        [view addSubview:imageDetailView];
        
        //添加底部label
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(1024/2-100/2, 768-40, 100, 40)];
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor whiteColor];
        
        label.text=[NSString stringWithFormat:@"%d/%d",i+1,_count];
        [view addSubview:label];
        
    }
    
    //记得设置contentSize
    self.scrollView.contentSize=CGSizeMake(_count*1024, 768);
    //设置初始位置
    [self.scrollView setContentOffset:CGPointMake(_curIndex*1024, 0)];
    //设置点击事件(移除view移除controller)
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
    
    
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
    
    _curIndex=(int)scrollView.contentOffset.x/1024;//更新当前图片下标
    // NSLog(@"%f,%d",scrollView.contentOffset.x,_curIndex);
    
}

///控制scrollView拖动停止时，即手指离开时，滚向最近的一张图片
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"velocity:%f",velocity.x);
    
    
    // velocity.x=100;
    //速度大于3.0则直接翻页
    if (fabs(velocity.x)>3.0)
    {
        //左滑
        if (velocity.x>0)
        {
            if (_curIndex+1<_count) {
                
                targetContentOffset->x=(_curIndex+1)*1024;
                [self.scrollView setContentOffset:CGPointMake((_curIndex+1)*1024, 0) animated:YES];
            }
        }
        //右滑
        else
        {
            if (_curIndex-1>0)
            {
                targetContentOffset->x=(_curIndex-1)*1024;
                [self.scrollView setContentOffset:CGPointMake((_curIndex-1)*1024, 0) animated:YES];
            }
            
            
        }
        return;
        
    }
    
    
    
    int mod=(int)scrollView.contentOffset.x%1024;
    //当前图片有大于一半的部分可见(则停留在该图片)
    
    if (mod<512)
    {
        targetContentOffset->x=_curIndex*1024;
        [self.scrollView setContentOffset:CGPointMake(_curIndex*1024, 0) animated:YES];
        
    }
    //当前图片有大于一半的部分移出屏幕(则移动到下一张图片)
    else
    {
        if (_curIndex+1<_count) {
            targetContentOffset->x=(_curIndex+1)*1024;
            [self.scrollView setContentOffset:CGPointMake((_curIndex+1)*1024, 0) animated:YES];
        }
    }
    
    
}



///异步加载图片后，设置图片尺寸
-(void)setImageScaleAndContent:(UIImageView*)imageDetailView photoUrl:(NSString*)photoUrl
{
    [imageDetailView sd_setImageWithURL:[NSURL URLWithString:photoUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
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
        imageDetailView.frame=CGRectMake(1024/2-imgWidth/2, 768/2-imgHeight/2, imgWidth, imgHeight);
    }];
}



@end
