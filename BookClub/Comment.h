//
//  Comment.h
//  BookClub
//
//  Created by Nader Neyzi on 5/21/15.
//  Copyright (c) 2015 Nader Neyzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Book, Person;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * commentText;
@property (nonatomic, retain) Book *book;
@property (nonatomic, retain) Person *poster;

@end
