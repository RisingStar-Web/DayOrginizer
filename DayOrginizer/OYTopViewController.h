//
//  OYTopViewController.h
//  DayOrginizer
//
//  Created by Ярослав on 03.08.15.
//  Copyright (c) 2015 Orekhov Yar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OYManager.h"

@interface OYTopViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *allLabe;
@property (weak, nonatomic) IBOutlet UIView *priorityLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *topSegment;

- (IBAction)topSegmentSelected:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *prevButton;
- (IBAction)nextAction:(id)sender;
- (IBAction)prevAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *allPerent;
@property (weak, nonatomic) IBOutlet UILabel *priotityPercent;
-(void)calculatePercent;
-(void)buildGraph;
@end
