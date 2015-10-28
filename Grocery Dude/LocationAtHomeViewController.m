//
//  LocationAtHomeViewController.m
//  
//
//  Created by yangxu on 15/10/25.
//
//

#import "LocationAtHomeViewController.h"
#import "AppDelegate.h"
#import "LocationAtHome.h"
@implementation LocationAtHomeViewController

#define debug 1


#pragma mark - VIEW
-(void)refreshInterface{
    if (debug==1) {
        NSLog(@"%@ is running :%@",self.class,NSStringFromSelector(_cmd));
    }
    
    CoreDataHelper *cdh=[(AppDelegate* )[[UIApplication sharedApplication] delegate] cdh];
    LocationAtHome *locationAtHome=(LocationAtHome *)[cdh.context existingObjectWithID:self.selectedObjectID error:nil];
    self.nameTextField.text=locationAtHome.storeIn;
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
    
    [super viewWillAppear:animated];
    [self refreshInterface];
    [self.nameTextField becomeFirstResponder];

}


#pragma mark - TEXTFIELD
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (debug==1) {
        NSLog(@"%@ is running :%@",self.class,NSStringFromSelector(_cmd));
    }
    CoreDataHelper *cdh=[(AppDelegate*)[[UIApplication sharedApplication] delegate] cdh];
    LocationAtHome *locationAtHome=(LocationAtHome*)[cdh.context existingObjectWithID:self.selectedObjectID error:nil];
    if (textField==self.nameTextField) {
        locationAtHome.storeIn=self.nameTextField.text;
        NSLog(@"%@",self.nameTextField.text);
        [cdh saveContext];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:nil];
    }
    
}

#pragma mark - INTERACTION

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




- (IBAction)done:(id)sender {
    if (debug==1) {
        NSLog(@"%@ is running :%@",self.class,NSStringFromSelector(_cmd));
    }
    
    [self hideKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
