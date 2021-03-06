//
//  AppDelegate.m
//  Grocery Dude
//
//  Created by yangxu on 15/10/15.
//  Copyright (c) 2015年 yangxu. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
#define debug 1

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[self cdh] saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    [self cdh];
    [self demo];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[self cdh] saveContext];
}

-(CoreDataHelper *)cdh{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    if (!_coreDataHelper) {
        //在生命周期中只执行一次
        static dispatch_once_t predicate;
        dispatch_once(&predicate,^{
            _coreDataHelper=[[CoreDataHelper alloc]init];
        });
        [_coreDataHelper setupCoreData];
    }
    
    return _coreDataHelper;
}

-(void)demo{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
 
//    CoreDataHelper *cdh=[self cdh];
//    NSArray *homeLoactions=[NSArray arrayWithObjects:@"Fruit Bowl",@"Pantry",@"Nursery",@"Bathroom",@"fridge", nil];
//    NSArray *shopLocations=[NSArray arrayWithObjects:@"produce",@"Aisle1",@"Aisle2",@"Aisle3",@"Deli", nil];
//    NSArray *unitNames=[NSArray arrayWithObjects:@"g",@"pkt",@"box",@"ml",@"kg", nil];
//    NSArray *itemNames=[NSArray arrayWithObjects:@"Grapes",@"Biscuits",@"Nappies",@"Shampoo",@"Sausage", nil];
//    
//    int i=0;
//    for (NSString *itemName in itemNames) {
//        LocationAtHome *locationAtHome=[NSEntityDescription insertNewObjectForEntityForName:@"LocationAtHome" inManagedObjectContext:cdh.context];
//        LocationAtShop *locationAtShop=[NSEntityDescription insertNewObjectForEntityForName:@"LocationAtShop" inManagedObjectContext:cdh.context];
//        Unit *unit=[NSEntityDescription insertNewObjectForEntityForName:@"Unit" inManagedObjectContext:cdh.context];
//        Item *item=[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:cdh.context];
//        locationAtHome.storeIn=[homeLoactions objectAtIndex:i];
//        locationAtShop.aisle=[shopLocations objectAtIndex:i];
//        unit.name=[unitNames objectAtIndex:i];
//        item.name=[itemNames objectAtIndex:i];
//        
//        item.unit=unit;
//        item.locationAtHome=locationAtHome;
//        item.locationAtShop=locationAtShop;
//        
//        i++;
//    }
//    [cdh saveContext];
    
}

-(void)showUnitsAndItems{
    NSFetchRequest *unit=[NSFetchRequest fetchRequestWithEntityName:@"Unit"];
    NSArray *fetchedUnit=[[self cdh].context executeFetchRequest:unit error:nil];
    NSLog(@"Unit number is %lu",(long unsigned)fetchedUnit.count);
    
    NSFetchRequest *items=[NSFetchRequest fetchRequestWithEntityName:@"Item"];
    NSArray *fetchedItem=[[self cdh].context executeFetchRequest:items error:nil];
    NSLog(@"items number is %lu",(long unsigned)fetchedItem.count);
    
}


@end
