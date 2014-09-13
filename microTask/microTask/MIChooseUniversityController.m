//
//  MIChooseUniversityController.m
//  microTask
//
//  Created by blink_invoker on 9/13/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import "MIChooseUniversityController.h"
#import "UIView+cat.h"
#import "MIUniversityCell.h"
#import "MIHttpTool.h"
#import "MIUserEditInfoController.h"
@implementation MIChooseUniversityController
{
    
    __weak IBOutlet UITableView *_tableView;
    
    int _provid;
    ///院校数组
    NSMutableArray *_universities;
    ///院校名称到id映射
    NSMutableDictionary *_uniDic;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil provid:(int)provid
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    _provid=provid;
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _universities=[[NSMutableArray alloc] init];
    _uniDic=[[NSMutableDictionary alloc] init];
    
    [_tableView registerNib:[UINib nibWithNibName:@"MIUniversityCell" bundle:nil] forCellReuseIdentifier:@"univCell"];
  
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [dic setValue:[NSNumber numberWithInt:_provid] forKey:@"provinceid"];
    
    //根据省id获取省内院校
    [MIHttpTool httpRequestWithMethod:@"get" withUrl:UNIVERSITY_SEARCH_BYPID withParams:dic withSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *universities=[responseObject objectForKey:@"universities"];
        
        for (NSDictionary *uDic in universities)
        {
            NSString *univName=[uDic objectForKey:@"univName"];
            int univid=[[uDic objectForKey:@"univid"] intValue];
            
            [_universities addObject:univName];
            [_uniDic setValue:[NSNumber numberWithInt:univid] forKey:univName];
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
    NSString *univName=[_universities objectAtIndex:row];
    int univid= [[_uniDic objectForKey:univName] intValue];
    
    UINavigationController *nController= self.navigationController;
    
    MIUserEditInfoController *eController= [nController parentViewController];
    eController.univid=univid;
    [eController setUniversity:univName];
    
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
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _universities.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row=indexPath.row;
    static NSString* cellID=@"univCell";
    MIUniversityCell *cell= [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.universityLabel.text=[_universities objectAtIndex:row];
   
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
- (IBAction)back:(UIButton *)sender
{
    //滑出
    [UIView animateWithDuration:0.25 animations:^{
        self.view.x=self.view.width;
        //动画结束回调
    } completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:NO];
    }];}

@end
