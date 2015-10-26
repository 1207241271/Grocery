//
//  LocationAtShopTableViewController.m
//  
//
//  Created by yangxu on 15/10/26.
//
//

#import "LocationAtShopTableViewController.h"
#import "CoreDataHelper.h"
#import "LocationAtShop.h"
#import "LocationAtShopViewController.h"
#import "AppDelegate.h"
@implementation LocationAtShopTableViewController
#define debug 1

#pragma mark - DATA
-(void)configureFetch{
    if (debug==1) {
        NSLog(@"%@ is running ,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    CoreDataHelper *cdh=[(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"LocationAtShop"];
    request.sortDescriptors=[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"aisle" ascending:YES],nil];
    [request setFetchBatchSize:50];
    
    self.fetchedResultController=[[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:cdh.context sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultController.delegate=self;
}

#pragma mark - VIEW
-(void)viewDidLoad{
    if (debug==1) {
        NSLog(@"%@ is running ,%@",self.class,NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    [self configureFetch];
    [self performFetch];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performFetch) name:@"SomethingChanged" object:nil];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (debug==1) {
        NSLog(@"%@ is running ,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    static NSString *cellIdentifier=@"LocationAtShop Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    LocationAtShop *locationAtShop=[self.fetchedResultController objectAtIndexPath:indexPath];
    cell.textLabel.text=locationAtShop.aisle;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (debug==1) {
        NSLog(@"%@ is running ,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        LocationAtShop *deleteTarget=[self.fetchedResultController objectAtIndexPath:indexPath];
        [self.fetchedResultController.managedObjectContext deleteObject:deleteTarget];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

#pragma mark - INTERACTION
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if (debug==1) {
        NSLog(@"%@ is running ,%@",self.class,NSStringFromSelector(_cmd));
    }
    LocationAtShopViewController *locationAtShopViewController=[segue destinationViewController];
    if ([segue.identifier isEqualToString:@"Add Object Segue"]) {
        CoreDataHelper *cdh=[(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
        LocationAtShop *newLocationAtShop=[NSEntityDescription insertNewObjectForEntityForName:@"LocationAtShop" inManagedObjectContext:cdh.context];
        NSError *error;
        if (![cdh.context obtainPermanentIDsForObjects:[NSArray arrayWithObject:newLocationAtShop] error:&error]) {
            NSLog(@"Couldn't obtain a permanent ID error:%@",error);
        }
        locationAtShopViewController.selectedObjectID=newLocationAtShop.objectID;
    }else if ([segue.identifier isEqualToString:@"Edit Object Segue"]){
        NSIndexPath *indexPath=[self.tableView indexPathForSelectedRow];
        locationAtShopViewController.selectedObjectID=[[self.fetchedResultController objectAtIndexPath:indexPath] objectID];
    }
    
}


- (IBAction)done:(id)sender {
    if (debug==1) {
        NSLog(@"%@ is running ,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}





@end
