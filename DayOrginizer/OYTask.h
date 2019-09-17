//
//  OYTask.h
//  DayOrginizer
//
//  Created by Ярослав on 03.08.15.
//  Copyright (c) 2015 Orekhov Yar. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum : NSUInteger {
    OYTaskStatusCompleted = 100,
    OYTaskStatusUncompleted = 110
} OYTaskStatus;

@interface OYTask : NSObject

@property NSDate* dateCreated;
@property NSString* title;
@property OYTaskStatus status;
@property NSNumber* priority;


@end
