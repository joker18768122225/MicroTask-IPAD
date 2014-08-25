//
//  MIFindCellInfo.h
//  microTask
//
//  Created by blink_invoker on 8/9/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIFindCellInfo : NSObject

@property(nonatomic) NSString *taid;
@property(nonatomic) NSString *avatar;
@property(nonatomic) NSString *nickName;
@property(nonatomic) NSString *title;
@property(nonatomic) NSString *type;
@property(nonatomic) NSString *can_need_activity;

@property(nonatomic) NSString *publishDate;
@property(nonatomic) NSString *expireDate;

@property(nonatomic) NSString *content;
@property(nonatomic) NSString *reward;
@property(nonatomic) NSString *my_relation;
@property(nonatomic) NSString *friend_relation;
@property(nonatomic,assign) int commentCount;
@property(nonatomic,assign) int forwardCount;
@property(nonatomic,assign) int likeCount;
@property(nonatomic) NSArray *photos;
@property(nonatomic,assign) int photoCnt;
@property(nonatomic,assign) int photoRow;
@property(nonatomic,assign) int applycnt;
@property(nonatomic,assign) CGFloat distance;
@property(nonatomic,assign) CGFloat height;

@property(nonatomic) CGSize contentSize;
@end
