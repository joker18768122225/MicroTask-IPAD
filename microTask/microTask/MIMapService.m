//
//  MIMapService.m
//  microTask
//
//  Created by blink_invoker on 9/14/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import "MIMapService.h"
static MIMapService *instance=nil;

@implementation MIMapService
{
    BMKLocationService *_locService;
    BMKUserLocation *_userLocation;
}

+(MIMapService*)getInstance
{
    if (instance)
    {
        return instance;
    }

    MIMapService* mService=[[MIMapService alloc] init];
    mService->_locService=[[BMKLocationService alloc] init];
    mService->_locService.delegate=instance;
    [mService->_locService startUserLocationService];
    return mService;
}

-(void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"%f",_userLocation.location.coordinate.longitude);
    _userLocation=userLocation;
    
}
-(BMKUserLocation*)getCurrentLocation
{
    return _userLocation;
}
@end
