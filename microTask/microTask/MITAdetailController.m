//
//  MITAdetailController.m
//  microTask
//
//  Created by blink_invoker on 8/22/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import "MITAdetailController.h"
#import "MIFindCellInfo.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "UIView+cat.h"
#import "MIImageGridView.h"
#import "MIViewController.h"
#import "MIHttpTool.h"
#import "MIUser.h"
@implementation MITAdetailController

{
    __weak IBOutlet UIView *_topBarView;
    
    __weak IBOutlet UIButton *_buttonLabel;
    
    __weak IBOutlet UILabel *_nickNameLabel;
    
    __weak IBOutlet UILabel *_typeLabel;
    
    __weak IBOutlet UILabel *_titleLabel;
    
    __weak IBOutlet UITextView *_contentTextView;
    
    __weak IBOutlet UITextView *_rewardTextView;
    
    __weak IBOutlet UILabel *_publishDateLabel;
    
    __weak IBOutlet UILabel *_expireDateLabel;
    
    __weak IBOutlet UILabel *_rewardLabel;
    
    __weak IBOutlet UILabel *_pDateLabel;
    
    __weak IBOutlet UILabel *_eDateLabel;
   
    __weak IBOutlet UIScrollView *_scrollView;

    __weak  IBOutlet UIButton *_applyButton;
    
    __weak IBOutlet UILabel *_applyLabel;
 
    MIFindCellInfo *_info;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil taInfo:(MIFindCellInfo*)info
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _info=info;
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
     //滑入
    self.view.x=450;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.x=0;
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [_buttonLabel sd_setImageWithURL:[NSURL URLWithString:_info.avatar] forState:UIControlStateNormal];
    _nickNameLabel.text=_info.nickName;
    
    //游客或已申请
    if ([_info.my_relation isEqualToString:@"apply"])
    {
        [_applyButton setHighlighted:YES];
        [_applyButton setTitle:@"取消申请" forState:UIControlStateNormal];
    }
    
    else if([_info.my_relation isEqualToString:@"publish"])
        _applyButton.hidden=YES;
    else
        [_applyButton setTitle:@"申请" forState:UIControlStateNormal];

    
    _typeLabel.text=[NSString stringWithFormat:@"%@(%@)",_info.can_need_activity,_info.type];
    
    _contentTextView.text=_info.content;
    _rewardTextView.text=_info.reward;
    
    _publishDateLabel.text=_info.publishDate;
    _expireDateLabel.text=_info.expireDate;
    
    //添加阴影
    _topBarView.layer.shadowColor=[[UIColor grayColor] CGColor];
    _topBarView.layer.shadowOffset=CGSizeMake(1, 1);//好像不加也行
    _topBarView.layer.shadowOpacity = 1;
    _topBarView.layer.shadowRadius=5;
    
    
    //设置content高度
    
    //将文字限制在这个size之内
    CGSize constraintSize = CGSizeMake(_contentTextView.width,CGFLOAT_MAX);
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
    
    //计算contentsize
    CGSize size = [_info.content boundingRectWithSize:constraintSize options: NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    
    size.height+=10;
    _contentTextView.height=size.height;
    

    //设置reward高度,位置
    _rewardLabel.y=_contentTextView.y+_contentTextView.height+20;
    
    constraintSize = CGSizeMake(_rewardTextView.width,CGFLOAT_MAX);
    size = [_info.reward boundingRectWithSize:constraintSize options: NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    size.height+=10;
    
    _rewardTextView.y=_contentTextView.height+10+_contentTextView.y;
    _rewardTextView.height=size.height;

    
    //设置开始时间和截止时间
    _pDateLabel.y=_rewardTextView.height+20+_rewardTextView.y;
    _eDateLabel.y=_pDateLabel.y+_pDateLabel.height+20;
    
    _publishDateLabel.y=_pDateLabel.y;
    _expireDateLabel.y=_eDateLabel.y;
    
    //图片gridview
    MIImageGridView *imageGridView=[[MIImageGridView alloc] initWithWidth:410 withPhotos:_info.photos withPhotoWidth:130 withColumn:3];
    
    imageGridView.x=20;
    imageGridView.y=_eDateLabel.y+_eDateLabel.height+20;
    
    _applyLabel.text=[NSString stringWithFormat:@"已有%d人申请",_info.applycnt];
    _applyLabel.y=imageGridView.y+20+imageGridView.height;
    
    
    
    [_scrollView addSubview:imageGridView];
    _scrollView.contentSize=CGSizeMake(_scrollView.contentSize.width, _applyLabel.y+_applyLabel.height+20);
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)close:(UIButton *)sender
{
    //滑出
    [UIView animateWithDuration:0.25 animations:^{
        self.view.x=450;
        //动画结束回调
    } completion:^(BOOL finished) {
        [[MIViewController getInstance].rightNController popViewControllerAnimated:NO];
    }];

}

- (IBAction)apply:(UIButton *)sender
{
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setValue:[MIUser getInstance].uid forKey:@"uid"];
    [params setValue:_info.taid forKey:@"taid"];
    [params setValue:@"13665656565" forKey:@"mobile"];
    
    [MIHttpTool httpRequestWithMethod:@"post" withUrl:TASK_ACTIVITY_APPLY withParams:params withSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_applyButton setTitle:@"取消申请" forState:UIControlStateNormal];
        [_applyButton setHighlighted:YES];
        NSLog(@"%@",responseObject);
        
    } withErrorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@",error);
    }];
}

@end
