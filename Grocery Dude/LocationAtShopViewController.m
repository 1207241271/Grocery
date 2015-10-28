//
//  LocationAtShopViewController.m
//  
//
//  Created by yangxu on 15/10/26.
//
//

#import "LocationAtShopViewController.h"
#import "LocationAtShop.h"
#import "CoreDataHelper.h"
#import "AppDelegate.h"
@implementation LocationAtShopViewController
#define debug 1
#pragma mark - VIEW
-(void)refreshInterface{
    if (debug==1) {
        NSLog(@"%@ is running :%@",self.class,NSStringFromSelector(_cmd));
    }
    
    CoreDataHelper *cdh=[(AppDelegate*)[[UIApplication sharedApplication] delegate] cdh];
    LocationAtShop *locationAtShop=(LocationAtShop *)[cdh.context existingObjectWithID:self.selectedObjectID error:nil];
    self.nameTextField.text=locationAtShop.aisle;
}

-(void)viewDidLoad{
    if (debug==1) {
        NSLog(@"%@ is running :%@",self.class,NSStringFromSelector(_cmd));
    }
    
    [super viewDidLoad];
    [self hideKeyboardWhenTapped];
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




#pragma mark - INTERACTION

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (debug==1) {
        NSLog(@"%@ is running :%@",self.class,NSStringFromSelector(_cmd));
    }
    CoreDataHelper *cdh=[(AppDelegate*)[[UIApplication sharedApplication] delegate] cdh];
    LocationAtShop *locationAtShop=(LocationAtShop*)[cdh.context existingObjectWithID:self.selectedObjectID error:nil];
    if (textField==self.nameTextField) {
        locationAtShop.aisle=self.nameTextField.text;
        NSLog(@"%@",self.nameTextField.text);
        [cdh saveContext];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:nil];
    }
    
}

-(void)hideKeyboardWhenTapped{
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
    [self.view endEditing:YES];
}

- (IBAction)done:(id)sender {
    if (debug==1) {
        NSLog(@"%@ is running :%@",self.class,NSStringFromSelector(_cmd));
    }
    
    [self hideKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
