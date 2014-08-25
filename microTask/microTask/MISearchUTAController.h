//
//  MISearchUTAController.h
//  microTask
//
//  Created by blink_invoker on 8/24/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MITaskActivityTableViewController.h"
#import "MITableCollectionViewDelegate.h"

@interface MISearchUTAController : UIViewController<UISearchBarDelegate,MITableCollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *view;

@end
