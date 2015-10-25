//
//  LocationAtHomeViewController.h
//  
//
//  Created by yangxu on 15/10/25.
//
//

#import "CoreDataTableViewController.h"
#import  "CoreDataHelper.h"
@interface LocationAtHomeViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) NSManagedObjectID   *selectedObjectID;
@end
