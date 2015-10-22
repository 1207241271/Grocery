//
//  UnitTableViewController.m
//  
//
//  Created by yangxu on 15/10/22.
//
//

#import "UnitTableViewController.h"
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "Unit.h"


@interface UnitTableViewController ()

@end

@implementation UnitTableViewController
#define debug 1

#pragma mark - DATA
-(void)configureFetch{
    if (debug==1) {
        NSLog(@"%@ is running %@",self.class,NSStringFromSelector(_cmd));
    }
    
    
    CoreDataHelper *cdh=[(AppDelegate*)[[UIApplication sharedApplication]delegate] cdh];
    NSFetchRequest *request=[[cdh.model fetchRequestTemplateForName:@"Unit"] copy];
    request.sortDescriptors=[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES],nil];
    [request setFetchBatchSize:50];
    
    self.fetchedResultController=[[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:cdh.context sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultController.delegate=self;
}

#pragma mark - VIEW
-(void)viewDidLoad{
    if (debug==1) {
        NSLog(@"%@ is running %@",self.class,NSStringFromSelector(_cmd));
    }
    
    [super viewDidLoad];
    [self configureFetch];
    [self performFetch];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performFetch) name:@"SomethingChanged" object:nil];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (debug==1) {
        NSLog(@"%@ is running %@",self.class,NSStringFromSelector(_cmd));
    }
    
    static NSString *cellIdentifier=@"Unit Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    Unit *unit=[self.fetchedResultController objectAtIndexPath:indexPath];
    cell.textLabel.text=unit.name;
    return cell;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (debug==1) {
        NSLog(@"%@ is running %@",self.class,NSStringFromSelector(_cmd));
    }
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        Unit *deleteTarget=[self.fetchedResultController objectAtIndexPath:indexPath];
        [self.fetchedResultController.managedObjectContext deleteObject:deleteTarget];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
#pragma mark - INTERACTION

-(IBAction)done:(id)sender{
    if (debug==1) {
        NSLog(@"%@ is running %@",self.class,NSStringFromSelector(_cmd));
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    
    
}

@end
