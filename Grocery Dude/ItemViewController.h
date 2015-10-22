//
//  ItemViewController.h
//  
//
//  Created by yangxu on 15/10/21.
//
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"
@interface ItemViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) NSManagedObjectID    *selectedItemID;
@property (strong, nonatomic) IBOutlet UIScrollView *srollView;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *quantityTextField;

@end
