//
//  MIUserCollectionViewController.m
//  microTask
//
//  Created by blink_invoker on 8/25/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import "MIUserCollectionViewController.h"
#import "MIUser.h"
#import "MIUserCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "MIHttpTool.h"
#import "MITaskActivityTableViewController.h"
#import "MIUserCollectionViewController.h"
#import "UIView+cat.h"
@implementation MIUserCollectionViewController

{
    NSMutableArray *_cellInfos;
    IBOutlet UICollectionView *_collectionView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _cellInfos=[[NSMutableArray alloc] init];
    //类似tableView注册cell信息
    [_collectionView registerNib:[UINib nibWithNibName:@"userCellView" bundle:nil] forCellWithReuseIdentifier:@"userCell"];
    _collectionView.alwaysBounceVertical=YES;
    
    
    self.view.x=0;
    //不知道为什么如果不这样设置，width height和xib中不一样，会自动改变
    self.view.height=704;
    self.view.width=475;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"userCell";
    MIUserCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.layer.borderColor=[[UIColor groupTableViewBackgroundColor] CGColor];
    cell.layer.borderWidth=0.3;
    //用户信息
    MIUser *info=[_cellInfos objectAtIndex:indexPath.row];
    //设置信息
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:info.avatar]];
    
    if ([info.gender isEqualToString:@"m"])
        [cell.genderImageView setImage:[UIImage imageNamed:@"boy"]];
    else
        [cell.genderImageView setImage:[UIImage imageNamed:@"girl"]];
    
    cell.followerCntLabel.text=[NSString stringWithFormat:@"粉丝数:%d",info.followercnt];
    cell.universityLabel.text=info.university;
    cell.nickNameLabel.text=info.nickName;
    
    cell.creditLabel.text=[NSString stringWithFormat:@"信用度:%d",info.credit];
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _cellInfos.count;
}

-(void)appendCellInfos:(NSDictionary*)response
{
    NSArray *users=[response objectForKey:@"users"];
    if (users.count<5)
    {
        [_collectionView reloadData];
        self.isLoadEnd=YES;
    }
    for (NSDictionary *userDic in users)
    {
        MIUser *user=[[MIUser alloc] init];
        user.nickName=[userDic objectForKey:@"nickname"];
        user.avatar=[userDic objectForKey:@"avatar"];
        user.gender=[userDic objectForKey:@"gender"];
        user.credit=[[userDic objectForKey:@"credit"] integerValue];
        user.followercnt=[[userDic objectForKey:@"followercnt"] integerValue];
        user.university=[userDic objectForKey:@"university"];
        user.department=[userDic objectForKey:@"department"];
        
        [_cellInfos addObject:user];
    }
    
    [_collectionView reloadData];
    
}

-(void)reloadData:(NSDictionary *)response isReload:(BOOL)isReload
{
    if (isReload)
    {
        [_cellInfos removeAllObjects];
        
        //reload动画
        self.view.alpha=0;
        _collectionView.contentOffset=CGPointMake(0, 0);
        [UIView animateWithDuration:1.0 animations:^{
            self.view.alpha=1.f;
        }];
    }
    [self appendCellInfos:response];
    
}

@end
