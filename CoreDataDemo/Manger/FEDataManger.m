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
        // 从应用程序包中加载模型文件
        NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
        // 传入模型对象，初始化NSPersistentStoreCoordinator
        
        NSPersistentStoreCoordinator *persistCoordinator=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
        // 构建SQLite数据库文件的路径
//        NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSURL *applicationURL=[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *storeURL = [applicationURL URLByAppendingPathComponent:@"FECoreData.sqlite"];
        
        // 添加持久化存储库，这里使用SQLite作为存储库
        NSError *error = nil;
        NSPersistentStore *store = [persistCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        if (store == nil) { // 直接抛异常
            [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
        }
        // 初始化上下文，设置persistentStoreCoordinator属性
        _managedObjectContext=[[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectContext.persistentStoreCoordinator = persistCoordinator;
    }
    return _managedObjectContext;
}


#pragma mark - Accessors

-(NSManagedObjectModel *)managedObjectModel{
    if (!_managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FECoreData" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FECoreData.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"创建或加载存储数据时出错";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] =@"初始化数据失败";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"www.cnblogs.com/xiaofeixiang/" code:9999 userInfo:dict];
        NSLog(@"错误 %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
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
