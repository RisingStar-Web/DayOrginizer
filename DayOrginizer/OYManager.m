//
//  OYManager.m
//  DayOrginizer
//
//  Created by Ярослав on 03.08.15.
//  Copyright (c) 2015 Orekhov Yar. All rights reserved.
//

#import "OYManager.h"

@implementation OYManager{
    NSMutableArray* _tasksArray;
}

+(instancetype)sharedManager {
    static OYManager* __sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedManager = [OYManager new];
    });
    
    return __sharedManager;
}

// Возвращает задачи отсортированне по дате создания
-(NSArray*)sortedTasks {
    if (!_tasksArray) {
        [self load];
    }
    
    // Создаем описатель сортировки
    NSSortDescriptor* sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"dateCreated"
                                                               ascending:NO];
    return [_tasksArray sortedArrayUsingDescriptors:@[sortDesc]];
}

-(NSArray*)sortedTasksAtPriority{
    if (!_tasksArray) {
        [self load];
    }
    
    // Создаем описатель сортировки
    NSSortDescriptor* sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"priority"
                                                               ascending:NO];
    return [_tasksArray sortedArrayUsingDescriptors:@[sortDesc]];
}

// Создает новую задачу
-(OYTask*)createTaskWithTitle:(NSString*)title withPriority:(NSNumber*)priority {
    OYTask* task = [OYTask new];
    
    if (!_tasksArray) {
        _tasksArray = [NSMutableArray new];
    }
    
    task.title = title;
    task.dateCreated = [NSDate new];
    task.status = OYTaskStatusUncompleted;
    task.priority = priority;
    
    
    [_tasksArray addObject:task];
    
    [self save];
    
    return task;
}

// Удаляет задачу по индексу
-(void)removeTaskWithDate:(NSDate *)date {

    for (OYTask* task in [self sortedTasks]) {
        if (task.dateCreated == date) {
            [_tasksArray removeObject:task];
            break;
        }
    }

    
    [self save];
}

// Загружает задачи из файла
-(void)load {
    // Путь к файлу в песочнице приложения
    NSString* pathToFile = [@"~/Library/data.plist" stringByExpandingTildeInPath];
    
    // Загружает массив из NSDictionary
    NSMutableDictionary* loadingDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:pathToFile];
    self.dateOrPriotity = loadingDictionary[@"dateOrPriority"];
    NSLog(@"zhopa %@", self.dateOrPriotity);
    _tasksArray = [NSMutableArray new];
    
    for (NSDictionary* taskDict in loadingDictionary[@"taskArray"]) {
        OYTask* task = [OYTask new];
        task.title = taskDict[@"title"];
        task.priority = taskDict[@"priority"];
        task.status = [taskDict[@"status"] unsignedIntegerValue];
        task.dateCreated = taskDict[@"dateCreated"];
        
        [_tasksArray addObject:task];
    }
}

// Сохраняет задачи в файл
-(void)save {
    // Путь к файлу в песочнице приложения
    NSString* pathToFile = [@"~/Library/data.plist" stringByExpandingTildeInPath];
    NSMutableDictionary* savingDict = [NSMutableDictionary new];
    if (!self.dateOrPriotity) {
        self.dateOrPriotity = @(0);
    }
    [savingDict setObject:self.dateOrPriotity forKey:@"dateOrPriority"];
    NSMutableArray* taskArray = [NSMutableArray new];
    
    for (OYTask* task in _tasksArray) {
        NSDictionary* taskDict =
        @{ @"title" : task.title != nil ? task.title : @"",
           @"priority" :task.priority,
           @"status" : @(task.status),
           @"dateCreated" : task.dateCreated };
        
        [taskArray addObject:taskDict];
    }
    [savingDict setObject:taskArray forKey:@"taskArray"];
    [savingDict writeToFile:pathToFile atomically:YES];
}


@end
