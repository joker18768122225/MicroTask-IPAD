//
//  MIChooseDepartmentController.m
//  microTask
//
//  Created by blink_invoker on 9/13/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import "MIChooseDepartmentController.h"
#import "MIDepartmentCell.h"
#import "MIHttpTool.h"
#import "MIUserEditInfoController.h"
#import "UIView+cat.h"
@implementation MIChooseDepartmentController
{
    int _univid;
    __weak IBOutlet UITableView *_tableView;
    NSMutableArray *_departments;
    NSMutableDictionary *_depDic;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil univid:(int)univid
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    _univid=univid;
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    //滑入
    self.view.x=self.view.width;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.x=0;
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _departments=[[NSMutableArray alloc] init];
    _depDic=[[NSMutableDictionary alloc] init];
    
    [_tableView registerNib:[UINib nibWithNibName:@"MIDepartmentCell" bundle:nil] forCellReuseIdentifier:@"depCell"];
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [dic setValue:[NSNumber numberWithInt:_univid] forKey:@"universityid"];
    
    //根据省id获取省内院校
    [MIHttpTool httpRequestWithMethod:@"get" withUrl:DEPARTMENT_SEARCH_BYUID withParams:dic withSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@,%@",responseObject,[responseObject objectForKey:@"msg"]);
        NSArray *deps=[responseObject objectForKey:@"departments"];
        
        for (NSDictionary *uDic in deps)
        {
            NSString *depName=[uDic objectForKey:@"depName"];
            int depid=[[uDic objectForKey:@"depid"] intValue];
            
            [_departments addObject:depName];
            [_depDic setValue:[NSNumber numberWithInt:depid] forKey:depName];
        }
        [_tableView reloadData];
        //不知道为什么必须要加上60，不然最下面的滑不出来
        _tableView.contentSize=CGSizeMake(_tableView.contentSize.width, _tableView.contentSize.height+60);
    } withErrorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

///选择院校
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row=indexPath.row;
    NSString *depName=[_departments objectAtIndex:row];
    int depid= [[_depDic objectForKey:depName] intValue];
    
    UINavigationController *nController= self.navigationController;
    
    MIUserEditInfoController *eController= [nController parentViewController];
    eController.depid=depid;
    [eController setDepartment:depName];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.x=self.view.width;
    } completion:^(BOOL finished) {
        [nController.view removeFromSuperview];
        [nController removeFromParentViewController];
        [eController activateUIController];
    }];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _departments.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row=indexPath.row;
    static NSString* cellID=@"depCell";
    MIDepartmentCell *cell= [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.depLabel.text=[_departments objectAtIndex:row];
    
    cell.backgroundColor=[UIColor groupTableViewBackgroundColor];
    if (row%2==0)
    {
        cell.backgroundColor=[UIColor whiteColor];
    }
    
    return  cell;
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
- (IBAction)close:(UIButton *)sender
{
    //滑出
    [UIView animateWithDuration:0.25 animations:^{
        self.view.x=self.view.width;
        //动画结束回调
    } completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:NO];
        UINavigationController *nController= self.navigationController;
        MIUserEditInfoController *eController= [nController parentViewController];
        [nController.view removeFromSuperview];
        [nController removeFromParentViewController];
        [eController activateUIController];
    }];
}



@end
