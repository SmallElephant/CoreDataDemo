//
//  Book+CoreDataProperties.h
//  CoreDataDemo
//
//  Created by keso on 16/3/20.
//  Copyright © 2016年 FlyElephant. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Book.h"

NS_ASSUME_NONNULL_BEGIN

@interface Book (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *bookName;
@property (nullable, nonatomic, retain) NSString *author;

@end

NS_ASSUME_NONNULL_END
