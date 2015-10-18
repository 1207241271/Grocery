//
//  Unit.h
//  
//
//  Created by yangxu on 15/10/18.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface Unit : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Item *items;

@end
