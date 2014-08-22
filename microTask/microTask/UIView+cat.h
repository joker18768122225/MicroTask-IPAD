//
//  UIView+cat.h
//  microTask
//
//  Created by blink_invoker on 8/22/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (cat)

@property CGFloat width;
@property CGFloat height;
@property CGFloat x;
@property CGFloat y;

-(void)setWidth:(CGFloat)width;
-(void)setHeight:(CGFloat)height;
-(void)setX:(CGFloat)x;
-(void)setY:(CGFloat)y;

-(CGFloat)width;
-(CGFloat)height;
-(CGFloat)x;
-(CGFloat)y;

@end
