//
//  OYPopupEditView.m
//  DayOrginizer
//
//  Created by Ярослав on 03.08.15.
//  Copyright (c) 2015 Orekhov Yar. All rights reserved.
//

#import "OYPopupEditView.h"
#import "OYManager.h"
#import "OYMainTableViewController.h"

@implementation OYPopupEditView

{
    UITextField* _textField;
    UILabel* _label;

    UIButton* _closeButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self initControls];
    
    return self;
}

// Инициализирует встроенные элементы управления
-(void)initControls {
    
    self.backgroundColor = [UIColor clearColor];
    
    // Настраиваем внешний вид корневого UIView
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    // Скругление углов
    self.layer.cornerRadius = 5;
    
    // Добавляем тень
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.7;
    self.layer.shadowRadius = 10;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    
    if (!_textField) {
        CGRect rect = self.bounds;
        rect = CGRectInset(rect, 10, 10);
        rect.origin.y = 10;
        rect.size.height = rect.size.height - 20;
        
        _textField = [[UITextField alloc] initWithFrame:rect];
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
        
        // Добавляем текстовое поле в иерархию
        [self addSubview:_textField];
    }
    
    if (!self.segmented) {
        
        NSArray* segments = [NSArray arrayWithObjects:@"Неважно",@"Средне",@"Важно", nil];
        CGRect rect = self.bounds;
        rect = CGRectInset(rect, 10, 10);
        rect.origin.y = 100;
        rect.size.height = rect.size.height - 20;
       
        self.segmented = [[UISegmentedControl alloc] initWithFrame:rect];
        self.segmented =  [self.segmented initWithItems:segments];
        self.segmented.tintColor = [UIColor colorWithRed:0.5 green:0.4 blue:0.2 alpha:1];
        self.segmented.selectedSegmentIndex = 1;
        [OYManager sharedManager].segmented = self.segmented;
        
     
        
        // Добавляем текстовое поле в иерархию
        [self addSubview:_segmented];
    }
    if (!_label) {
        
        CGRect rect = self.bounds;
        rect = CGRectInset(rect, 10, 10);
        rect.origin.y = 75;
        rect.size.height = rect.size.height - 100;
        
        _label = [[UILabel alloc] initWithFrame:rect];

        _label.text = @"Важность";
        _label.textColor = _segmented.tintColor;
        
        
       
        
        // Добавляем текстовое поле в иерархию
        [self addSubview:_label];
    }
    
    if (!_closeButton) {
        CGRect frame = CGRectMake(0, 0, 100, 30);
        _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _closeButton.frame = frame;
        [_closeButton setTitle:NSLocalizedString(@"Закрыть", nil)
                      forState:UIControlStateNormal];
        _closeButton.tintColor = [UIColor colorWithRed:0.5 green:0.4 blue:0.2 alpha:1];
        // Добавляем Action для кнопки, чтобы обработать
        // событие, когда пользователь на нее нажмет и отпустит
        [_closeButton addTarget:self
                         action:@selector(closeButtonAction:)
               forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_closeButton];
    }
}

// Вызывается когда пользователь нажа Done
// на экранной клавиатуре
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.completionBlock) {
        self.completionBlock(YES, textField.text);
    }
    
    CABasicAnimation* shadowAnimation = [CABasicAnimation animation];
    shadowAnimation.fromValue = @(self.layer.shadowOpacity);
    shadowAnimation.toValue = @0;
    shadowAnimation.duration = 0.3;
    [self.layer addAnimation:shadowAnimation forKey:@"shadowOpacity"];
    
    CABasicAnimation* cornerAnimation = [CABasicAnimation animation];
    cornerAnimation.fromValue = @(self.layer.cornerRadius);
    cornerAnimation.toValue = @0;
    cornerAnimation.duration = 0.3;
    [self.layer addAnimation:cornerAnimation forKey:@"cornerRadius"];
    
    
    [UIView animateWithDuration:0.1 animations:^{
        self->_textField.alpha = 0.0;
        self->_closeButton.alpha = 0.0;
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    }];
    
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:0 animations:^{
        self.frame = self.targetAnimationRect;
    } completion:^(BOOL finished) {
        // Удаляет View из иерархии
        [self removeFromSuperview];
    }];
    
    return YES;
}

-(IBAction)closeButtonAction:(UIButton*)sender {
    if (self.completionBlock) {
        self.completionBlock(NO, nil);
    }
    
    // Анимируем исчесзновение с экрана View
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        // Удаляет View из иерархии
        [self removeFromSuperview];
    }];
}

-(UITextField*)textField {
    return _textField;
}

+(void)showInViewController:(UIViewController*)vc
    withTargetAnimationRect:(CGRect)targetRect
         andCompletionBlock:(void(^)(BOOL isOK, NSString* text))completionBlock {
    
    
    // Получаем фрейм VC на котором будет отображаться
    // наш элемент управления
    
    CGRect frame = vc.view.bounds;
    frame = CGRectInset(frame, 40, 20);
    frame.origin.y = 80;
    frame.size.height = 140;

    OYPopupEditView* editView = [[OYPopupEditView alloc] initWithFrame:frame];
    editView.backgroundColor = [UIColor colorWithRed:0.96 green:0.95 blue:0.92 alpha:1];
    // Копируем блок
    editView.completionBlock = completionBlock;
    
    // Сохраняем фрейм на который view "улетит"
    // после того, как закроется
    editView.targetAnimationRect = targetRect;
    
    // Добавляем наш View на экран
    [vc.view addSubview:editView];
    
    // Делаем Vies прозрачным
    editView.alpha = 0;
    
    // Уменьшаем View при помощи трансформации
    editView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    
    // Анимируем прозрачность
    [UIView animateWithDuration:0.1 animations:^{
        editView.alpha = 1;
    }];
    
    // Анимируем трансформацию View
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:0 animations:^{
        editView.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    // Активируем текстовое поле
    [[editView textField] becomeFirstResponder];
}


@end
