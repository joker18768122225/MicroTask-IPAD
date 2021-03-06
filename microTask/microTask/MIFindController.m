//
//  MIFindController.m
//  microTask
//
//  Created by blink_invoker on 8/8/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import "KxMenu.h"
#import "MIFindController.h"
#import "MIFindCellInfo.h"
#import "MIFindCell.h"
#import "MIProperties.h"
#import "MIHttpTool.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "MICalendar.h"
#import "MITapGesture.h"
#import "MIImageGridView.h"
#import "MIViewController.h"
#import "MITAdetailController.h"
#import "UIView+cat.h"
#import "MIUser.h"
#import "UIView+cat.h"
#import "MITaskActivityTableViewController.h"
#import "BMapKit.h"
#import "MIMapService.h"

@implementation MIFindController
{
    //当前选择小分类的按钮
    UIButton *chooseTypeButton;
    
    __weak IBOutlet UIView *_contentView;
    ///分页参数
    int page;
    int count;
    ///当前回调后是否需要tableview reload（换了个类别）
    BOOL isReload;
    ///当前回调后是否需要tableview reload（换了个类别）
    BOOL isLoading;
    ///列表中所有cell信息
    NSMutableArray *cellInfos;
    ///大分类
    NSString *can_need_activity;
    ///小分类
    NSString *type;
    
    //通用的展示任务活动的controller
    MITaskActivityTableViewController *_taTableController;
    
    BMKLocationService *_locService;
    BMKUserLocation *_location;
    
    double _longtitude,_latitude;
    
    ///是否第一次加载，若是第一次则需要先获取到位置在reloadAll
    BOOL _firstLoad;
    
}


-(void)viewWillAppear:(BOOL)animatedAppear
{
    //淡入
    
    self.view.alpha = 0.1f;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 1.0f;
    }];

    //每次切换回来都要加载最新任务活动(根据上一次选择的类型)(暂时不需要)
    //[self reloadCurrent];
    
    //每次都要重新定位
    _location=_locService.userLocation;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //参数初始化
    page=1;
    count=15;
    isReload=YES;
    isLoading=NO;
    can_need_activity=@"all";
    type=@"all";
    
    chooseTypeButton=self.allTypeButton;
    chooseTypeButton.enabled=NO;
    cellInfos=[[NSMutableArray alloc] init];
    
    _taTableController=[[MITaskActivityTableViewController alloc] initWithNibName:@"MITaskActivityTableViewController" bundle:nil];
    _taTableController.delegate=self;
    
    //添加任务活动展示的controller
    [self addChildViewController:_taTableController];
    [_contentView addSubview:_taTableController.view];
    
    _firstLoad=YES;
    
    //初始化定位服务
    _locService=[[BMKLocationService alloc] init];
     _locService.delegate=self;
    [_locService startUserLocationService];
    

    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)request
{
    //避免重复请求
    if (isLoading)
        return;
    
    isLoading=YES;
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [dic setValue:[MIUser getInstance].uid forKey:@"uid"];
    
    
    [dic setValue:[NSNumber numberWithDouble:_longtitude]forKey:@"longtitude"];
     
    [dic setValue:[NSNumber numberWithDouble:_latitude] forKey:@"latitude"];
    [dic setValue:[NSNumber numberWithInt:page] forKey:@"page"];
    [dic setValue:[NSNumber numberWithInt:count] forKey:@"count"];
    
    //如果下面两个参数不是all则设置
    
    //小分类参数
    if (![type isEqualToString:@"all"]) {
        [dic setValue:type forKey:@"type"];
        
    }
    //大分类参数
    if (![can_need_activity isEqualToString:@"all"]) {
        [dic setValue:can_need_activity forKey:@"can_need_activity"];
    }
    
    SuccessBlock success=^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"%@",responseObject);
        [self loadCallBack:responseObject];
        
    };
    
    ErrorBlock error=^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"%@",error);
    };
    
    [MIHttpTool httpRequestWithMethod:@"get" withUrl:TASK_ACTIVITY_FINDNEAR withParams:dic withSuccessBlock:success withErrorBlock:error ];
    
    //设置http正在请求，避免重复提交
    
    
    
}

-(void)reloadWithCan_Need_Activity:(NSString*)cna withType:(NSString*)t
{
    if (isLoading)
    {
        return;
    }
    //重置参数
    if (cna)
    {
        can_need_activity=cna;
    }
    if (t)
    {
        type=t;
    }
    //重置page
    page=1;
    isReload=YES;
    [self request];
    
    
}
-(void)reloadCurrent
{
    /*
    //切换到附近人物则滑动到顶部
    _taTableController.tableView.contentOffset=CGPointMake(0, 0);
    page=1;
    isReload=YES;
    [self request];
    */
}

///查询所有任务和活动
-(void)reloadAll
{
    if (isLoading)
    {
        return;
    }
    self.can_need_activityLabel.text=@"所有";
    [self reloadWithCan_Need_Activity:@"all" withType:nil];
    
}
-(void)reloadCan
{
    if (isLoading)
    {
        return;
    }
    self.can_need_activityLabel.text=@"我可以帮忙";
    [self reloadWithCan_Need_Activity:@"can" withType:nil];
}
-(void)reloadNeed
{
    if (isLoading)
    {
        return;
    }
    self.can_need_activityLabel.text=@"我需要帮忙";
    [self reloadWithCan_Need_Activity:@"need" withType:nil];
    
}
-(void)reloadActivity
{
     self.can_need_activityLabel.text=@"活动";
    [self reloadWithCan_Need_Activity:@"activity" withType:nil];
    
}

///下滑到底部触发请求
-(void)loadMore
{
    if (isLoading)
    {
        return;
    }
    isReload=NO;
    //数据加载完了则直接返回不能在loadmore
    if (_taTableController.isLoadEnd)
    {
        return;
    }
    page++;
    
    [self request];
    
}

///加载了任务活动数据后回调
-(void)loadCallBack:(NSDictionary*)dic
{
    
    //通知tableViewController更新
    [_taTableController reloadData:dic isReload:isReload];

    //改变正在读取状态(解锁)
    isLoading=NO;

}

- (IBAction)changeCan_Need_Activity:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"所有"
                     image:nil
                    target:self
                    action:@selector(reloadAll)],
      [KxMenuItem menuItem:@"活动"
                     image:nil
                    target:self
                    action:@selector(reloadActivity)],
      [KxMenuItem menuItem:@"我需要帮忙"
                     image:nil
                    target:self
                    action:@selector(reloadNeed)],
      [KxMenuItem menuItem:@"我可以帮忙"
                     image:nil
                    target:self
                    action:@selector(reloadCan)]
      
      ];
    
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuItems];
    
    
}


///查询所有小分类

- (IBAction)reloadAllType:(UIButton *)sender
{
    if (isLoading)
    {
        return;
    }
    
    //更新当前小分类button
    chooseTypeButton.enabled=YES;
    chooseTypeButton=sender;
    chooseTypeButton.enabled=NO;
    [self reloadWithCan_Need_Activity:nil withType:@"all"];
}

- (IBAction)reloadStudy:(UIButton *)sender
{
    if (isLoading)
    {
        return;
    }
    chooseTypeButton.enabled=YES;
    chooseTypeButton=sender;
    chooseTypeButton.enabled=NO;
    [self reloadWithCan_Need_Activity:nil withType:@"study"];
}
- (IBAction)reloadEntertainment:(UIButton *)sender
{
    if (isLoading)
    {
        return;
    }
    chooseTypeButton.enabled=YES;
    chooseTypeButton=sender;
    chooseTypeButton.enabled=NO;
    [self reloadWithCan_Need_Activity:nil withType:@"entertainment"];
    
    
}
- (IBAction)reloadLife:(UIButton *)sender
{
    if (isLoading)
    {
        return;
    }
    chooseTypeButton.enabled=YES;
    chooseTypeButton=sender;
    chooseTypeButton.enabled=NO;
    [self reloadWithCan_Need_Activity:nil withType:@"life"];
}

-(void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    _longtitude=userLocation.location.coordinate.longitude;
    _latitude=userLocation.location.coordinate.latitude;
    NSLog(@"%f,%f",_longtitude,_latitude);
    
    if (_firstLoad)
    {
        _firstLoad=NO;
        [self reloadAll];
    }
}

@end
