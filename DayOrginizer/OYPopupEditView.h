//
//  OYPopupEditView.h
//  DayOrginizer
//
//  Created by Ярослав on 03.08.15.
//  Copyright (c) 2015 Orekhov Yar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OYPopupEditView : UIView <UITextFieldDelegate>

@property CGRect targetAnimationRect;
@property (nonatomic, copy) void (^completionBlock) (BOOL isOK, NSString* text);

+(void)showInViewController:(UIViewController*)vc
    withTargetAnimationRect:(CGRect)targetRect
         andCompletionBlock:(void(^)(BOOL isOK, NSString* text))completionBlock;

@property UISegmentedControl* segmented;

@end
