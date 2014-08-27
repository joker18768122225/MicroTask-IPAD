//
//  MITaskActivityTableViewController.m
//  microTask
//
//  Created by blink_invoker on 8/25/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import "MITaskActivityTableViewController.h"
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
#import "UIView+cat.h"

@implementation MITaskActivityTableViewController
{

    ///当前回调后是否需要tableview reload（换了个类别）
    BOOL _isReload;
    
    ///列表中所有cell信息
    NSMutableArray *_cellInfos;

    IBOutlet UITableView *_tableView;

    
}
/**时间处理，string转date并计算发布时间与当前时间差，显示不同信息
 2分钟内显示：刚刚  一小时之内显示X分钟之前：
 一天内显示X小时之前 三天内显示：昨天，前天
 一年内显示：月-日 一年外显示：年-月-日
 (通用方法)
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

///向CellInfos中添加数据( (通用方法))
-(void)appendCellInfos:(NSDictionary*)response
{
    //获取任务活动数组
    NSArray *task_activities=[response objectForKey:@"tasks_activities"];
    
    //没有数据了
    if (task_activities.count<5)
        self.isLoadEnd=YES;
    
    for (NSDictionary *task_activity in task_activities)
    {
        
        //解析数据
        
        NSString *taid=[task_activity objectForKey:@"taid"];
        CGFloat applycnt=[[task_activity objectForKey:@"applycnt"] doubleValue];
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
        NSString *reward=[task_activity objectForKey:@"reward"];
        
        NSString *my_relation=[task_activity objectForKey:@"my_relation"];
        
        //添加进cellInfos中
        MIFindCellInfo *cellInfo=[[MIFindCellInfo alloc]init];
        cellInfo.taid=taid;
        cellInfo.nickName=nickName;
        cellInfo.publishDate=publishdate;
        cellInfo.expireDate=expiredate;
        cellInfo.avatar=avatar;
        cellInfo.my_relation=my_relation;
        
        if ([can_need_activity isEqualToString:@"can"])
            cellInfo.can_need_activity=@"可以帮忙";
        else if ([can_need_activity isEqualToString:@"need"])
            cellInfo.can_need_activity=@"需要帮忙";
        else
            cellInfo.can_need_activity=@"发布活动";
        
        NSArray *photos=[task_activity objectForKey:@"images"];
        //判断是否返回的图片是空数组
        if (![[photos objectAtIndex:0] isEqualToString:@""])
        {
            cellInfo.photos=photos;
        }
        cellInfo.type=type;
        cellInfo.title=title;
        cellInfo.content=content;
        cellInfo.reward=reward;
        
        [_cellInfos addObject:cellInfo];
    }
    
    //最后重新载入table数据
    [_tableView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _cellInfos=[[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellInfos.count+1;//+1因为最后一个cell显示activityindicator
}

///设置cell信息 (通用方法)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MIFindCell *cell=[[[NSBundle mainBundle] loadNibNamed:@"FindCell" owner:self options:nil] firstObject];
    
    float bottomY=cell.frame.origin.y;
    
    NSUInteger row=indexPath.row;
    //如果是最后一行，则显示正在加载的activity indicator view
    if (row==_cellInfos.count)
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

        //如果没有数据(加载到底)
        if (self.isLoadEnd)
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
    
    MIFindCellInfo *info=[_cellInfos objectAtIndex:row];
    cell.nickNameLabel.text=info.nickName;
    
    //异步加载图片
    [cell.avatarButton sd_setImageWithURL:[NSURL URLWithString:info.avatar] forState:UIControlStateNormal placeholderImage:nil];
    
    
    cell.timeLabel.text=info.publishDate;
    //cell.titleLabel.text=info.title;
    //cell.typeLabel.text=info.type;
    cell.can_need_activityLabel.text=[NSString stringWithFormat:@"%@(%@)",info.can_need_activity,info.type];
    cell.contentTextView.text=info.content;
    
    cell.backgroundColor=[UIColor clearColor];//必须在代码里设，只在xib设无效！！！！
    
    //更改文字内容高度
    cell.contentTextView.height=info.contentSize.height;
    
    
    int photoCnt=info.photoCnt;
    NSArray *photos=info.photos;
    
    //第一张图片的坐标Y
    float initPhotoY=cell.contentTextView.frame.origin.y+cell.contentTextView.frame.size.height;
    int index=0;
    //设置底部bottomBarView的Y坐标(若没有图片则就不会更新)
    float bottomBarY=cell.contentTextView.frame.origin.y+cell.contentTextView.frame.size.height+10;
    
    //设置图片(返回自定义的imageGridView)
    if (photoCnt>0)
    {
        MIImageGridView *imageGridView=[[MIImageGridView alloc] initWithWidth:435 withPhotos:photos withPhotoWidth:135 withColumn:3];
        
        imageGridView.frame=CGRectMake(10, bottomBarY, imageGridView.width, imageGridView.frame.size.height);
        [cell.cellContentView addSubview:imageGridView];
        
        //更新底部bottomBarView的Y坐标
        bottomBarY=imageGridView.y+imageGridView.height+10;
        
    }
    cell.bottomBar.y=bottomBarY;
    
    //求出cell仅仅内容的高度
    CGFloat cellHeight=bottomBarY+cell.bottomBar.height;
    
    //设置仅仅contentView的高度
    cell.cellContentView.height=cellHeight+10;
    
    //设置边框
    cell.cellContentView.layer.borderColor=[UIColor grayColor].CGColor;
    cell.cellContentView.layer.borderWidth=0.2;
    
    //整个findCell的高度（其实不设置也行，高度主要在返回高度的代理方法中设置）
    cell.height=cellHeight+20;
    
    return cell;
}
///滑动到底部事件，交给代理去做
-(void)loadMore
{
    [self.delegate loadMore];
}


///弹出任务活动详情 (通用方法)
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MIViewController *mainController= [MIViewController getInstance];
    
    MITAdetailController *taController= [[MITAdetailController alloc] initWithNibName:@"TAdetailView" bundle:nil taInfo:[_cellInfos objectAtIndex:indexPath.row]];
    
    [mainController.rightNController popViewControllerAnimated:NO];
    [mainController.rightNController pushViewController:taController animated:NO];
    
    
    
    
}
//滑动到底部触发
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ( scrollView.contentOffset.y>=scrollView.contentSize.height - scrollView.frame.size.height)
        [self loadMore];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果是最后一个cell
    if (indexPath.row==_cellInfos.count )
        return 40;
    
    //动态计算高度
    MIFindCellInfo *info=[_cellInfos objectAtIndex:indexPath.row];
    
    //将文字限制在这个size之内
    CGSize constraintSize = CGSizeMake(425,CGFLOAT_MAX);
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
    
    //计算contentsize
    CGSize size = [info.content boundingRectWithSize:constraintSize options: NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    
    size.height+=10;
    info.contentSize=size;
    
    //计算图片高度和纵向间隙
    int photoCnt=info.photos.count;
    int photoRow=photoCnt/3;
    if (photoCnt%3!=0)
        photoRow++;
    if (photoCnt==0)
    {
        photoRow=0;
    }
    info.photoRow=photoRow;
    info.photoCnt=photoCnt;
    float photoHeight=photoRow*10+10+photoRow*143;
    //计算cell内容的高度
    
    info.height=10+64+10+size.height+10+32+20+photoHeight;
    return info.height;//这样设置高度好像效率比较高比cell.frame.size.height(这样好像会多调用一次设置cell)好
    
}

-(void)reloadData:(NSDictionary *)dataDic isReload:(BOOL)isReload
{
    //reload则清空数据
    if (isReload)
    {
        //因为是reload，所以重置isLoadEnd
        self.isLoadEnd=NO;
        [_cellInfos removeAllObjects];
        
        //reload动画
        self.view.alpha=0;
         _tableView.contentOffset=CGPointMake(0, 0);
        [UIView animateWithDuration:1.0 animations:^{
             self.view.alpha=1.f;
        }];
        
        
    }
    //append cell的数据
    [self appendCellInfos:dataDic];
}

@end
