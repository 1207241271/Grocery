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
                            NSInferMappingModelAutomaticallyOption:@YES,
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
        else{
            NSLog(@"Fail to save _context,error:%@",error);
            [self showValidationError:error];
        }
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

#pragma mark - VALIDATION ERROR HANDLING
-(void)showValidationError:(NSError *)anError{
    if (anError&&[anError.domain isEqualToString:@"NSCocoaErrorDomain"]) {
        NSArray *errors;
        NSString *text=@"";
        if (anError.code==NSValidationMultipleErrorsError) {
            errors=[anError.userInfo objectForKey:NSDetailedErrorsKey];
        }
        else
            errors=[NSArray arrayWithObject:anError];
        if (errors&&errors.count>0) {
            for (NSError *error in errors) {
                NSString *entity=[[[error.userInfo objectForKey:@"NSValidationErrorObject"]entity]name];
                NSString *property=[error.userInfo objectForKey:@"NSValidationErrorKey"];
                switch (error.code) {
                    case NSValidationRelationshipDeniedDeleteError:
                        text=[text stringByAppendingFormat:@"%@ delete was denied %@\n(Error  code%li)\n\n",entity,property,(long)error.code];
                        break;
                    case NSManagedObjectValidationError:
                        text=[text stringByAppendingFormat:@"the %@ generic validation error (code %li)",property,(long)error.code];
                        break;
                    case NSValidationStringTooShortError:
                        text=[text stringByAppendingFormat:@"the %@ some string value fails to match some pattern (code %li)",property,(long)error.code];
                        break;
                    case NSValidationStringPatternMatchingError:
                        text=[text stringByAppendingFormat:@"the %@ some string value is too short (code %li)",property,(long)error.code];
                        break;
                    case NSValidationStringTooLongError:
                        text=[text stringByAppendingFormat:@"the %@ some string value is too long (code %li)",property,(long)error.code];
                        break;
                    case NSValidationInvalidDateError:
                        text=[text stringByAppendingFormat:@"the %@ some date value fails to match date pattern  (code %li)",property,(long)error.code];
                        break;
                    case NSValidationDateTooSoonError:
                        text=[text stringByAppendingFormat:@"the %@ some date value is too soon (code %li)",property,(long)error.code];
                        break;
                    case NSValidationDateTooLateError:
                        text=[text stringByAppendingFormat:@"the %@ some date value is too late (code %li)",property,(long)error.code];
                        break;
                    case NSValidationNumberTooSmallError:
                        text=[text stringByAppendingFormat:@"the %@ some numerical value is too small (code %li)",property,(long)error.code];
                        break;
                    case NSValidationNumberTooLargeError:
                        text=[text stringByAppendingFormat:@"the %@ some numerical value is too large (code %li)",property,(long)error.code];
                        break;
                    case NSValidationRelationshipExceedsMaximumCountError:
                        text=[text stringByAppendingFormat:@"the %@ bounded, to-many relationship with too many destination objects  (code %li)",property,(long)error.code];
                        break;
                    case NSValidationRelationshipLacksMinimumCountError:
                        text=[text stringByAppendingFormat:@"the %@ to-many relationship with too few destination objects (code %li)",property,(long)error.code];
                        break;
                    case NSValidationMissingMandatoryPropertyError:
                        text=[text stringByAppendingFormat:@"the %@ non-optional property with a nil value  (code %li)",property,(long)error.code];
                        break;
                    default:
                        text=[text stringByAppendingFormat:@"Unhandled error %li",(long)error.code];
                        break;

                }
            }
        }
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Validation Error" message:text delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        [alertView show];
    }

    
    
}


@end
