//
//  MIUserCollectionViewController.h
//  microTask
//
//  Created by blink_invoker on 8/25/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MITableCollectionViewDelegate.h"
@interface MIUserCollectionViewController : UICollectionViewController


///代理
@property id<MITableCollectionViewDelegate> delegate;

///有新数据时调用此方法，更新tableview,isReload为YES表示需要滑到顶部NO则继续下拉
-(void)reloadData:(NSDictionary*)dataDic isReload:(BOOL)isReload;

//高速代理是否加载完毕，避免重复请求http
@property (nonatomic,assign) BOOL isLoadEnd;

@property (strong, nonatomic) IBOutlet UICollectionView *view;


@end
