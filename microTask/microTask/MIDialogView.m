//
//  MIDialogView.m
//  microTask
//
//  Created by blink_invoker on 9/14/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import "MIDialogView.h"
#import "UIView+cat.h"
@implementation MIDialogView
{
    __weak IBOutlet UIActivityIndicatorView *_doingView;
    __weak IBOutlet UIImageView *_doneView;
    __weak IBOutlet UILabel *_messageLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+(MIDialogView*)initForMessage:(NSString*)message parentView:(UIView*)view
{
    MIDialogView *dview=[[[NSBundle mainBundle] loadNibNamed:@"Dialog" owner:self options:nil] firstObject];
    //初始状态为正在操作
    [dview setStatusAndMessage:MIDialogViewType::DOING message:message];
    dview.x=view.width/2-dview.width/2;
    dview.y=view.height/2-dview.height/2;
    
    dview.layer.cornerRadius=5;
    [view addSubview:dview];
    
    return dview;
}

//设置显示正在操作还是操作完成
-(void)setStatusAndMessage:(MIDialogViewType)type message:(NSString*)message
{
    _messageLabel.text=message;
    if (type==MIDialogViewType::DOING)
    {
        _doingView.hidden=NO;
        [_doingView startAnimating];
        _doneView.hidden=YES;
    }
    else
    {
        _doingView.hidden=YES;
        _doneView.hidden=NO;
        //5秒后消失
        [UIView  animateWithDuration:5 animations:^{
            self.alpha=0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
    

}

@end
