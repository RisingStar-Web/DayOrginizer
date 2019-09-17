//
//  OYTopViewController.m
//  DayOrginizer
//
//  Created by Ярослав on 03.08.15.
//  Copyright (c) 2015 Orekhov Yar. All rights reserved.
//

#import "OYTopViewController.h"

#import "OYManager.h"

@interface OYTopViewController ()

@end

@implementation OYTopViewController{
    NSDate* _date;
    NSInteger _allPercent;
    NSInteger _priorityPercent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topSegment.tintColor = [UIColor colorWithRed:0.5 green:0.4 blue:0.2 alpha:1];
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.95 blue:0.92 alpha:1];
    
    [OYManager sharedManager].freshTop = self;
    _date = [NSDate new];
    [self buttonNaming];
    [self.nextButton setHidden:YES];
    self.allLabe.backgroundColor = [UIColor whiteColor];
    self.priorityLabel.backgroundColor = [UIColor whiteColor];
    
  //  [self performSelector:@selector(calculatePercent) withObject:self afterDelay:0.5];
    // Do any additional setup after loading the view.
}
-(void)buttonNaming{
    
    NSDate *tomorrow = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:_date];
    NSLog(@"datenow = %@", _date);
    NSDate *yesterday = [NSDate dateWithTimeInterval:(-24*60*60) sinceDate:_date];
    NSDateFormatter* fmt = [NSDateFormatter new];
    [fmt setDateFormat:@"dd.MM"];
    NSString* tomorrowString = [NSString stringWithFormat:@"%@",[fmt stringFromDate:tomorrow]];
    NSString* yesterdayString = [NSString stringWithFormat:@"%@",[fmt stringFromDate:yesterday]];
    self.nextButton.tintColor = [UIColor colorWithRed:0.5 green:0.4 blue:0.2 alpha:1];
    self.prevButton.tintColor = [UIColor colorWithRed:0.5 green:0.4 blue:0.2 alpha:1];
    [self.nextButton setTitle:tomorrowString forState:UIControlStateNormal];
    [self.prevButton setTitle:yesterdayString forState:UIControlStateNormal];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)topSegmentSelected:(id)sender {
    [[OYManager sharedManager].table sortTaskForDate];
    [[OYManager sharedManager].table.tableView reloadData];
    [OYManager sharedManager].dateOrPriotity = @(self.topSegment.selectedSegmentIndex);
    [[OYManager sharedManager] save];
}
- (IBAction)nextAction:(id)sender {
    _date = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:_date];
    NSDate* now = [NSDate new];
    NSDateFormatter* fmt = [NSDateFormatter new];
    [fmt setDateFormat:@"dd-MM-yyyy"];
    if ([[fmt stringFromDate:now] isEqualToString:[fmt stringFromDate:_date]]) {
        [self.nextButton setHidden:YES];
    }
    [OYManager sharedManager].table.choosedDate = _date;
    [self buttonNaming];
    [[OYManager sharedManager].table sortTaskForDate];
    [[OYManager sharedManager].table.tableView reloadData];
    [self performSelector:@selector(calculatePercent) withObject:self afterDelay:0.2];
}



- (IBAction)prevAction:(id)sender {
    _date = [NSDate dateWithTimeInterval:(-24*60*60) sinceDate:_date];
    [self.nextButton setHidden:NO];
    [self buttonNaming];
    [OYManager sharedManager].table.choosedDate = _date;
    [[OYManager sharedManager].table sortTaskForDate];
    [[OYManager sharedManager].table.tableView reloadData];
    [self performSelector:@selector(calculatePercent) withObject:self afterDelay:0.2];
}

-(void)calculatePercent{
    if ([OYManager sharedManager].table.taskToDate.count>0) {
        NSInteger complited = 0;
        NSLog(@"complited = %ld", (long)complited);
        NSLog(@"ccount = %lu", (unsigned long)[OYManager sharedManager].table.taskToDate.count);
        for (OYTask* task in [OYManager sharedManager].table.taskToDate) {
            if (task.status == OYTaskStatusCompleted) {
                complited = complited+1;
                NSLog(@"complited = %ld", (long)complited);
            }
        }
        
        NSInteger allPercent = complited*100/[OYManager sharedManager].table.taskToDate.count;
        self.allPerent.text = [NSString stringWithFormat:@"%ld %%", (long)allPercent];
        _allPercent = allPercent;
        
    }else{
        self.allPerent.text = [NSString stringWithFormat:@"100%%"];
        _allPercent = 100;
    }
    NSLog(@"percent = %@", self.allPerent.text);
    ///////////////////////////////
    
    if ([OYManager sharedManager].table.taskToDate.count>0) {
        NSInteger complited = 0;
        NSInteger all = 0;
        NSLog(@"complited = %ld", (long)complited);
        NSLog(@"ccount = %lu", (unsigned long)[OYManager sharedManager].table.taskToDate.count);
        for (OYTask* task in [OYManager sharedManager].table.taskToDate) {
            all = all + task.priority.integerValue+1;
            if (task.status == OYTaskStatusCompleted) {
                complited = complited+task.priority.integerValue+1;
                NSLog(@"complited = %ld", (long)complited);
            }
        }
        
        NSInteger priorityPercent = complited*100/all;
        
        self.priotityPercent.text = [NSString stringWithFormat:@"%ld %%", (long)priorityPercent];
        _priorityPercent = priorityPercent;
    }else{
        self.priotityPercent.text = [NSString stringWithFormat:@"100%%"];
        _priorityPercent = 100;
    }
    NSLog(@"percent = %@", self.priotityPercent.text);
    
    [self performSelector:@selector(buildGraph) withObject:self afterDelay:0.0];
}

-(void)buildGraph{
    self.allLabe.backgroundColor = [UIColor whiteColor];
    self.priorityLabel.backgroundColor = [UIColor whiteColor];
        NSLog(@"width = %f", self.allLabe.frame.size.width);
    CGRect frame10 = [self.allLabe frame];
    CGRect frame = [self.allLabe frame];
    frame10.size.width = 0;
    [self.allLabe setFrame:frame10];
    
    frame.size.width = frame.size.width*_allPercent/100;
    [UIView animateWithDuration:1.0 animations:^{
        [self.allLabe setFrame:frame];
        self.allLabe.backgroundColor = [UIColor colorWithRed:0.2 green:0.4 blue:0.5 alpha:1];


    }];
    NSLog(@"width = %f", self.allLabe.frame.size.width);
    CGRect frame20 = [self.priorityLabel frame];
    CGRect frame1 = [self.priorityLabel frame];
    frame20.size.width = 0;
    [self.priorityLabel setFrame:frame20];
    frame1.size.width = frame1.size.width*_priorityPercent/100;
    [UIView animateWithDuration:1.0 animations:^{
        [self.priorityLabel setFrame:frame1];
        self.priorityLabel.backgroundColor = [UIColor colorWithRed:0.5 green:0.4 blue:0.2 alpha:1];
       
        
    }];

}

@end
