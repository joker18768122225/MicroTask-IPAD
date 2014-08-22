//
//  MIImageScaleUtil.m
//  microTask
//
//  Created by blink_invoker on 8/22/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import "MIImageScaleUtil.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation MIImageScaleUtil


+(void)setImageScaleAndContent:(CGSize)maxSize imageView:(UIImageView*)imageDetailView photoUrl:(NSString*)photoUrl
{
    [imageDetailView sd_setImageWithURL:[NSURL URLWithString:photoUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        //加载完成后回调，根据图片的size按比例设置显示imageview的size
        float imgWidth=image.size.width,imgHeight=image.size.height;
        while (imgWidth>maxSize.width||imgHeight>maxSize.height)
        {
            float scale=1;//缩放因子
            if (imgWidth>maxSize.width)
            {
                scale=maxSize.width/imgWidth;
                //更新height和width
                imgHeight*=scale;
                imgWidth=maxSize.width;
            }
            if (imgHeight>maxSize.height)
            {
                scale=maxSize.height/imgHeight;
                imgWidth*=scale;
                imgHeight=maxSize.height;
            }
            
        }
        imageDetailView.frame=CGRectMake(maxSize.width/2-imgWidth/2, maxSize.height/2-imgHeight/2, imgWidth, imgHeight);
    }];
    

}

@end
