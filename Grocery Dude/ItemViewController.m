//
//  ItemViewController.m
//  
//
//  Created by yangxu on 15/10/21.
//
//

#import "ItemViewController.h"
#import "AppDelegate.h"

@interface ItemViewController ()

@end

@implementation ItemViewController
#define debug 1

#pragma mark - INTERACTION
-(IBAction)done:(id)sender{
    if (debug==1) {
        NSLog(@"%@ is runnging ,info:%@",self.class,NSStringFromSelector(_cmd));
    }
    
    [self hideKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)hideKeyboardWhenBackgroundIsTapped{
    if (debug==1) {
        NSLog(@"%@ is runnging ,info:%@",self.class,NSStringFromSelector(_cmd));
    }
    
    UITapGestureRecognizer *tgr=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    
    [tgr setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tgr];
}

-(void)hideKeyboard{
    if (debug==1) {
        NSLog(@"%@ is runnging ,info:%@",self.class,NSStringFromSelector(_cmd));
    }
    
    [self.view endEditing:YES];
}


#pragma mark - DELEGATE:UITEXTFIELD
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (debug==1) {
        NSLog(@"%@ is runnging ,info:%@",self.class,NSStringFromSelector(_cmd));
    }
    if (textField==self.nameTextField) {
        if ([self.nameTextField.text isEqualToString:@"New Item"]) {
            self.nameTextField.text=@"";
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (debug==1) {
        NSLog(@"%@ is runnging ,info:%@",self.class,NSStringFromSelector(_cmd));
    }
    
    CoreDataHelper *cdh=[(AppDelegate*)[[UIApplication sharedApplication] delegate] cdh];
    Item *item=(Item*)[cdh.context existingObjectWithID:self.selectedItemID error:nil];
    
    
    if (textField==self.nameTextField) {
        if ([self.nameTextField.text isEqualToString:@""]) {
            self.nameTextField.text=@"New Item";
        }
        item.name=self.nameTextField.text;
    }else if (textField==self.quantityTextField){
        item.quantity=[NSNumber numberWithFloat:self.quantityTextField.text.floatValue];
    }
        
}



#pragma mark - VIEW

-(void)refreshInterface{
    if (debug==1) {
        NSLog(@"%@ is runnging ,info:%@",self.class,NSStringFromSelector(_cmd));
    }
    if (self.selectedItemID) {
        CoreDataHelper *cdh=[(AppDelegate*)[[UIApplication sharedApplication] delegate] cdh];
        Item *item=(Item*)[cdh.context existingObjectWithID:self.selectedItemID error:nil];
        self.nameTextField.text=item.name;
        self.quantityTextField.text=item.quantity.stringValue;
    }
}


-(void)viewDidLoad{
    if (debug==1) {
        NSLog(@"%@ is runnging ,info:%@",self.class,NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    [self hideKeyboardWhenBackgroundIsTapped];
    self.nameTextField.delegate=self;
    self.quantityTextField.delegate=self;
}

-(void)viewWillAppear:(BOOL)animated{
    if (debug==1) {
        NSLog(@"%@ is runnging ,info:%@",self.class,NSStringFromSelector(_cmd));
    }
    
    [self ensureItemHomeLocationIsNOtNull];
    [self ensureItemShopLocationIsNOtNull];
    [self refreshInterface];
    if ([self.nameTextField.text isEqualToString:@"New Item"]) {
        self.nameTextField.text=@"";
        [self.nameTextField becomeFirstResponder];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    if (debug==1) {
        NSLog(@"%@ is runnging ,info:%@",self.class,NSStringFromSelector(_cmd));
    }
    [self ensureItemHomeLocationIsNOtNull];
    [self ensureItemShopLocationIsNOtNull];
    CoreDataHelper *cdh=[(AppDelegate*)[[UIApplication sharedApplication] delegate] cdh];
    [cdh saveContext];
}

#pragma mark - DATA
-(void)ensureItemHomeLocationIsNOtNull{
    if (debug==1) {
        NSLog(@"%@ is runnging ,info:%@",self.class,NSStringFromSelector(_cmd));
    }
    
    if (self.selectedItemID) {
        CoreDataHelper *cdh=[(AppDelegate*)[[UIApplication sharedApplication] delegate] cdh];
        Item *item=(Item*)[cdh.context existingObjectWithID:self.selectedItemID error:nil];
        
        if (!item.locationAtHome) {
            NSFetchRequest *request=[cdh.model fetchRequestTemplateForName:@"UnkownLocationAtHome"];
            NSArray *fetchedObject=[cdh.context executeFetchRequest:request error:nil];
            
            if (fetchedObject.count>0) {
                item.locationAtHome=[fetchedObject objectAtIndex:0];
            }else{
                LocationAtHome *locationAtHome=[NSEntityDescription insertNewObjectForEntityForName:@"LocationAtHome" inManagedObjectContext:cdh.context];
                NSError *error;
                
                if (![cdh.context obtainPermanentIDsForObjects:[NSArray arrayWithObject:locationAtHome] error:&error]) {
                    NSLog(@"Couldn't obtain a permanent ID for object error:%@",error);
                }
                locationAtHome.storeIn=@"..UnkownLocation..";
                item.locationAtHome=locationAtHome;
            }
            
        }
    
    
    }
}

-(void)ensureItemShopLocationIsNOtNull{
    if (debug==1) {
        NSLog(@"%@ is runnging ,info:%@",self.class,NSStringFromSelector(_cmd));
    }
    
    if (self.selectedItemID) {
        CoreDataHelper *cdh=[(AppDelegate*)[[UIApplication sharedApplication] delegate] cdh];
        Item *item=(Item*)[cdh.context existingObjectWithID:self.selectedItemID error:nil];
        
        if (!item.locationAtShop) {
            NSFetchRequest *request=[cdh.model fetchRequestTemplateForName:@"UnkownLocationAtShop"];
            NSArray *fetchedObject=[cdh.context executeFetchRequest:request error:nil];
            
            if (fetchedObject.count>0) {
                item.locationAtShop=[fetchedObject objectAtIndex:0];
            }else{
                LocationAtShop *locationAtShop=[NSEntityDescription insertNewObjectForEntityForName:@"LocationAtShop" inManagedObjectContext:cdh.context];
                NSError *error;
                
                if (![cdh.context obtainPermanentIDsForObjects:[NSArray arrayWithObject:locationAtShop] error:&error]) {
                    NSLog(@"Couldn't obtain a permanent ID for object error:%@",error);
                }
                locationAtShop.aisle=@"..UnkownLocation..";
                item.locationAtShop=locationAtShop;
            }
            
        }
        
        
    }
}

@end
