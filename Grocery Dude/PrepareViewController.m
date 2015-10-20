//
//  PrepareViewController.m
//  
//
//  Created by yangxu on 15/10/19.
//
//

#import "PrepareViewController.h"
#import "CoreDataHelper.h"
#import "Item.h"
#import "Unit.h"
#import "AppDelegate.h"

@interface PrepareViewController ()

@end

@implementation PrepareViewController
#define debug 1

#pragma mark - VIEW
- (void)viewDidLoad {
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    [super viewDidLoad];
    [self configureFetch];
    [self performFetch];
    _clearConfirmActionSheet.delegate=self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performFetch) name:@"somethingChanged" object:nil];

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    static NSString *CellIdentifier=@"Item Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.accessoryType=UITableViewCellAccessoryDetailButton;
    Item *item=[self.fetchedResultController objectAtIndexPath:indexPath];
    NSMutableString *title=[NSMutableString stringWithFormat:@"%@%@ %@",item.quantity,item.unit.name,item.name];
    [title replaceOccurrencesOfString:@"(null)" withString:@"" options:0 range:NSMakeRange(0, [title length])];
    cell.textLabel.text=title;
    if ([item.listed boolValue]==YES) {
        cell.textLabel.font=[UIFont systemFontOfSize:36];
        cell.textLabel.textColor=[UIColor redColor];
    }
    else{
        cell.textLabel.font=[UIFont systemFontOfSize:36];
        cell.textLabel.textColor=[UIColor grayColor];
    }
    
    return cell;
}



-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    
    return nil;
}


#pragma mark - DATA
-(void)configureFetch{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Item"];
    
    request.sortDescriptors=[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"locationAtHome.storeIn" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil];
    [request setFetchBatchSize:50];
    
    CoreDataHelper *cdh=[(AppDelegate *)[[UIApplication sharedApplication]delegate] cdh];
    
    
    self.fetchedResultController=[[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:cdh.context sectionNameKeyPath:@"locationAtHome.storeIn" cacheName:nil];
    
    self.fetchedResultController.delegate=self;
}



@end
