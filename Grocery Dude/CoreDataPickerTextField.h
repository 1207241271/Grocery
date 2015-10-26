//
//  CoreDataPickerTextField.h
//  
//
//  Created by yangxu on 15/10/26.
//
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"

@class CoreDataPickerTextField;
@protocol CoreDataPickerTextFieldDelegate <NSObject>
-(void)selectedObjectID:(NSManagedObjectID *)objectID changedPickerTextField:(CoreDataPickerTextField *) pickerTextField;
@optional
-(void)selectedObjectClearedForPickerTextField:(CoreDataPickerTextField *)pickerTextField;

@end

@interface CoreDataPickerTextField : UITextField<UIKeyInput,UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, weak) id<CoreDataPickerTextFieldDelegate> pickerDelegate;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) NSArray *pickerData;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) NSManagedObjectID *selectedObjectID;
@property (nonatomic) BOOL showToolbar;

@end
