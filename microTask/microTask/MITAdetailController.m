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
@implementation MITAdetailController

{
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_buttonLabel sd_setImageWithURL:[NSURL URLWithString:_info.avatar] forState:UIControlStateNormal];
    _nickNameLabel.text=_info.nickName;
    _typeLabel.text=[NSString stringWithFormat:@"%@(%@)",_info.can_need_activity,_info.type];
    
    _contentTextView.text=_info.content;
    _rewardTextView.text=_info.reward;
    
    _publishDateLabel.text=_info.publishDate;
    _expireDateLabel.text=_info.expireDate;
    
    self.view.frame=CGRectMake(574, 0, self.view.frame.size.width, 768);
    //添加阴影
    self.view.layer.shadowColor=[[UIColor blackColor] CGColor];
    //self.view.layer.shadowOffset=CGSizeMake(1, 1);
    self.view.layer.shadowOpacity = 1;
    self.view.layer.shadowRadius=5;
    
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
    MIImageGridView *imageGridView=[[MIImageGridView alloc] initWithWidth:430 withPhotos:_info.photos withPhotoWidth:130 withColumn:3];
    
    imageGridView.x=0;
    imageGridView.y=_eDateLabel.y+_eDateLabel.height+20;
    
    [_scrollView addSubview:imageGridView];
    _scrollView.contentSize=CGSizeMake(_scrollView.contentSize.width, imageGridView.y+imageGridView.height+20);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
