//
//  MIImageGridView.m
//  microTask
//
//  Created by blink_invoker on 8/22/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import "MIImageScaleUtil.h"
#import "MIImageGridView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MITapGesture.h"
#import "MIViewController.h"
#import "MIImageScrollController.h"
#import "UIView+cat.h"
#import "MIPoint.h"
#import "MITapGesture.h"
#import "MIViewController.h"
@implementation MIImageGridView
{
    int _photoCnt;
    NSArray *_photos;
    float _width;
    int _row;
    int _col;
    float _pWidth;
    
    
}

-(id)initWithWidth:(float)width withPhotos:(NSArray *)photos withPhotoWidth:(float)pWidth withColumn:(int)col;
{
    self=[super init];
    self.backgroundColor=[UIColor clearColor];
    _photoCnt=photos.count;
    _photos=photos;
    _width=width;
    _pWidth=pWidth;
    _col=col;
    
    _row=_photoCnt/col;
    if (_photoCnt%col!=0) {
        _row++;
    }
    
    if (self)
    {
         //设置imageView的frame
        self.frame=CGRectMake(0, 0, _width, _pWidth*_row+(_row-1)*10);
        //缩略图的相对屏幕坐标
        NSMutableArray *points=[[NSMutableArray alloc] init];
        //点击事件数组
        NSMutableArray *taps=[[NSMutableArray alloc] init];
        int index=0;
        //动态设置子view(子view里嵌套imageView)
        for (int i=0; i<_row&&index<_photoCnt; i++)
        {
            for (int j=0; j<_col&&index<_photoCnt; j++)
            {
                UIView *subView=[[UIView alloc] initWithFrame:CGRectMake(j*10+j*_pWidth, i*10+i*_pWidth,_pWidth, _pWidth)];
                [self addSubview:subView];
                
                subView.backgroundColor=[UIColor clearColor];
                UIImageView *image=[[UIImageView alloc] init];
                
                [MIImageScaleUtil setImageScaleAndContent:CGSizeMake(_pWidth, _pWidth) imageView:image photoUrl:[_photos objectAtIndex:index++]];
                
                [subView addSubview:image];
                
                UIView *window=[MIViewController getInstance].view.window;
                //这里暂时不知道怎么搞！！！！！
                NSLog(@"%f,%f",subView.center.x,subView.center.y);
                CGPoint point=[image convertPoint:CGPointMake(0, 0) toView:self];
                
                MIPoint *mypoint=[[MIPoint alloc] init];
                mypoint.x=subView.center.x;
                mypoint.y=subView.center.y;
                [points addObject:mypoint];
                
                //添加图片点击事件
                MITapGesture *tap=[[MITapGesture alloc] initWithTarget:self action:@selector(tapImage:)];
                
                //通过tap事件传递图片数组和当前被点击图片的index
                NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
                [dic setValue:_photos forKey:@"photos"];
                [dic setValue:[NSNumber numberWithInt:index-1]  forKey:@"index"];
                tap.dic=dic;
                [taps addObject:tap];
                [subView addGestureRecognizer:tap];
                
            }
        }
        
        for (int i=0; i<_photoCnt; i++)
        {
            MITapGesture *tap=[taps objectAtIndex:i];
            [tap.dic setValue:points forKey:@"points"];
        }
        
    }

    
    return self;
}

///在cell点击图片触发
-(void)tapImage:(MITapGesture*)gesture
{
    
    //当前被点击图片的下标
    int index=[[gesture.dic objectForKey:@"index"] intValue];
    //同一个cell中的一组图片
    NSArray *photos=[gesture.dic objectForKey:@"photos"];
    //图片相对屏幕的坐标数组
    NSArray *points=[gesture.dic objectForKey:@"points"];
    //主controller单例
    MIViewController *mainController=[MIViewController getInstance];
    MIImageScrollController *imageSController=[[MIImageScrollController alloc] initWithNibName:@"imageScrollView" bundle:nil withPhotos:photos withInitIndex:index withPoints:points];
    [mainController addChildViewController:imageSController];
    [mainController.view addSubview:imageSController.view];
    
    
}

@end
