//
//  MISearchUTAController.m
//  microTask
//
//  Created by blink_invoker on 8/24/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import "MISearchUTAController.h"
#import "MIUser.h"
#import "MIUserCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "MIHttpTool.h"
#import "MITaskActivityTableViewController.h"
#import "MIUserCollectionViewController.h"

@implementation MISearchUTAController
{
    NSMutableArray *_cellInfos;
   
    ///用于显示任务活动
    MITaskActivityTableViewController *_taController;
    ///用于显示用户
    MIUserCollectionViewController *_userController;
    
    UIView *_curView;
    
    __weak IBOutlet UISegmentedControl *_segmentedControl;
    __weak IBOutlet UISearchBar *_searchBar;
    __weak IBOutlet UIView *_contentView;
    
    ///标示当前搜索的是用户 任务 活动
    int _curSelectedIndex;
    //分页参数
    int _page;
    int _count;
    NSString *_field;
    BOOL isLoading;
    BOOL isReload;//是否从第一页开始（区分滑动加载）
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _curSelectedIndex=0;
    _page=1;
    isReload=NO;
    isLoading=NO;
    _count=18;
    _field=@"";

    
    _cellInfos=[[NSMutableArray alloc] init];

    
    //添加任务活动的展示页面，初始隐藏
    _taController=[[MITaskActivityTableViewController alloc] initWithNibName:@"MITaskActivityTableViewController" bundle:nil];
    
    [self addChildViewController:_taController];
    [_contentView addSubview:_taController.view];
    _taController.view.hidden=YES;
    _taController.delegate=self;
    
     //添加用户的展示页面，初始隐藏
    _userController=[[MIUserCollectionViewController alloc] initWithNibName:@"MIUserCollectionViewController" bundle:nil];
    [self addChildViewController:_userController];
    [_contentView addSubview:_userController.view];
    _userController.view.hidden=YES;
    _curView=_taController.view;
    _userController.delegate=self;
  
}

-(void)viewWillAppear:(BOOL)animated
{
    //淡入
    self.view.alpha = 0.1f;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 1.0f;
    }];
}

///数据读取后回调
-(void)loadCallBack:(NSDictionary*)response
{
    _curView.hidden=YES;
    
    switch (_curSelectedIndex)
    {
            //用户
        case 0:
            _curView=_userController.view;
            _curView.hidden=NO;
            [_userController reloadData:response isReload:isReload];
            break;
            //任务活动
        case 1:
            _curView=_taController.view;
            _curView.hidden=NO;
            [_taController reloadData:response isReload:isReload];
            break;
    }
    
    isLoading=NO;//解锁
}

-(void)loadMore
{
    isReload=NO;
    switch (_curSelectedIndex)
    {
        case 0:
            if (_userController.isLoadEnd)
                return;
            
        case 1:
            if (_taController.isLoadEnd)
                return;
    }
    
    _page++;
    [self request];
}

-(void)request
{
    if (isLoading)
    {
        return;
    }
    isLoading=YES;//防止重复加载(上锁)
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setValue:[MIUser getInstance].uid forKey:@"uid"];
    [params setValue:[NSNumber numberWithInt:_page] forKey:@"page"];
    [params setValue:[NSNumber numberWithInt:_count] forKey:@"count"];
    
    switch (_curSelectedIndex)
    {
            //搜人
        case 0:
        {
            [params setValue:_field forKey:@"nickname"];
            [MIHttpTool httpRequestWithMethod:@"get" withUrl:USER_SEARCH_BY_NICKNAME withParams:params withSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                [self loadCallBack:responseObject];
            } withErrorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@",error);
            }];
            break;
        }
        case 1:
        {
            [params setValue:_field forKey:@"title"];
            [params setValue:[NSNumber numberWithDouble:111.111111] forKey:@"longtitude"];
            [params setValue:[NSNumber numberWithDouble:22.222222] forKey:@"latitude"];
            [MIHttpTool httpRequestWithMethod:@"get" withUrl:TASK_ACTIVITY_FINDBYTITLE withParams:params withSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                [self loadCallBack:responseObject];
            } withErrorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@",error);
            }];
            break;
        }
    }
}
static int lastSelect=0;
- (IBAction)changeType:(UISegmentedControl *)sender
{
    //如果没有输入信息则返回
    if ([_searchBar.text isEqualToString:@""])
    {
        sender.selectedSegmentIndex=lastSelect;
        return;
    }
    lastSelect=sender.selectedSegmentIndex;
    _curSelectedIndex=sender.selectedSegmentIndex;
    _field=_searchBar.text;
    _page=1;
    isReload=YES;
    [_searchBar resignFirstResponder];
    [self request];

}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    _field=searchBar.text;
    _page=1;
    isReload=YES;
    [self request];
}
@end
