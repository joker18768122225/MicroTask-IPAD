//
//  MIChooseDepartmentController.h
//  microTask
//
//  Created by blink_invoker on 9/13/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIChooseDepartmentController : UIViewController<UITableViewDataSource,UITableViewDelegate>

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil univid:(int)univid;
@end
