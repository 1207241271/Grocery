//
//  UnitViewController.m
//  
//
//  Created by yangxu on 15/10/22.
//
//

#import "UnitViewController.h"
#import "Unit.h"
#import "AppDelegate.h"
@interface UnitViewController ()

@end

@implementation UnitViewController
#define debug 1

#pragma mark - VIEW
-(void)refreshInterface{
    if (debug==1) {
        NSLog(@"%@ is running :%@",self.class,NSStringFromSelector(_cmd));
    }
    
    CoreDataHelper *cdh=[(AppDelegate*)[[UIApplication sharedApplication] delegate] cdh];
    Unit *unit=(Unit*)[cdh.context existingObjectWithID:self.selectedObjectID error:nil];
    self.nameTextField.text=unit.name;
}
-(void)viewDidLoad{
    if (debug==1) {
        NSLog(@"%@ is running :%@",self.class,NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    [self hideKeyboardWhenBackgroundIsTapped];
    self.nameTextField.delegate=self;
}

-(void)viewWillAppear:(BOOL)animated{
    if (debug==1) {
        NSLog(@"%@ is running :%@",self.class,NSStringFromSelector(_cmd));
    }
    [self refreshInterface];
    [self.nameTextField becomeFirstResponder];
}

#pragma mark - TEXTFIELD
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (debug==1) {
        NSLog(@"%@ is running :%@",self.class,NSStringFromSelector(_cmd));
    }
    CoreDataHelper *cdh=[(AppDelegate*)[[UIApplication sharedApplication] delegate] cdh];
    Unit *unit=(Unit*)[cdh.context existingObjectWithID:self.selectedObjectID error:nil];
    if (textField==self.nameTextField) {
        unit.name=self.nameTextField.text;
        NSLog(@"%@",self.nameTextField.text);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:nil];
    }
    
}

#pragma mark - INTERACTION
-(IBAction)done:(id)sender{
    if (debug==1) {
        NSLog(@"%@ is running :%@",self.class,NSStringFromSelector(_cmd));
    }
    [self hideKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)hideKeyboardWhenBackgroundIsTapped{
    if (debug==1) {
        NSLog(@"%@ is running :%@",self.class,NSStringFromSelector(_cmd));
    }
    UITapGestureRecognizer *tgr=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tgr];
    
}
-(void)hideKeyboard{
    if (debug==1) {
        NSLog(@"%@ is running :%@",self.class,NSStringFromSelector(_cmd));
    }
    [self.nameTextField endEditing:YES];
}

@end
