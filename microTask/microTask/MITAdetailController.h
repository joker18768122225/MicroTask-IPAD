//
//  MITAdetailController.h
//  microTask
//
//  Created by blink_invoker on 8/22/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIFindCellInfo.h"
#import "BMapKit.h"
@interface MITAdetailController : UIViewController<BMKMapViewDelegate,BMKGeoCodeSearchDelegate>

@property (strong, nonatomic) IBOutlet UIView *view;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil taInfo:(MIFindCellInfo*)info;
@end
