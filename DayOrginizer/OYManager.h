//
//  OYManager.h
//  DayOrginizer
//
//  Created by Ярослав on 03.08.15.
//  Copyright (c) 2015 Orekhov Yar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OYTask.h"
#import "OYMainTableViewController.h"

#import "OYTopViewController.h"
@class OYTopViewController;
@interface OYManager : NSObject
+(instancetype)sharedManager;
@property UISegmentedControl* segmented;
@property OYMainTableViewController* table;
@property OYTopViewController* freshTop;
@property NSNumber* dateOrPriotity;
// Возвращает задачи отсортированне по дате создания
-(NSArray*)sortedTasks;
-(NSArray*)sortedTasksAtPriority;
// Создает новую задачу
-(OYTask*)createTaskWithTitle:(NSString*)title withPriority:(NSNumber*)priority;
-(void)load;
// Удаляет задачу
-(void)removeTaskWithDate:(NSDate*)date;

// Сохраняет задачи в файл
-(void)save;



@end
