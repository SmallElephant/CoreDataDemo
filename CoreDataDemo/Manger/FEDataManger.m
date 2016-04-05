//
//  FEDataManger.m
//  CoreDataDemo
//
//  Created by keso on 16/3/28.
//  Copyright © 2016年 FlyElephant. All rights reserved.
//

#import "FEDataManger.h"

@implementation FEDataManger

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(NSManagedObjectContext *)managedObjectContext{
    if (!_managedObjectContext) {
        NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        //初始化NSPersistentStoreCoordinator
        NSPersistentStoreCoordinator *persistCoordinator=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
        NSURL *applicationURL=[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *storeURL = [applicationURL URLByAppendingPathComponent:@"FECoreData.sqlite"];
        
        NSError *error = nil;
        NSPersistentStore *store = [persistCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        if (store == nil) {
            [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
        }
        _managedObjectContext=[[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectContext.persistentStoreCoordinator = persistCoordinator;
    }
    return _managedObjectContext;
}


#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"保存错误 %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
