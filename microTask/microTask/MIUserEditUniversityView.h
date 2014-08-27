//
//  MIUserEditUniversityView.h
//  microTask
//
//  Created by blink_invoker on 8/27/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIUserEditUniversityView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

-(void)setInfoWithDic:(NSDictionary*)dic provinces:(NSArray*)provinces;
@end
