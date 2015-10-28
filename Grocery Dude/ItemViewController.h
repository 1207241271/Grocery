//
//  ItemViewController.h
//  
//
//  Created by yangxu on 15/10/21.
//
//

#import <UIKit/UIKit.h>
#import "UnitPickerTextField.h"
#import "LocationAtHomePickerTextField.h"
#import "LocationAtShopPickerTextField.h"
#import "CoreDataHelper.h"
@interface ItemViewController : UIViewController <UITextFieldDelegate,CoreDataPickerTextFieldDelegate>
@property (strong, nonatomic) NSManagedObjectID    *selectedItemID;
@property (strong, nonatomic) IBOutlet UIScrollView *srollView;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *quantityTextField;
@property (strong, nonatomic) IBOutlet UnitPickerTextField *unitPickerTextField;
@property (strong, nonatomic) IBOutlet LocationAtHomePickerTextField *locationAtHomePickerTextField;
@property (strong, nonatomic) IBOutlet LocationAtShopPickerTextField *locationAtShopPickerTextField;

@end
