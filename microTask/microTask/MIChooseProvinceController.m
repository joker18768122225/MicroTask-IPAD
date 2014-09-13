//
//  MIChooseProvinceController.m
//  microTask
//
//  Created by blink_invoker on 9/13/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import "MIChooseProvinceController.h"
#import "UIView+cat.h"
#import "MIHttpTool.h"
#import "MIProvinceCell.h"
#import "MIUserEditInfoController.h"
#import "MIChooseUniversityController.h"

@implementation MIChooseProvinceController

{
    __weak IBOutlet UITableView *_tableView;
    ///省份数组
    NSMutableArray *_provinces;
    ///省份到id映射
    NSMutableDictionary *_proDic;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
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
    _provinces=[[NSMutableArray alloc] init];
    _proDic=[[NSMutableDictionary alloc] init];
    
    //获取所有省份
    [MIHttpTool httpRequestWithMethod:@"get" withUrl:PROVINCE_ALL withParams:nil withSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *provinces=[responseObject objectForKey:@"provinces"];
        for (NSDictionary *province in provinces) {
            
            NSString *pname=[province objectForKey:@"pname"];
            NSNumber *provid=[province objectForKey:@"provid"];
            [_provinces addObject:pname];
            
            //建立映射
            [_proDic setValue:provid forKey:pname];
            
        }
        [_tableView reloadData];
        //不知道为什么必须要加上60，不然最下面的滑不出来
        _tableView.contentSize=CGSizeMake(_tableView.contentSize.width, _tableView.contentSize.height+60);
        
    } withErrorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [_tableView registerNib:[UINib nibWithNibName:@"MIProvinceCell" bundle:nil] forCellReuseIdentifier:@"provinceCell"];

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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"provinceCell";
    int row=indexPath.row;

    MIProvinceCell *proCell= [tableView dequeueReusableCellWithIdentifier:cellID];
    
    proCell.provinceLabel.text=[_provinces objectAtIndex:row];
    //先复原（重用问题）
    proCell.backgroundColor=[UIColor groupTableViewBackgroundColor];
    if (row%2==0)
    {
        proCell.backgroundColor=[UIColor whiteColor];
    }
    return proCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",[_provinces objectAtIndex:indexPath.row]);
    
    //获取row行对应省的id
    int provid=[[_proDic objectForKey:[_provinces objectAtIndex:indexPath.row]] intValue];
    
    MIChooseUniversityController *cuController=[[MIChooseUniversityController alloc] initWithNibName:@"MIChooseUniversityController" bundle:nil provid:provid];
    
    [self.navigationController pushViewController:cuController animated:NO];
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _provinces.count;
}
- (IBAction)close:(UIButton *)sender
{
   
    [UIView animateWithDuration:0.25 animations:^{
        self.view.x=self.view.width;
    } completion:^(BOOL finished) {
        
        UINavigationController *nController= self.navigationController;
       //获得编辑资料首页controller，使控件可用
        MIUserEditInfoController *eController=[nController parentViewController];
        [eController activateUIController];
        //释放
        [nController.view removeFromSuperview];
        [nController removeFromParentViewController];
    }];
    
    
}




@end
