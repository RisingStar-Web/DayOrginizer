//
//  OYMainTableViewController.h
//  DayOrginizer
//
//  Created by Ярослав on 03.08.15.
//  Copyright (c) 2015 Orekhov Yar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OYPopupEditView.h"


@interface OYMainTableViewController : UITableViewController
@property OYPopupEditView* popup;
@property NSArray* taskToDate;
@property NSDate* choosedDate;
@property UITapGestureRecognizer* doubleTap;

-(void)sortTaskForDate;
@end
