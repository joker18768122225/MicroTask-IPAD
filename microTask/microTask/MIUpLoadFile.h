//
//  MIUpLoadFile.h
//  microTask
//
//  Created by blink_invoker on 8/11/14.
//  Copyright (c) 2014 org.microTask. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIUpLoadFile : NSObject
@property(nonatomic) NSData *fileData;
@property(nonatomic) NSString *fileName;
@property(nonatomic) NSString *mimeType;
@property(nonatomic) NSString *key;

@end
