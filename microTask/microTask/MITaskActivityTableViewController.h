//
//  MITaskActivityTableViewController.h
//  microTask
//
//  Created by blink_invoker on 8/25/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MITableCollectionViewDelegate.h"

///这个controller只是用来展示任务和活动，真正请求数据的工作交给delegate来做(也就是说分页参数以及请求字段等都在delegate中控制)
@interface MITaskActivityTableViewController : UITableViewController

///代理
@property id<MITableCollectionViewDelegate> delegate;

///有新数据时调用此方法，更新tableview,isReload为YES表示需要滑到顶部NO则继续下拉
-(void)reloadData:(NSDictionary*)dataDic isReload:(BOOL)isReload;

//高速代理是否加载完毕，避免重复请求http
@property (nonatomic,assign) BOOL isLoadEnd;

@end
