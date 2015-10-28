//
//  LocationAtHomePickerTextField.m
//  
//
//  Created by yangxu on 15/10/28.
//
//

#import "LocationAtHomePickerTextField.h"
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "LocationAtHome.h"

@implementation LocationAtHomePickerTextField
#define debug 1
#pragma mark - DATA
-(void)fetch{
    if(debug==1){
        NSLog(@"%@ is running :%@",self.class,NSStringFromSelector(_cmd));
    }
    CoreDataHelper *cdh=[(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"LocationAtHome"];
    request.sortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"storeIn" ascending:YES]];
    request.fetchBatchSize=50;
    
    NSError *error;
    NSArray *fetchData=[cdh.context executeFetchRequest:request error:&error];
    self.pickerData=fetchData;
    if (error) {
        NSLog(@"fetching data for home picker failed ,error :%@",error);
    }
    [self selectDefaultRow];
}

-(void)selectDefaultRow{
    if(debug==1){
        NSLog(@"%@ is running :%@",self.class,NSStringFromSelector(_cmd));
    }
    
    if (self.selectedObjectID&&[self.pickerData count]>0) {
        CoreDataHelper *cdh=[(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
        LocationAtHome *selectedObject=(LocationAtHome *)[cdh.context existingObjectWithID:self.selectedObjectID error:nil];
        
        [self.pickerData enumerateObjectsUsingBlock:^(LocationAtHome *locationAtHome, NSUInteger idx, BOOL *stop) {
            if ([locationAtHome.storeIn compare:selectedObject.storeIn]==NSOrderedSame) {
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
    
    return [[self.pickerData objectAtIndex:row] storeIn];
}






@end
