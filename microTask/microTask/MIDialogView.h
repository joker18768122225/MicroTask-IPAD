//
//  MIDialogView.h
//  microTask
//
//  Created by blink_invoker on 9/14/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import <UIKit/UIKit.h>

enum MIDialogViewType
{
    DOING,
    DONE
};

@interface MIDialogView : UIView
@property NSString* message;

+(MIDialogView*)initForMessage:(NSString*)message parentView:(UIView*)view;


-(void)setStatusAndMessage:(MIDialogViewType)type message:(NSString*)message;
@end
