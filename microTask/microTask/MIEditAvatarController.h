//
//  MIEditAvatarController.h
//  microTask
//
//  Created by blink_invoker on 9/14/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIUserEditInfoController.h"
@interface MIEditAvatarController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil preController:(MIUserEditInfoController*)edController;
@end
