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
        _coreDataHelper=[[CoreDataHelper alloc]init];
        [_coreDataHelper setupCoreData];
    }
    
    return _coreDataHelper;
}

-(void)demo{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    Unit *kg=[NSEntityDescription insertNewObjectForEntityForName:@"Unit" inManagedObjectContext:[self cdh].context];
    Item *orange=[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:_coreDataHelper.context];
    Item *banana=[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:_coreDataHelper.context];
    
    kg.name=@"Kg";
    orange.units=kg;
    banana.units=kg;
    [self showUnitsAndItems];
    
    
    
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Unit"];
    NSArray *units=[_coreDataHelper.context executeFetchRequest:request error:nil];
    for (Unit *unit in units) {
        
        
        NSError *error;
        if ([unit validateForDelete:&error]) {
            [_coreDataHelper.context deleteObject:unit];
            NSLog(@"delete one");
        }
        else{
            NSLog(@"error :%@",error);
        }
    }
    
    [self showUnitsAndItems];
    [_coreDataHelper saveContext];
    
}

-(void)showUnitsAndItems{
    NSFetchRequest *unit=[NSFetchRequest fetchRequestWithEntityName:@"Unit"];
    NSArray *fetchedUnit=[[self cdh].context executeFetchRequest:unit error:nil];
    NSLog(@"Unit number is %lu",(long unsigned)fetchedUnit.count);
    
    NSFetchRequest *items=[NSFetchRequest fetchRequestWithEntityName:@"Item"];
    NSArray *fetchedItem=[[self cdh].context executeFetchRequest:items error:nil];
    NSLog(@"Unit number is %lu",(long unsigned)fetchedItem.count);
    
}


@end
