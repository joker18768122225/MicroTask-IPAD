//
//  MIUserEditGenderView.h
//  microTask
//
//  Created by blink_invoker on 8/26/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIUserEditGenderView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic) UILabel *genderLabel;
@property (nonatomic) NSString *gender;
@property (nonatomic) NSArray *buttons;
@end
