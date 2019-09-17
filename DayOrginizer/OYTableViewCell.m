//
//  OYTableViewCell.m
//  DayOrginizer
//
//  Created by Ярослав on 03.08.15.
//  Copyright (c) 2015 Orekhov Yar. All rights reserved.
//

#import "OYTableViewCell.h"
#import "OYTask.h"
#import "OYManager.h"

@implementation OYTableViewCell{
    CGRect _frame;
    NSInteger _flag;
//    UITapGestureRecognizer* _tapRecognizer;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cherta.backgroundColor = [UIColor colorWithRed:0.5 green:0.4 blue:0.2 alpha:1];
    _flag = 0;
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                             action:@selector(oneTapAction:)];
    self.singleTap.numberOfTapsRequired = 1;
    // Добавляем распознаватель к контролерру
    [self addGestureRecognizer:self.singleTap];
    [self.singleTap requireGestureRecognizerToFail:[OYManager sharedManager].table.doubleTap];
    // Initialization code

}

-(void)oneTapAction:(id)sender {
    if (self.task.status == OYTaskStatusUncompleted) {
        self.checkView.backgroundColor = [UIColor blueColor];
        self.task.status = OYTaskStatusCompleted;
        [self performSelector:@selector(zacherknut) withObject:self.cherta afterDelay:0.5];
    }else{
        self.checkView.backgroundColor = [UIColor whiteColor];
        self.task.status = OYTaskStatusUncompleted;
        [self performSelector:@selector(rascherknut) withObject:self.cherta afterDelay:0.5];
    }
    [[OYManager sharedManager] save];
    [OYManager sharedManager].freshTop.priorityLabel.backgroundColor = [UIColor whiteColor];
    [OYManager sharedManager].freshTop.allLabe.backgroundColor = [UIColor whiteColor];
    [[OYManager sharedManager].freshTop calculatePercent];
    
    [UIView animateWithDuration:0.5 delay:0.5 options:0 animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self showTableView];
        [[OYManager sharedManager].table sortTaskForDate];
        [[OYManager sharedManager].table.tableView reloadData];
    }];


    
  }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    
//    UITouch* touch = [touches anyObject];
//    CGPoint pointE = [touch locationInView:self];
//
//
//        if ([self pointInside:pointE withEvent:event]) {
//            if (self.task.status == OYTaskStatusUncompleted) {
//                self.checkView.backgroundColor = [UIColor blueColor];
//                self.task.status = OYTaskStatusCompleted;
//            }else{
//                self.checkView.backgroundColor = [UIColor whiteColor];
//                self.task.status = OYTaskStatusUncompleted;
//            }
//            [[OYManager sharedManager] save];
//            [OYManager sharedManager].freshTop.priorityLabel.backgroundColor = [UIColor whiteColor];
//            [OYManager sharedManager].freshTop.allLabe.backgroundColor = [UIColor whiteColor];
//            [[OYManager sharedManager].freshTop calculatePercent];
//            [UIView animateWithDuration:0.5 delay:1.0 options:0 animations:^{
//                [self setAlpha:0];
//            } completion:^(BOOL finished) {
//                [self showTableView];
//                [[OYManager sharedManager].table sortTaskForDate];
//                [[OYManager sharedManager].table.tableView reloadData];
//            }];
//             
//            
//        }
//
//
//}
-(void)showTableView{
//    [OYManager sharedManager].table.tableView;
//    [UIView animateWithDuration:10.0 animations:^{
//        [[ setAlpha:1];
//    }];
}
-(void)zacherknut{
    CGRect frame = self.cherta.frame;
    frame.size.width = 1000;
    [UIView animateWithDuration:0.5 animations:^{
        [self.cherta setFrame:frame];
    }];
}
-(void)rascherknut{
    CGRect frame = self.cherta.frame;
    frame.size.width = 0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.cherta setFrame:frame];
    }];
}
-(void)uzhezacherknuto{
    CGRect frame = self.cherta.frame;
    frame.size.width = 1000;
    [self.cherta setFrame:frame];
}
-(void)buildGraph{
    if (_flag == 0) {
        _flag = 1;
        _frame = self.priority.frame;
        CGRect frame = _frame;
        frame.size.height = frame.size.height*((self.task.priority.integerValue+1)*0.33);
         frame.origin.y = (frame.origin.y+_frame.size.height-frame.size.height);
        NSLog(@"height = %f", frame.size.height);
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.priority setFrame:frame];
        }];
    }else{

        CGRect frame = _frame;
        frame.size.height = frame.size.height*((self.task.priority.integerValue+1)*0.33);
         frame.origin.y = (frame.origin.y+_frame.size.height-frame.size.height);
        NSLog(@"height = %f", frame.size.height);
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.priority setFrame:frame];
        }];
    }

    
}
@end
