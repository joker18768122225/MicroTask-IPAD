//
//  MITaskActivityDelegate.h
//  microTask
//
//  Created by blink_invoker on 8/25/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MITableCollectionViewDelegate <NSObject>

///http请求
-(void)request;

///接受http返回信息后的回调
-(void)loadCallBack:(NSDictionary*)response;

///滑动到底部的代理方法
-(void)loadMore;



@end
