//
//  MIMapService.h
//  microTask
//
//  Created by blink_invoker on 9/14/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"
@interface MIMapService : NSObject<BMKLocationServiceDelegate>


+(MIMapService*)getInstance;
///获取当前位置
-(BMKUserLocation*)getCurrentLocation;
@end
