//
//  UIView+cat.m
//  microTask
//
//  Created by blink_invoker on 8/22/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import "UIView+cat.h"

@implementation UIView (cat)


-(void)setWidth:(CGFloat)width
{
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
    
}
-(void)setHeight:(CGFloat)height
{
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}
-(void)setX:(CGFloat)x
{
    self.frame=CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}
-(void)setY:(CGFloat)y
{
    self.frame=CGRectMake(self.frame.origin.x,y, self.frame.size.width, self.frame.size.height);
}

-(CGFloat)width
{
    return self.frame.size.width;
}
-(CGFloat)height
{
    return self.frame.size.height;
}
-(CGFloat)x
{
    return self.frame.origin.x;
}
-(CGFloat)y
{
    return self.frame.origin.y;
}
@end
