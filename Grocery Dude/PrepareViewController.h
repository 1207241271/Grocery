//
//  PrepareViewController.h
//  
//
//  Created by yangxu on 15/10/19.
//
//

#import "CoreDataTableViewController.h"

@interface PrepareViewController : CoreDataTableViewController<UIActionSheetDelegate>
@property (strong,nonatomic) UIActionSheet *clearConfirmActionSheet;

@end
