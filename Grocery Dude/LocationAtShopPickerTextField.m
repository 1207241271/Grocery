//
//  LocationAtShopPickerTextField.m
//  
//
//  Created by yangxu on 15/10/28.
//
//

#import "LocationAtShopPickerTextField.h"
#import "CoreDataHelper.h"
#import "LocationAtShop.h"
#import "AppDelegate.h"

@implementation LocationAtShopPickerTextField
#define debug 1
-(void)fetch{
    if(debug==1){
        NSLog(@"%@ is running :%@",self.class,NSStringFromSelector(_cmd));
    }
    
    CoreDataHelper *cdh=[(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"LocationAtShop"];
    request.sortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"aisle" ascending:YES]];
    request.fetchBatchSize=50;
    
    NSError *error;
    self.pickerData=[cdh.context executeFetchRequest:request error:&error];
    if(error){
        NSLog(@"Fetch data for location at shop failed error: %@",error);
    }
    
}

-(void)selectedDefaultRow{
    if(debug==1){
        NSLog(@"%@ is running :%@",self.class,NSStringFromSelector(_cmd));
    }
    
    if (self.selectedObjectID&&[self.pickerData count]>0) {
        CoreDataHelper *cdh=[(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
        LocationAtShop *selectedObject=(LocationAtShop *)[cdh.context existingObjectWithID:self.selectedObjectID error:nil];
        
        [self.pickerData enumerateObjectsUsingBlock:^(LocationAtShop *locationAtShop, NSUInteger idx, BOOL *stop) {
            if ([locationAtShop.aisle compare:selectedObject.aisle]==NSOrderedSame) {
                [self.picker selectRow:idx inComponent:0 animated:NO];
                [self.pickerDelegate selectedObjectID:selectedObject.objectID changedPickerTextField:self];
                *stop=YES;
            }
        }];
    }
    
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(debug==1){
        NSLog(@"%@ is running :%@",self.class,NSStringFromSelector(_cmd));
    }
    
    return [[self.pickerData objectAtIndex:row] aisle];
}

@end
