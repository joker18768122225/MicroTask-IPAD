//
//  MIImageScrollController.h
//  microTask
//
//  Created by blink_invoker on 8/21/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIImageScrollController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *view;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withPhotos:(NSArray*)photos withInitIndex:(int)index withPoints:(NSArray*)points;

@end
