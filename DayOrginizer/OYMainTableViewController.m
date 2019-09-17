//
//  OYMainTableViewController.m
//  DayOrginizer
//
//  Created by Ярослав on 03.08.15.
//  Copyright (c) 2015 Orekhov Yar. All rights reserved.
//


#import "OYMainTableViewController.h"
#import "OYManager.h"
#import "OYPopupEditView.h"
#import "OYTableViewCell.h"

@interface OYMainTableViewController ()

@end

@implementation OYMainTableViewController{
 //   UITapGestureRecognizer* _tapRecognizer;
    
    UILabel* _hintLabel;
    
    BOOL _isPopupViewActive;
    NSString* _date;
    NSMutableArray* _completed;
    NSMutableArray* _uncompleted;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.5 green:0.4 blue:0.2 alpha:1];
    [[OYManager sharedManager] load];
    self.choosedDate = [NSDate new];
    [OYManager sharedManager].freshTop.topSegment.selectedSegmentIndex = [OYManager sharedManager].dateOrPriotity.integerValue;
    [OYManager sharedManager].table = self;
    // Распознаватель жестов
    self.doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                             action:@selector(doubleTapAction:)];
    self.doubleTap.numberOfTapsRequired = 2;
    // Добавляем распознаватель к контролерру
    [self.view addGestureRecognizer:self.doubleTap];
    
    // Обновляем отображение текстовой метки
    [self updateHintLabel];


    [self sortTaskForDate];
    [[OYManager sharedManager].freshTop calculatePercent];

}



-(void)sortTaskForDate{
    
    NSDateFormatter* fmt = [NSDateFormatter new];
    [fmt setDateFormat:@"dd-MM-yyyy"];
    _date = [fmt stringFromDate:self.choosedDate];
    NSMutableArray* tasks = [NSMutableArray new];
    for (OYTask* task in [[OYManager sharedManager] sortedTasks]) {
        if ([[fmt stringFromDate:task.dateCreated] isEqualToString:_date]) {
            [tasks addObject:task];
        }
    }
    
    
    self.taskToDate = [NSArray arrayWithArray:tasks];
    if ([OYManager sharedManager].freshTop.topSegment.selectedSegmentIndex == 0) {
        NSSortDescriptor* sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"dateCreated"
                                                                   ascending:NO];
        self.taskToDate = [self.taskToDate sortedArrayUsingDescriptors:@[sortDesc]];
        for (OYTask* task in self.taskToDate) {
            NSLog(@"date = %@", task.dateCreated);
        }
    }else{
        NSSortDescriptor* sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"priority"
                                                                   ascending:NO];
        self.taskToDate = [self.taskToDate sortedArrayUsingDescriptors:@[sortDesc]];
        for (OYTask* task in self.taskToDate) {
            NSLog(@"priority = %@", task.priority);
        }
    }
    
    _completed = [NSMutableArray new];
    _uncompleted = [NSMutableArray new];
    
    for (OYTask* task in self.taskToDate) {
        if (task.status == OYTaskStatusCompleted) {
            [_completed addObject:task];
        }else{
            [_uncompleted addObject:task];
        }
    }
    
   
}
-(void)updateHintLabel {
    if ([[OYManager sharedManager] sortedTasks].count < 1) {
        [self showHintLabel];
    } else {
        [self removeHintLabel];
    }
}

// Добавляет текстувую метку с пояснением
-(void)showHintLabel {
    _hintLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    _hintLabel.font = [UIFont boldSystemFontOfSize:36];
    _hintLabel.textColor = [UIColor whiteColor];
    _hintLabel.numberOfLines = 0;
    _hintLabel.alpha = 0.7;
    _hintLabel.textAlignment = NSTextAlignmentCenter;
    
    // Используем локализованние сообщение
    _hintLabel.text = NSLocalizedString(@"Коснитесь дважды для добавления задачи", nil);
    
    //[UIColor colorWithCGColor:self.view.layer.backgroundColor];
    
    [self.view addSubview:_hintLabel];
}
// Удаляет текстовую метку с пояснением
-(void)removeHintLabel {
    [UIView animateWithDuration:0.3 animations:^{
        self->_hintLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [self->_hintLabel removeFromSuperview];
    }];
}
-(void)doubleTapAction:(id)sender {
    NSLog(@"zhopapopa");
    if (_isPopupViewActive) {
        return;
    }
    NSDateFormatter* fmt = [NSDateFormatter new];
    [fmt setDateFormat:@"dd-MM-yyyy"];
    if (![[fmt stringFromDate:[NSDate new]] isEqualToString:[fmt stringFromDate:self.choosedDate]]) {
        return;
    }
    
    // Формируем фрейм для анимации окна
    CGRect rect;
    rect = CGRectMake(0, 0, self.view.frame.size.width, self.tableView.rowHeight);
    
    _isPopupViewActive = YES;
    [OYPopupEditView showInViewController:self withTargetAnimationRect:rect andCompletionBlock:^(BOOL isOK, NSString *text) {
        self->_isPopupViewActive = NO;
        
        if (isOK) {
            // Добавляем задачу в модель
            [[OYManager sharedManager] createTaskWithTitle:text withPriority:@([OYManager sharedManager].segmented.selectedSegmentIndex)];
            
            
            [self updateHintLabel];
            [self sortTaskForDate];
            // Обновляем первую строку в Table View
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [[OYManager sharedManager].freshTop performSelector:@selector(calculatePercent) withObject:[OYManager sharedManager].freshTop afterDelay:0.5];
                [[OYManager sharedManager].freshTop performSelector:@selector(buildGraph) withObject:[OYManager sharedManager].freshTop afterDelay:0.5];
            });
        }
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.taskToDate.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                       forIndexPath:indexPath];
    if (indexPath.row < _uncompleted.count) {
        
        OYTask* task = _uncompleted[indexPath.row];
        float index = indexPath.row;
        // Переносим данные из задачи в ячейку
        //    cell.checkView.task = task;
        //    [cell.checkView updateForTask];
        cell.task = task;
        cell.title.text = task.title;
     //   [cell performSelector:@selector(buildGraph) withObject:self afterDelay:0.1];
        
//        CGRect frame = cell.priority.frame;
//        frame.size.height = frame.size.height*((task.priority.integerValue+1)*0.33);
//        NSLog(@"height = %f", frame.size.height);
//        cell.priority.backgroundColor = [UIColor grayColor];
//        [UIView animateWithDuration:0.5 delay:2 options:0.5 animations:^{
//            [cell.priority setFrame:frame];
//        } completion:^(BOOL finished) {
//            nil;
//        }];
//
        cell.backgroundColor = [UIColor colorWithRed:0.8 green:0.7 blue:0 alpha:1];
        if (task.priority.integerValue == 0) {
            cell.ptiority1.backgroundColor = [UIColor colorWithRed:0.5 green:0.4 blue:0.2 alpha:1];
            cell.priority2.backgroundColor = cell.backgroundColor;
            cell.priority3.backgroundColor = cell.backgroundColor;
        }else if (task.priority.integerValue == 1){
            cell.ptiority1.backgroundColor = [UIColor colorWithRed:0.5 green:0.4 blue:0.2 alpha:1];
            cell.priority2.backgroundColor = [UIColor colorWithRed:0.5 green:0.4 blue:0.2 alpha:1];
            cell.priority3.backgroundColor = cell.backgroundColor;
        }else{
            cell.ptiority1.backgroundColor = [UIColor colorWithRed:0.5 green:0.4 blue:0.2 alpha:1];
            cell.priority2.backgroundColor = [UIColor colorWithRed:0.5 green:0.4 blue:0.2 alpha:1];
            cell.priority3.backgroundColor =[UIColor colorWithRed:0.5 green:0.4 blue:0.2 alpha:1];
        }

        //   cell.priority.backgroundColor = [UIColor blackColor];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
  

        
        NSLog(@"row = %f", index/10);
        return cell;
    }else{
        OYTask* task = _completed[indexPath.row-_uncompleted.count];
 //       float index = indexPath.row;
        // Переносим данные из задачи в ячейку
        //    cell.checkView.task = task;
        //    [cell.checkView updateForTask];
        cell.task = task;
        cell.title.text = task.title;


        //   cell.priority.backgroundColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor colorWithRed:0.71 green:0.86 blue:0.66 alpha:1];
        CGRect frame = cell.cherta.frame;
        frame.size.width = frame.size.width*1000;
        [cell performSelector:@selector(uzhezacherknuto) withObject:cell.cherta afterDelay:0];
        
        if (task.priority.integerValue == 0) {
            cell.ptiority1.backgroundColor = [UIColor colorWithRed:0.92 green:0.94 blue:0.68 alpha:1];
            cell.priority2.backgroundColor = cell.backgroundColor;
            cell.priority3.backgroundColor = cell.backgroundColor;
        }else if (task.priority.integerValue == 1){
            cell.ptiority1.backgroundColor = [UIColor colorWithRed:0.92 green:0.94 blue:0.68 alpha:1];
            cell.priority2.backgroundColor = [UIColor colorWithRed:0.92 green:0.94 blue:0.68 alpha:1];
            cell.priority3.backgroundColor = cell.backgroundColor;
        }else{
            cell.ptiority1.backgroundColor = [UIColor colorWithRed:0.92 green:0.94 blue:0.68 alpha:1];
            cell.priority2.backgroundColor = [UIColor colorWithRed:0.92 green:0.94 blue:0.68 alpha:1];
            cell.priority3.backgroundColor =[UIColor colorWithRed:0.92 green:0.94 blue:0.68 alpha:1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDate* date = [NSDate new];
        if (indexPath.row < _uncompleted.count) {
            OYTask* task = _uncompleted[indexPath.row];
            date = task.dateCreated;
        }else{
            OYTask* task = _completed[indexPath.row-_uncompleted.count];
            date = task.dateCreated;
        }
        [[OYManager sharedManager] removeTaskWithDate:date];
        // Delete the row from the data source
        [self sortTaskForDate];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
     //   [self sortTaskForDate];
        [self updateHintLabel];
        [[OYManager sharedManager].freshTop performSelector:@selector(calculatePercent) withObject:[OYManager sharedManager].freshTop afterDelay:0.5];
        [[OYManager sharedManager].freshTop performSelector:@selector(buildGraph) withObject:[OYManager sharedManager].freshTop afterDelay:0.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }

}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
