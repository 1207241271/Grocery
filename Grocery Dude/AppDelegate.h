//
//  AppDelegate.h
//  Grocery Dude
//
//  Created by yangxu on 15/10/15.
//  Copyright (c) 2015年 yangxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"
#import "Item.h"
#import "Unit.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow                      *window;
@property (strong, nonatomic, readonly)CoreDataHelper       *coreDataHelper;

-(CoreDataHelper *)cdh;
@end

