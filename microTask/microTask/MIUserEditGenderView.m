//
//  MIUserEditGenderView.m
//  microTask
//
//  Created by blink_invoker on 8/26/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import "MIUserEditGenderView.h"
#import "UIView+cat.h"
static NSArray *genders=@[@"男",@"女"];

@implementation MIUserEditGenderView

{
    
    __weak IBOutlet UIPickerView *_pickerView;
    
    
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (IBAction)close:(UIButton *)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        self.y=768;
    } completion:^(BOOL finished) {
        for (UIButton *button in _buttons) {
            button.userInteractionEnabled=YES;
        }
        [self removeFromSuperview];
    }];
    
}

- (IBAction)confirm:(UIButton *)sender
{
    self.genderLabel.text=_gender;
    [self close:sender];
    
}

//返回列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//返回列表项目数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}
//返回第row行项目的标题
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [genders objectAtIndex:row];
    
}

//选中指定列和列表项时触发
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _gender=[genders objectAtIndex:row];
}


@end
