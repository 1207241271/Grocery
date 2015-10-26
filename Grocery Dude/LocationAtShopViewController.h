//
//  LocationAtShopViewController.h
//  
//
//  Created by yangxu on 15/10/26.
//
//

#import <UIKit/UIKit.h>
#include "CoreDataHelper.h"

@interface LocationAtShopViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) NSManagedObjectID *selectedObjectID;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

@end
