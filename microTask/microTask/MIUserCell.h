//
//  MIUserCell.h
//  microTask
//
//  Created by blink_invoker on 8/24/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIUserCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *universityLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerCntLabel;
@property (weak, nonatomic) IBOutlet UILabel *creditLabel;

@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;

@end
