//
//  ShopTableViewController.m
//  
//
//  Created by yangxu on 15/10/21.
//
//

#import "ShopTableViewController.h"
#import "CoreDataHelper.h"
#import "Item.h"
#import "Unit.h"
#import "AppDelegate.h"
#import "ItemViewController.h"
@interface ShopTableViewController ()

@end

@implementation ShopTableViewController
#define debug 1
#pragma mark - DATA
-(void)configureFetch{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    CoreDataHelper *cdh=[(AppDelegate*)[[UIApplication sharedApplication]delegate] cdh];
    NSFetchRequest *request=[[cdh.model fetchRequestTemplateForName:@"ShoppingList"]copy];
    request.sortDescriptors=[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"locationAtShop.aisle" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil];
    [request setFetchBatchSize:50];
    
    self.fetchedResultController=[[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:cdh.context sectionNameKeyPath:@"locationAtShop.aisle" cacheName:nil];
    self.fetchedResultController.delegate=self;
}

#pragma mark - VIEW

- (void)viewDidLoad {
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    [self configureFetch];
    [self performFetch];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performFetch) name:@"SomethingChanged" object:nil];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    static NSString *cellIdentifier=@"Shop Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    Item *item=[self.fetchedResultController objectAtIndexPath:indexPath];
    NSMutableString *title=[NSMutableString stringWithFormat:@"%@%@ %@",item.quantity,item.unit.name,item.name];
    [title replaceOccurrencesOfString:@"(null)" withString:@"" options:0 range:NSMakeRange(0,title.length)];
    
    cell.textLabel.text=title;
    
    if (item.collected.boolValue) {
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
        [cell.textLabel setTextColor:[UIColor colorWithRed:0.368627450 green:0.741176470 blue:0.349019607 alpha:1]];
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }else{
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
        [cell.textLabel setTextColor:[UIColor orangeColor]];
        cell.accessoryType=UITableViewCellAccessoryDetailButton;
    }
    return cell;
}

-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    Item *item=[self.fetchedResultController objectAtIndexPath:indexPath];
    if (item.collected.boolValue) {
        item.collected=[NSNumber numberWithBool:NO];
    }else{
        item.collected=[NSNumber numberWithBool:YES];
    }
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma mark -INTERACTION
-(IBAction)clear:(id)sender{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    if (self.fetchedResultController.fetchedObjects.count==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Nothing to Clear" message:@"Add items using the Prepare tab" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    BOOL nothingCleared=YES;
    for (Item *item in self.fetchedResultController.fetchedObjects) {
        if (item.collected.boolValue) {
            item.listed=[NSNumber numberWithBool:NO];
            item.collected=[NSNumber numberWithBool:NO];
            nothingCleared=NO;
        }
    }
    if (nothingCleared) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Select item to be removed from list" message:@"Add items using the Prepare tab" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    ItemViewController *itemViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"ItemViewController"];
    itemViewController.selectedItemID=[[self.fetchedResultController objectAtIndexPath:indexPath] objectID];
    [self.navigationController pushViewController:itemViewController animated:YES];
}

@end
