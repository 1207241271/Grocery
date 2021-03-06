//
//  CoreDataPickerTextField.m
//  
//
//  Created by yangxu on 15/10/26.
//
//

#import "CoreDataPickerTextField.h"

@implementation CoreDataPickerTextField
#define debug 1

#pragma mark - DELEGATE & DATASOURCE
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    return self.pickerData.count;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    return 44;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    return 280;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    return [self.pickerData objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    NSManagedObject  *object=[self.pickerData objectAtIndex:row];
    [self.pickerDelegate selectedObjectID:[object objectID] changedPickerTextField:self];
}

#pragma mark - INTERACTION
-(void)done{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    [self resignFirstResponder];
}

-(void)clear{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    [self.pickerDelegate selectedObjectClearedForPickerTextField:self];
}

#pragma mark - DATA
-(void)fetch{
    [NSException raise:NSInternalInconsistencyException format:@"you must override the %@ to provide data",NSStringFromSelector(_cmd)];
}

-(void)selectedDefaultRow{
    [NSException raise:NSInternalInconsistencyException format:@"you must override the %@ to set default row",NSStringFromSelector(_cmd)];
}

#pragma mark - VIEW
-(UIView *)createInputView{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    self.picker=[[UIPickerView alloc]initWithFrame:CGRectZero];
    //设置高亮
    self.picker.showsSelectionIndicator=YES;
    self.picker.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    self.picker.delegate=self;
    self.picker.dataSource=self;
    [self fetch];
    
    return self.picker;
}

-(UIView *)createInputAccessoryView{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    self.showToolbar=YES;
    if (!self.toolbar &&self.showToolbar) {
        self.toolbar=[[UIToolbar alloc]init];
        self.toolbar.barStyle=UIBarStyleBlackTranslucent;
        self.toolbar.autoresizingMask=UIViewAutoresizingFlexibleHeight;
        [self.toolbar sizeToFit];
        CGRect frame=self.toolbar.frame;
        frame.size.height=44;
        self.toolbar.frame=frame;
        
        
        UIBarButtonItem *clearBtn=[[UIBarButtonItem alloc]initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clear)];
        UIBarButtonItem *spacer=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
        
        NSArray *barArray=[NSArray arrayWithObjects:clearBtn,spacer,doneBtn,nil];
        [self.toolbar setItems:barArray];
    }
    
    return self.toolbar;
}

-(id)initWithFrame:(CGRect)frame{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    if (self=[super initWithFrame:frame]) {
        self.inputView=[self createInputView];
        self.inputAccessoryView=[self createInputAccessoryView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    if (self=[super initWithCoder:aDecoder]) {
        self.inputView=[self createInputView];
        self.inputAccessoryView=[self createInputAccessoryView];
    }
    return self;
}
//?
-(void)deviceDidRotate:(NSNotification *)notification{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    [self.picker setNeedsLayout];
}

@end
