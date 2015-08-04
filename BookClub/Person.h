//
//  Person.h
//  BookClub
//
//  Created by Anders Chaplin on 6/3/15.
//  Copyright (c) 2015 ___AndersChaplin___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * numBooks;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSSet *books;
@property (nonatomic, retain) NSSet *comments;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addBooksObject:(NSManagedObject *)value;
- (void)removeBooksObject:(NSManagedObject *)value;
- (void)addBooks:(NSSet *)values;
- (void)removeBooks:(NSSet *)values;

- (void)addCommentsObject:(NSManagedObject *)value;
- (void)removeCommentsObject:(NSManagedObject *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

@end
