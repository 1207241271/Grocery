//
//  CoreDataHelper.m
//  
//
//  Created by yangxu on 15/10/15.
//
//

#import "CoreDataHelper.h"

@implementation CoreDataHelper

#define debug 1

#pragma mark - FILES
NSString *storeFilename = @"Grocery-Dude.sqlit";

#pragma mark - PATHS
-(NSString *)applicationDocumentsDirectory{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    return  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

-(NSURL *)applicationStoreDirectory{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    NSURL *storesDirectory=[[NSURL fileURLWithPath:[self applicationDocumentsDirectory]]URLByAppendingPathComponent:@"Stores"];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[storesDirectory path]]) {
        NSError* error;
        
        if ([fileManager createDirectoryAtURL:storesDirectory withIntermediateDirectories:YES attributes:nil error:&error]) {
            if (debug==1) {
                NSLog(@"Successfully create storesDirectory");
            }
        }
        else{
            NSLog(@"FAILED to create StoreDirectory!");
        }
    }
    
    return storesDirectory;
}

-(NSURL *)storeURL{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    return [[self applicationStoreDirectory]URLByAppendingPathComponent:storeFilename];
}



#pragma mark - SETUP
-(id)init{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    self=[super init];
    if (!self) {
        return nil;
    }
    
    _model=[NSManagedObjectModel mergedModelFromBundles:nil];
    _coordinator=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:_model];
    _context=[[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_context setPersistentStoreCoordinator:_coordinator];
    
    return self;
}

-(void)loadStore{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    if (_store) {
        return;
    }
    
    
    BOOL useMigrationManager=NO;
    if (useMigrationManager&&[self isMigrationNecessaryForStore:[self storeURL]]) {
        [self performBackgroundManagedMigrationForStore:[self storeURL]];
    }
    else{
        NSDictionary *options=@{
                            NSMigratePersistentStoresAutomaticallyOption:@YES,
                            NSInferMappingModelAutomaticallyOption:@NO,
                            NSSQLitePragmasOption: @{@"journal_mode": @"DELETE"}};
    
        NSError* error;
        _store=[_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storeURL] options:options error:&error];
        if (!_store) {
            NSLog(@"Fail to add store, error:%@",error);
            abort();
        }
        else
            NSLog(@"Successfully add store %@",_store);
    }
    
}

-(void)setupCoreData{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    [self loadStore];
}



#pragma mark - SAVING
-(void)saveContext{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    if (![_context hasChanges]) {
            NSLog(@"SKIP save changes, there is no change");
    }
    else{
        NSError* error;
        if ([_context save:&error]) {
            NSLog(@"SAVE successfully");
        }
        else
            NSLog(@"Fail to save _context,error:%@",error);
    }
}


#pragma mark - MIGRATION MANAGER
-(BOOL)isMigrationNecessaryForStore:(NSURL *)storeUrl{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self storeURL].path]) {
        if (debug==1) {
            NSLog(@"SKIP Migration:source data file missing");
        }
        return NO;
    }
    
    NSError *error;
    NSDictionary *sourceMetadata=[NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:storeUrl error:&error];
    NSManagedObjectModel *destinationModel=_coordinator.managedObjectModel;
    if ([destinationModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata]) {
        if (debug==1) {
            NSLog(@"SKIP Migration:source is compatible");
        }
        return NO;
    }

    return YES;
}


-(BOOL)migrateStore:(NSURL *)sourceStore{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    BOOL success=NO;
    NSError *error;
    
    NSDictionary *sourceMetaData=[NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:sourceStore error:&error];
    
    NSManagedObjectModel *sourceModel=[NSManagedObjectModel mergedModelFromBundles:nil forStoreMetadata:sourceMetaData];
    //[_coordinator managedObjectModel] or _model ?
    NSManagedObjectModel *destinationModel=[_coordinator managedObjectModel];
    
    NSMappingModel *mappingModel=[NSMappingModel mappingModelFromBundles:nil forSourceModel:sourceModel destinationModel:destinationModel];
    
    if (mappingModel) {
        NSError *error;
        NSMigrationManager *migrationManager=[[NSMigrationManager alloc]initWithSourceModel:sourceModel destinationModel:destinationModel];
        
        [migrationManager addObserver:self forKeyPath:@"migrationProgress" options:NSKeyValueObservingOptionNew context:nil];
        
        NSURL *destinationStore=[[self applicationStoreDirectory]URLByAppendingPathComponent:@"Temp.sqlite"];
        
        success=[migrationManager migrateStoreFromURL:sourceStore type:NSSQLiteStoreType options:nil withMappingModel:mappingModel toDestinationURL:destinationStore destinationType:NSSQLiteStoreType destinationOptions:nil error:&error];
        if (success) {
            
            if ([self replaceStore:sourceStore withStore:destinationStore]) {
                if (debug==1) {
                    NSLog(@"replace store success");
                }
                [migrationManager removeObserver:self forKeyPath:@"migrationProgress"];
            }
           
        }
        else{
            if (debug==1) {
                NSLog(@"migrationManager is null");
            }
        }

        
    }
    else{
        if (debug==1) {
            NSLog(@"mappingModal is nil");
        }
    }
    return YES;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"migrationProgress"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            float progress=[[change objectForKey:NSKeyValueChangeNewKey] floatValue];
            _migrationViewController.progressView.progress=progress;
            int percent=progress*100;
            NSString *progressStr=[NSString stringWithFormat:@"migration progress:%i%%",percent];
            NSLog(@"percent %i",percent);
            _migrationViewController.label.text=progressStr;
            
        });
    }
    
    
    
}

-(BOOL)replaceStore:(NSURL *)old withStore:(NSURL *)new{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    BOOL success=NO;
    NSError *error;
    if ([[NSFileManager defaultManager] removeItemAtURL:old error:&error]) {
        if (debug==1) {
            NSLog(@"remove old success");
        }
        
        error=nil;
        if ([[NSFileManager defaultManager]moveItemAtURL:new toURL:old error:&error]) {
            success=YES;
        }
        else{
            if (debug==1) {
                 NSLog(@"replace old with new fail: error: %@",error);
            }
        }
    }
    else{
        if (debug==1) {
                NSLog(@"remove old fail,error:%@",error);
        }
        
    }
    
    return success;
}

-(void)performBackgroundManagedMigrationForStore:(NSURL *)storeURL{
    if (debug==1) {
        NSLog(@"Running %@,%@",self.class,NSStringFromSelector(_cmd));
    }
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.migrationViewController=[storyboard instantiateViewControllerWithIdentifier:@"migration"];
    UINavigationController *navigationController=(UINavigationController *)[[UIApplication sharedApplication]keyWindow].rootViewController;
    [navigationController presentViewController:self.migrationViewController animated:YES completion:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        BOOL done=[self migrateStore:storeURL];
        if (done) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error;
                //[self storeURL] or storeURL ?
                _store=[_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storeURL] options:nil error:&error];
                if (!_store) {
                    NSLog(@"fail t add migrated store,error: %@",error);
                    abort();
                }
                else {
                    NSLog(@"success add store");
                    [self.migrationViewController dismissViewControllerAnimated:YES completion:nil];
                    self.migrationViewController=nil;
                }
            });
        }
    });
}



@end
