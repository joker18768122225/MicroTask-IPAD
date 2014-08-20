//
//  MIFindController.h
//  microTask
//
//  Created by blink_invoker on 8/8/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIFindController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topBarView;

- (IBAction)changeCan_Need_Activity:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *can_need_activityLabel;

@property (weak, nonatomic) IBOutlet UIButton *allTypeButton;

@end
