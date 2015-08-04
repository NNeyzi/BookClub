//
//  Book.h
//  BookClub
//
//  Created by Anders Chaplin on 6/3/15.
//  Copyright (c) 2015 ___AndersChaplin___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Person;

@interface Book : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSSet *readers;
@property (nonatomic, retain) NSSet *comments;
@end

@interface Book (CoreDataGeneratedAccessors)

- (void)addReadersObject:(Person *)value;
- (void)removeReadersObject:(Person *)value;
- (void)addReaders:(NSSet *)values;
- (void)removeReaders:(NSSet *)values;

- (void)addCommentsObject:(NSManagedObject *)value;
- (void)removeCommentsObject:(NSManagedObject *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

@end
