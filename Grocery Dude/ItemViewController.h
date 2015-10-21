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
@end
