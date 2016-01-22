//
//  AddBookViewController.m
//  BookClub
//
//  Created by Nader Neyzi on 5/21/15.
//  Copyright (c) 2015 Nader Neyzi. All rights reserved.
//

#import "AddBookViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface AddBookViewController ()
@property (weak, nonatomic) IBOutlet UITextField *addTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *addAuthorTextField;
@property NSManagedObjectContext *moc;
@property NSArray *books;

@end

@implementation AddBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.moc = delegate.managedObjectContext;
    self.books = [self.person.books allObjects];
}

- (IBAction)onSaveButtonTapped {

    if (self.addTitleTextField.text.length != 0 && self.addAuthorTextField.text.length != 0) {
        Book *book = [NSEntityDescription insertNewObjectForEntityForName:@"Book"inManagedObjectContext:self.moc];
        [book setValue:self.addTitleTextField.text forKey:@"title"];
        [book setValue:self.addAuthorTextField.text forKey:@"author"];
        [book setValue:@"book" forKey:@"image"];
        [self.person addBooksObject:book];
        self.person.numBooks = [NSNumber numberWithInteger:self.person.books.count];
        [self.moc save:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }

}





@end
