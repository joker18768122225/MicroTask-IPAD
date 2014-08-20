//
//  MIFindCell.h
//  microTask
//
//  Created by blink_invoker on 8/9/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MITapGesture.h"
#import "MISwipeGesture.h"
@interface MIFindCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *can_need_activityLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
- (IBAction)forward:(UIButton *)sender;
- (IBAction)userInfo:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *cellContentView;

-(void)tapImage:(MITapGesture*)gesture;
-(void)closeImageDetail:(UIGestureRecognizer*)gesture;


-(void)swipeRight:(MISwipeGesture*)gesture;
-(void)swipeLeft:(MISwipeGesture*)gesture;
@end
