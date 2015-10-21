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
        cell.textLabel.font=[UIFont systemFontOfSize:18];
        cell.textLabel.textColor=[UIColor redColor];
    }
    else{
        cell.textLabel.font=[UIFont systemFontOfSize:16];
        cell.textLabel.textColor=[UIColor grayColor];
    }
    
    return cell;
}



-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    
    return nil;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        Item *deleteTarget=[self.fetchedResultController objectAtIndexPath:indexPath];
        [self.fetchedResultController.managedObjectContext deleteObject:deleteTarget];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
//   item=[self.fetchedResultController objectAtIndexPath:indexPath]?
    NSManagedObjectID *itemId=[[self.fetchedResultController objectAtIndexPath:indexPath] objectID];
    Item *item=(Item*)[self.fetchedResultController.managedObjectContext existingObjectWithID:itemId error:nil];
    if ([item.listed boolValue]) {
        item.listed=[NSNumber numberWithBool:NO];
    }else{
        item.listed=[NSNumber numberWithBool:YES];
        item.collected=[NSNumber numberWithBool:NO];
    }
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
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

#pragma mark - INTERACTION
-(IBAction)clear:(id)sender{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    CoreDataHelper *cdh=[(AppDelegate *)[[UIApplication sharedApplication]delegate]cdh];
    NSFetchRequest *request=[cdh.model fetchRequestTemplateForName:@"ShoppingList"];
    NSArray *shoppingList=[cdh.context executeFetchRequest:request error:nil];
    
    if (shoppingList.count>0) {
        self.clearConfirmActionSheet=[[UIActionSheet alloc] initWithTitle:@"Clear Entire Shopping List?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Clear" otherButtonTitles:nil];
        [self.clearConfirmActionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Nothing to Clear" message:@"Add items to the Shop tab by tapping them on the prepare tab.Remove all items from the Shop tab by click Clear on the Prepare tab." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    
    shoppingList=nil;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet==self.clearConfirmActionSheet) {
        if (buttonIndex==[actionSheet destructiveButtonIndex]) {
            [self performSelector:@selector(clearList)];
        }
        else if (buttonIndex==[actionSheet cancelButtonIndex]){
            [actionSheet dismissWithClickedButtonIndex:[actionSheet cancelButtonIndex] animated:YES];
        }
    }
}

-(void)clearList{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }

    CoreDataHelper *cdh=[(AppDelegate*)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request=[cdh.model fetchRequestTemplateForName:@"ShoppingList"];
    NSArray *shoppingList=[cdh.context executeFetchRequest:request error:nil];
    for (Item *item in shoppingList) {
        item.listed=[NSNumber numberWithBool:NO];
    }
    
}

@end
