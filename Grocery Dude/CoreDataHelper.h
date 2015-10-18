//
//  CoreDataHelper.h
//  
//
//  Created by yangxu on 15/10/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MigrationViewController.h"

@interface CoreDataHelper : NSObject
@property(nonatomic, readonly) NSManagedObjectContext       *context;
@property(nonatomic, readonly) NSManagedObjectModel         *model;
@property(nonatomic, readonly) NSPersistentStoreCoordinator *coordinator;
@property(nonatomic, readonly) NSPersistentStore            *store;

@property(nonatomic, retain) MigrationViewController        *migrationViewController;

-(void)setupCoreData;
-(void)saveContext;

@end
