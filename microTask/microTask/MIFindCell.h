//
//  MIFindCell.h
//  microTask
//
//  Created by blink_invoker on 8/9/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MITapGesture.h"
@interface MIFindCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *can_need_activityLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
- (IBAction)forward:(UIButton *)sender;
- (IBAction)userInfo:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *cellContentView;


@end
