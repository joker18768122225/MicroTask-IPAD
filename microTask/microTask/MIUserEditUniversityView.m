//
//  MIUserEditUniversityView.m
//  microTask
//
//  Created by blink_invoker on 8/27/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import "MIUserEditUniversityView.h"

@implementation MIUserEditUniversityView
{
    NSArray *_provinces;
    NSDictionary *_universities;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setInfoWithDic:(NSDictionary*)dic provinces:(NSArray*)provinces
{
    _provinces=provinces;
    _universities=dic;
}

- (IBAction)close:(UIButton *)sender
{
}

- (IBAction)confirm:(UIButton *)sender
{
}

//返回title
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0)
    {
        
    }
    
    return nil;
}

//选中方法
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 0;
    
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}




@end
