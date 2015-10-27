//
//  UnitPickerTextField.m
//  
//
//  Created by yangxu on 15/10/27.
//
//

#import "UnitPickerTextField.h"
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "Unit.h"
@implementation UnitPickerTextField
#define debug 1

-(void)fetch{
    if(debug==1){
        NSLog(@"%@ is running :%@",self.class,NSStringFromSelector(_cmd));
    }
    
    CoreDataHelper *cdh=[(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request=[[NSFetchRequest alloc]initWithEntityName:@"Unit"];
    request.sortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    [request setFetchBatchSize:50];
    
    NSError *error;
    NSArray *fetchedUnits=[cdh.context executeFetchRequest:request error:&error];
    self.pickerData=fetchedUnits;
    
    if (error) {
        NSLog(@"Counldn't fetch data error :%@", error);
    }
    
    [self selectDefaultRow];
}

-(void)selectDefaultRow{
    if(debug==1){
        NSLog(@"%@ is running :%@",self.class,NSStringFromSelector(_cmd));
    }
    
    if (self.selectedObjectID&&[self.pickerData count]>0) {
        CoreDataHelper *cdh=[(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
        Unit *selectedObject=(Unit *)[cdh.context existingObjectWithID:self.selectedObjectID error:nil];
        
        [self.pickerData enumerateObjectsUsingBlock:^(Unit *unit, NSUInteger idx, BOOL *stop) {
            if ([unit.name compare:selectedObject.name]==NSOrderedSame) {
                [self.picker selectRow:idx inComponent:0 animated:NO];
                [self.pickerDelegate selectedObjectID:self.selectedObjectID changedPickerTextField:self];
                *stop=YES;
            }
        }];
    }
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    Unit *unit=[self.pickerData objectAtIndex:row];
    return unit.name;
}
@end
