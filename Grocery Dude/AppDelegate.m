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
    
    
    
    
    
    
//    for (int i=1; i<10000; i++) {
//        Measurement * new=[NSEntityDescription insertNewObjectForEntityForName:@"Measurement" inManagedObjectContext:_coreDataHelper.context];
//        new.abc=[NSString stringWithFormat:@"---->> lots of data %i",i];
//        NSLog(@"%@",new.abc);
//    }

    NSFetchRequest *request= [NSFetchRequest fetchRequestWithEntityName:@"Unit"];
    [request setFetchLimit:50];
    NSError *error;
    NSArray *fetchObject=[_coreDataHelper.context executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"error: %@",error);
    }
    else
    {
        for (Unit *measure in fetchObject) {
            NSLog(@"Amount objects:%@",measure.name);
        }
    }
}


@end
