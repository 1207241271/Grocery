//
//  UnitViewController.h
//  
//
//  Created by yangxu on 15/10/22.
//
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"
@interface UnitViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) NSManagedObjectID    *selectedObjectID;
@end
