//
//  CoreDataTableViewController.h
//  
//
//  Created by yangxu on 15/10/19.
//
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"
@interface CoreDataTableViewController : UITableViewController<NSFetchedResultsControllerDelegate>

@property (nonatomic ,strong) NSFetchedResultsController *fetchedResultController;

-(void)performFetch;

@end
