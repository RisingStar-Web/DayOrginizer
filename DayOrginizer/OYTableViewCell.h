//
//  OYTableViewCell.h
//  DayOrginizer
//
//  Created by Ярослав on 03.08.15.
//  Copyright (c) 2015 Orekhov Yar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OYTask.h"

@interface OYTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *checkView;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *priority;
@property (weak, nonatomic) IBOutlet UIView *ptiority1;
@property (weak, nonatomic) IBOutlet UIView *priority2;

@property (weak, nonatomic) IBOutlet UIView *priority3;
@property (weak, nonatomic) IBOutlet UIView *cherta;
@property UITapGestureRecognizer* singleTap;
@property OYTask* task;
-(void)zacherknut;
-(void)uzhezacherknuto;
@end
