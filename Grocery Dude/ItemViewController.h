//
//  ItemViewController.h
//  
//
//  Created by yangxu on 15/10/21.
//
//

#import <UIKit/UIKit.h>
#import "UnitPickerTextField.h"
#import "CoreDataHelper.h"
@interface ItemViewController : UIViewController <UITextFieldDelegate,CoreDataPickerTextFieldDelegate>
@property (strong, nonatomic) NSManagedObjectID    *selectedItemID;
@property (strong, nonatomic) IBOutlet UIScrollView *srollView;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *quantityTextField;
@property (strong, nonatomic) IBOutlet UnitPickerTextField *unitPickerTextField;

@end
