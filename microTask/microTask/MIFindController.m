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

///通知列表更新
static NSString *NOTIFICATION_LOAD=@"load_task_activity";

//当前table高度
float tableHeight=0;
///分页参数
int page=1;
int count=5;
///当前回调后是否需要tableview reload（换了个类别）
BOOL isReload=YES;
///当前回调后是否需要tableview reload（换了个类别）
BOOL isLoading=NO;
///列表中所有cell信息
NSMutableArray *cellInfos;
///大分类
NSString *can_need_activity=@"all";
///小分类
NSString *type=@"all";

@implementation MIFindController
{
    //当前选择小分类的按钮
    UIButton *chooseTypeButton;
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    chooseTypeButton=self.allTypeButton;
    chooseTypeButton.enabled=NO;
    cellInfos=[[NSMutableArray alloc] init];
    
    // self.tableView.backgroundColor=[UIColor clearColor];
    
    //注册cell(不采用重用就不需要了，重用很容易出现错乱)
    // UINib *nib=[UINib nibWithNibName:@"FindCell" bundle:nil];
    // [self.tableView registerNib:nib forCellReuseIdentifier:@"cellID"];
    
    
    //获取到任务活动通知更新
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(loadCallback:)
     name:NOTIFICATION_LOAD
     object:nil];
    
    //初始时获取所有任务和活动
    [self reloadAll];
    
}

-(void)reloadCellInfos
{
    for(MIFindCellInfo *cell in cellInfos)
    {
        //将文字限制在这个size之内
        CGSize constraintSize = CGSizeMake(450,CGFLOAT_MAX);
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
        
        //计算contentsize
        CGSize size = [cell.content boundingRectWithSize:constraintSize options: NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
        
        size.height+=10;
        cell.contentSize=size;
        
        //计算图片高度和纵向间隙
        int photoCnt=cell.photos.count;
        int photoRow=photoCnt/3;
        if (photoCnt%3!=0)
            photoRow++;
        if (photoCnt==0)
        {
            photoRow=0;
        }
        cell.photoRow=photoRow;
        cell.photoCnt=photoCnt;
        float photoHeight=photoRow*10+10+photoRow*143;
        
        NSLog(@"%d",photoRow);
        
        //计算cell内容的高度
        cell.height=10+64+10+size.height+10+32+20+photoHeight;
        
    }
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
    {
        return;
    }
    isLoading=YES;
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    
    [dic setValue:[NSNumber numberWithDouble:111.11111111] forKey:@"longtitude"];
    [dic setValue:[NSNumber numberWithDouble:22.2222222] forKey:@"latitude"];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOAD object:self userInfo:responseObject];
    };
    
    ErrorBlock error=^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"%@",error);
    };
    
    
    
    [MIHttpTool httpRequestWithMethod:@"get" withUrl:TASK_ACTIVITY_SEARCH withParams:dic withSuccessBlock:success withErrorBlock:error ];
    
    //设置http正在请求，避免重复提交
    
    
    
}

-(void)reloadWithCan_Need_Activity:(NSString*)cna withType:(NSString*)t
{
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
    [self.tableView setContentOffset:CGPointMake(0,0) animated:YES];
    [self request];
    
    
}

///查询所有任务和活动
-(void)reloadAll
{
    self.can_need_activityLabel.text=@"所有";
    [self reloadWithCan_Need_Activity:@"all" withType:nil];
    
}
-(void)reloadCan
{
    self.can_need_activityLabel.text=@"我可以帮忙";
    [self reloadWithCan_Need_Activity:@"can" withType:nil];
}
-(void)reloadNeed
{
    self.can_need_activityLabel.text=@"我需要帮忙";
    [self reloadWithCan_Need_Activity:@"need" withType:nil];
    
}
-(void)reloadActivity
{
    [self reloadWithCan_Need_Activity:@"activity" withType:nil];
    
}

///下滑到底部触发请求
-(void)loadMore
{
    isReload=NO;
    //数据加载完了则直接返回不能在loadmore
    if (page==-1)
        return;
    
    page++;
    
    [self request];
    
}


/**时间处理，string转date并计算发布时间与当前时间差，显示不同信息
 2分钟内显示：刚刚  一小时之内显示X分钟之前：
 一天内显示X小时之前 三天内显示：昨天，前天
 一年内显示：月-日 一年外显示：年-月-日
 */
-(NSString*)getShowPublishDate:(NSString*)publishdate
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //string转发布时间
    
    NSDate *publishDate=[dateFormatter dateFromString:publishdate];
    NSDate *currentDate=[NSDate date];
    
    //自定义的canlendar
    MICalendar *publishCalendar=[[MICalendar alloc] initWithDate:publishDate];
    MICalendar *currentCalendar=[[MICalendar alloc] initWithDate:currentDate];
    
    
    //发布日期不在今年
    if (publishCalendar.year<currentCalendar.year)
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        return [dateFormatter stringFromDate:publishDate];
    }
    //发布日期在今年,但不在这个月
    if (publishCalendar.month<currentCalendar.month)
    {
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        return [dateFormatter stringFromDate:publishDate];
    }
    //发布日期在这个月,但不在前天之内
    if (currentCalendar.day-publishCalendar.day>2)
    {
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        return [dateFormatter stringFromDate:publishDate];
    }
    
    //发布日期在前天
    if (currentCalendar.day-publishCalendar.day==2)
    {
        [dateFormatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"前天 %@",[dateFormatter stringFromDate:publishDate]];
    }
    //发布日期昨天
    else if(currentCalendar.day-publishCalendar.day==1)
    {
        [dateFormatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:publishDate]];
    }
    //今天
    //在1小时外发布
    if (currentCalendar.hour-publishCalendar.hour>=1)
        return [NSString stringWithFormat:@"%d小时前",currentCalendar.hour-publishCalendar.hour];
    
    //2分钟外发布
    if (currentCalendar.minute-publishCalendar.minute>2)
        return [NSString stringWithFormat:@"%d分钟前",currentCalendar.minute-publishCalendar.minute];
    
    return @"刚刚";
    
}


///向CellInfos中添加数据
-(void)appendCellInfos:(NSDictionary*)response isReload:(BOOL)isReload
{
    //获取任务活动数组
    NSArray *task_activities=[response objectForKey:@"tasks_activities"];
    
    //没有数据了
    if ([task_activities count]==0)
    {
        //page=-1表示已经到底，不在load more
        page=-1;
        return;
    }
    
    for (NSDictionary *task_activity in task_activities)
    {
        
        //解析数据
        NSDictionary *user= [task_activity objectForKey:@"user"];
        NSString *avatar=[user objectForKey:@"avatar"];
        NSString *nickName=[user objectForKey:@"nickname"];
        
        NSString *publishdate=[task_activity objectForKey:@"publishdate"];
        NSString *expiredate=[task_activity objectForKey:@"expiredate"];
        
        publishdate=[self getShowPublishDate:publishdate];
        
        NSString *type=[task_activity objectForKey:@"type"];
        NSString *can_need_activity=[task_activity objectForKey:@"can_need_activity"];
        NSString *title=[task_activity objectForKey:@"title"];
        NSString *content=[task_activity objectForKey:@"content"];
        
        //添加进cellInfos中
        MIFindCellInfo *cellInfo=[[MIFindCellInfo alloc]init];
        cellInfo.nickName=nickName;
        cellInfo.time=publishdate;
        cellInfo.avatar=avatar;
        
        if ([can_need_activity isEqualToString:@"can"])
            cellInfo.can_need_activity=@"我可以帮忙";
        else if ([can_need_activity isEqualToString:@"need"])
            cellInfo.can_need_activity=@"我需要帮忙";
        else
            cellInfo.can_need_activity=@"活动";
        
        NSArray *photos=[task_activity objectForKey:@"images"];
        //判断是否返回的图片是空数组
        if (![[photos objectAtIndex:0] isEqualToString:@""])
        {
            cellInfo.photos=photos;
        }
        
        NSLog(@"%@",cellInfo.photos);
        cellInfo.type=type;
        cellInfo.title=title;
        cellInfo.content=content;
        
        [cellInfos addObject:cellInfo];
    }
    
    [self reloadCellInfos];
    
    
}

///加载了任务活动数据后回调
-(void)loadCallback:(NSNotification*)notification
{
    if (isReload)
    {
        //由于是重新载入所以删除所有信息
        [cellInfos removeAllObjects];
    }
    
    //添加信息
    [self appendCellInfos:[notification userInfo] isReload:YES];
    [self.tableView reloadData];
    
    //改变正在读取状态
    isLoading=NO;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellInfos.count+1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MIFindCell *cell=[[[NSBundle mainBundle] loadNibNamed:@"FindCell" owner:self options:nil] firstObject];
    
    float bottomY=cell.frame.origin.y;
    
    NSUInteger row=indexPath.row;
    //如果是最后一行，则显示正在加载的activity indicator view
    if (row==cellInfos.count)
    {
        UITableViewCell *bottomCell=[[UITableViewCell alloc] initWithFrame:CGRectMake(cell.frame.origin.x, bottomY, cell.frame.size.width, 40)];
        
        //!!注意好像由于重用问题如果下面注释部分这样写会导致tableview混乱，先删完所有子view在添加，会出错，不知道为什么应该是重用问题，解决方法对于最下面的view每次新创建一个cell
        
        /* //先清空所有subview
         NSArray *subviews=cell.contentView.subviews;
         
         for (UIView *subview in subviews) {
         [subview removeFromSuperview];
         }*/
        // cell.frame=CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, 40);
        bottomCell.backgroundColor=[UIColor clearColor];
        
        
        //如果没有数据
        if (page==-1)
        {
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(180, -10, 140, 40)];
            // [label seta]
            label.textAlignment=NSTextAlignmentCenter;
            label.text=@"没有更多内容";
            [bottomCell addSubview:label];
            return bottomCell;
        }
        
        //添加activity indicator
        UIActivityIndicatorView *view=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(240, 10, 20, 20)];
        view.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
        view.color=[UIColor blackColor];
        [view startAnimating];
        [bottomCell addSubview:view];
        
        
        return bottomCell;
    }
    
    
    
    
    MIFindCellInfo *info=[cellInfos objectAtIndex:row];
    cell.nickNameLabel.text=info.nickName;
    
    //异步加载图片
    [cell.avatarButton sd_setImageWithURL:[NSURL URLWithString:info.avatar] forState:UIControlStateNormal placeholderImage:nil];
    
    
    cell.timeLabel.text=info.time;
    cell.titleLabel.text=info.title;
    cell.typeLabel.text=info.type;
    cell.can_need_activityLabel.text=info.can_need_activity;
    cell.contentTextView.text=info.content;
    
    cell.backgroundColor=[UIColor clearColor];//必须在代码里设，只在xib设无效！！！！
    //更改文字内容高度
    cell.contentTextView.frame = CGRectMake(cell.contentTextView.frame.origin.x, cell.contentTextView.frame.origin.y, cell.contentTextView.frame.size.width, info.contentSize.height);
    
    
    
    int photoCnt=info.photoCnt;
    int photoRow=info.photoRow;
    NSArray *photos=info.photos;
    
    //第一张图片的坐标Y
    float initPhotoY=cell.contentTextView.frame.origin.y+cell.contentTextView.frame.size.height;
    
    int index=0;
    //设置底部bottomBarView的Y坐标
    float bottomBarY=cell.contentTextView.frame.origin.y+cell.contentTextView.frame.size.height+10;
    
    //动态设置图片位置
    for (int i=0; i<photoRow&&index<photoCnt; i++)
    {
        for (int j=0; j<3&&index<photoCnt; j++)
        {
            UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake((j+1)*10+j*143, (i+1)*10+i*143+initPhotoY,143 , 143)];
            [cell.cellContentView addSubview:image];
            //根据最后一张图片位置更新bottomBarY
            bottomBarY=image.frame.origin.y+image.frame.size.height+10;
            
            [image sd_setImageWithURL:[photos objectAtIndex:index++]];
            
            //添加图片点击事件
            image.userInteractionEnabled=YES;
            
            MITapGesture *tap=[[MITapGesture alloc] initWithTarget:cell action:@selector(tapImage:)];
            
            //通过tap事件传递图片数组和当前被点击图片的index
            NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
            [dic setValue:info.photos forKey:@"photos"];
            [dic setValue:[NSNumber numberWithInt:index-1]  forKey:@"index"];
            
            tap.dic=dic;
            [image addGestureRecognizer:tap];
            
        }
        
    }
    
    cell.bottomBar.frame=CGRectMake(cell.bottomBar.frame.origin.x, bottomBarY, cell.bottomBar.frame.size.width,cell.bottomBar.frame.size.height );
    
    //求出cell仅仅内容的高度
    CGFloat cellHeight=bottomBarY+cell.bottomBar.frame.size.height;
    
    //设置仅仅contentView的高度
    cell.cellContentView.frame=CGRectMake(cell.cellContentView.frame.origin.x, cell.cellContentView.frame.origin.y, cell.cellContentView.frame.size.width,cellHeight+10);
    
    //设置边框和边角
    cell.cellContentView.layer.borderColor=[UIColor grayColor].CGColor;
    cell.cellContentView.layer.borderWidth=0.2;
    cell.cellContentView.layer.cornerRadius=5.0;
    
    //整个findCell的高度（其实不设置也行，高度主要在返回高度的代理方法中设置）
    cell.frame=CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width,cellHeight+20);
    
    
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // NSLog(@"%f,%f",scrollView.contentSize.height,scrollView.contentOffset.y);
    if (!isLoading&& scrollView.contentOffset.y>=scrollView.contentSize.height - scrollView.frame.size.height)
    {
        //NSLog(@"loadMore");
        //避免重复的loading
        
        NSLog(@"loadMore");
        [self loadMore];
        
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果是最后一个cell
    if (indexPath.row==cellInfos.count )
    {
        return 40;
    }
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    MIFindCellInfo *info=[cellInfos objectAtIndex:indexPath.row];
    return info.height;//这样设置高度好像效率比较高比cell.frame.size.height(这样好像会多调用一次设置cell)好
    
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
    //更新当前小分类button
    chooseTypeButton.enabled=YES;
    chooseTypeButton=sender;
    chooseTypeButton.enabled=NO;
    [self reloadWithCan_Need_Activity:nil withType:@"all"];
}

- (IBAction)reloadStudy:(UIButton *)sender
{
    chooseTypeButton.enabled=YES;
    chooseTypeButton=sender;
    chooseTypeButton.enabled=NO;
    [self reloadWithCan_Need_Activity:nil withType:@"study"];
}
- (IBAction)reloadEntertainment:(UIButton *)sender
{
    chooseTypeButton.enabled=YES;
    chooseTypeButton=sender;
    chooseTypeButton.enabled=NO;
    [self reloadWithCan_Need_Activity:nil withType:@"entertainment"];
    
    
}
- (IBAction)reloadLife:(UIButton *)sender
{ chooseTypeButton.enabled=YES;
    chooseTypeButton=sender;
    chooseTypeButton.enabled=NO;
    [self reloadWithCan_Need_Activity:nil withType:@"life"];
}
@end
