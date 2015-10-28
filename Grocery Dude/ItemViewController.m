//
//  ItemViewController.m
//  
//
//  Created by yangxu on 15/10/21.
//
//

#import "ItemViewController.h"
#import "AppDelegate.h"
#import "LocationAtShop.h"

#import "LocationAtHome.h"
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
    
    if (textField==self.unitPickerTextField) {
        [_unitPickerTextField fetch];
        [_unitPickerTextField.picker reloadAllComponents];
    }
    
    if (textField==self.locationAtHomePickerTextField) {
        [_locationAtHomePickerTextField fetch];
        [_locationAtHomePickerTextField.picker reloadAllComponents];
    }
    if (textField==self.locationAtShopPickerTextField) {
        [_locationAtShopPickerTextField fetch];
        [_locationAtShopPickerTextField.picker reloadAllComponents];
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
        
        self.unitPickerTextField.text=item.unit.name;
        self.unitPickerTextField.selectedObjectID=item.unit.objectID;
        self.locationAtHomePickerTextField.text=item.locationAtHome.storeIn;
        self.locationAtHomePickerTextField.selectedObjectID=item.locationAtHome.objectID;
        self.locationAtShopPickerTextField.text=item.locationAtShop.aisle;
        self.locationAtShopPickerTextField.selectedObjectID=item.locationAtShop.objectID;
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
    
    self.unitPickerTextField.delegate=self;
    self.locationAtHomePickerTextField.delegate=self;
    self.locationAtShopPickerTextField.delegate=self;
    
    self.unitPickerTextField.pickerDelegate=self;
    self.locationAtHomePickerTextField.pickerDelegate=self;
    self.locationAtShopPickerTextField.pickerDelegate=self;
}

-(void)viewWillAppear:(BOOL)animated{
    if (debug==1) {
        NSLog(@"%@ is runnging ,info:%@",self.class,NSStringFromSelector(_cmd));
    }
    
    [self ensureItemHomeLocationIsNotNull];
    [self ensureItemShopLocationIsNotNull];
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
    [self ensureItemHomeLocationIsNotNull];
    [self ensureItemShopLocationIsNotNull];
    CoreDataHelper *cdh=[(AppDelegate*)[[UIApplication sharedApplication] delegate] cdh];
    [cdh saveContext];
}

#pragma mark - DATA
-(void)ensureItemHomeLocationIsNotNull{
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
                locationAtHome.storeIn=@"..UnkownLocationHome..";
                item.locationAtHome=locationAtHome;
            }
            
        }
    
    
    }
}

-(void)ensureItemShopLocationIsNotNull{
    if (debug==1) {
        NSLog(@"%@ is runnging ,info:%@",self.class,NSStringFromSelector(_cmd));
    }
    
    if (self.selectedItemID) {
        CoreDataHelper *cdh=[(AppDelegate*)[[UIApplication sharedApplication] delegate] cdh];
        Item *item=(Item*)[cdh.context existingObjectWithID:self.selectedItemID error:nil];
        
        if (!item.locationAtShop) {
            NSFetchRequest *request=[cdh.model fetchRequestTemplateForName:@"UnkownLocationAtShop"];
            NSArray *fetchedObject=[cdh.context executeFetchRequest:request error:nil];
            
            NSFetchRequest *requsetForShop=[NSFetchRequest fetchRequestWithEntityName:@"LocationAtShop"];
            NSArray *shops=[cdh.context executeFetchRequest:requsetForShop error:nil];
            for (LocationAtShop *shop in shops) {
                NSLog(@"%@",shop.aisle);
            }
            
            
            if (fetchedObject.count>0) {
                item.locationAtShop=[fetchedObject objectAtIndex:0];
            }else{
                LocationAtShop *locationAtShop=[NSEntityDescription insertNewObjectForEntityForName:@"LocationAtShop" inManagedObjectContext:cdh.context];
                NSError *error;
                
                if (![cdh.context obtainPermanentIDsForObjects:[NSArray arrayWithObject:locationAtShop] error:&error]) {
                    NSLog(@"Couldn't obtain a permanent ID for object error:%@",error);
                }
                locationAtShop.aisle=@"..UnkownLocationShop..";
                item.locationAtShop=locationAtShop;
            }
            
        }
    }
}

#pragma mark - PICKER
-(void)selectedObjectID:(NSManagedObjectID *)objectID changedPickerTextField:(CoreDataPickerTextField *)pickerTextField{
    if (debug==1) {
        NSLog(@"%@ is runnging ,info:%@",self.class,NSStringFromSelector(_cmd));
    }
    
    if (self.selectedItemID) {
        CoreDataHelper *cdh=[(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
        
        Item *item=(Item *)[cdh.context existingObjectWithID:self.selectedItemID error:nil];
        
        NSError *error;
        if (pickerTextField==self.unitPickerTextField) {
            item.unit=(Unit *)[cdh.context existingObjectWithID:objectID error:&error];
            
            self.unitPickerTextField.text=item.unit.name;
        }else if (pickerTextField==self.locationAtHomePickerTextField){
            item.locationAtHome=(LocationAtHome *)[cdh.context existingObjectWithID:objectID error:&error];
            
            self.locationAtHomePickerTextField.text=item.locationAtHome.storeIn;
        }else if (pickerTextField==self.locationAtShopPickerTextField){
            item.locationAtShop=(LocationAtShop *)[cdh.context existingObjectWithID:objectID error:&error];
            self.locationAtShopPickerTextField.text=item.locationAtShop.aisle;
        }
        
        
        
        [self refreshInterface];
        
        if (error) {
            NSLog(@"Error selecting object on picker:%@ ,%@" ,pickerTextField,error);
        }
        
    }
    
    
    
}


-(void)selectedObjectClearedForPickerTextField:(CoreDataPickerTextField *)pickerTextField{
    if (debug==1) {
        NSLog(@"%@ is runnging ,info:%@",self.class,NSStringFromSelector(_cmd));
    }
    
    if (self.selectedItemID) {
        CoreDataHelper *cdh=[(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
        Item *item=(Item *)[cdh.context existingObjectWithID:self.selectedItemID error:nil];
        if (pickerTextField==self.unitPickerTextField) {
            item.unit=nil;
            self.unitPickerTextField.text=@"";
        }else if(pickerTextField==self.locationAtHomePickerTextField){
            item.locationAtHome=nil;
            self.locationAtHomePickerTextField.text=@"";
        }else if(pickerTextField==self.locationAtShopPickerTextField){
            item.locationAtShop=nil;
            self.locationAtShopPickerTextField.text=@"";
        }
        
        
    }
    [self refreshInterface];
}

@end
