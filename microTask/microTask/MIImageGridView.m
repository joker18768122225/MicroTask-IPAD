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
         //更新imageView的高度
        self.frame=CGRectMake(0, 0, _width, _pWidth*col+(_row-1)*10);

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
                
                //添加图片点击事件
                
                MITapGesture *tap=[[MITapGesture alloc] initWithTarget:self action:@selector(tapImage:)];
                
                //通过tap事件传递图片数组和当前被点击图片的index
                NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
                [dic setValue:_photos forKey:@"photos"];
                [dic setValue:[NSNumber numberWithInt:index-1]  forKey:@"index"];
                
                tap.dic=dic;
                [subView addGestureRecognizer:tap];
                
            }
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
    
    //主controller单例
    MIViewController *mainController=[MIViewController getInstance];
    MIImageScrollController *imageSController=[[MIImageScrollController alloc] initWithNibName:@"imageScrollView" bundle:nil withPhotos:photos withInitIndex:index];
    [mainController addChildViewController:imageSController];
    [mainController.view addSubview:imageSController.view];
    
    
}

@end
