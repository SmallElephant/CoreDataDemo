//
//  FEDataManger.h
//  CoreDataDemo
//
//  Created by keso on 16/3/28.
//  Copyright © 2016年 FlyElephant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface FEDataManger : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(void)saveContext;

@end
