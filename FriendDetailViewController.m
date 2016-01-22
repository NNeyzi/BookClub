//
//  FriendDetailViewController.m
//  BookClub
//
//  Created by Nader Neyzi on 5/21/15.
//  Copyright (c) 2015 Nader Neyzi. All rights reserved.
//

#import "FriendDetailViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "BookDetailViewController.h"
#import "AddBookViewController.h"

@interface FriendDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *numBooksLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSManagedObjectContext *moc;

@property NSArray *books;

@end

@implementation FriendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.moc = delegate.managedObjectContext;
}

-(void)viewWillAppear:(BOOL)animated {
    [self loadBooks];
    self.navigationItem.title = self.person.name;
    self.numBooksLabel.text = [NSString stringWithFormat:@"%@", self.person.numBooks];

    UIImage *image = [UIImage imageNamed:self.person.image];
    self.imageView.image = image;
}

- (void)loadBooks {
    self.books = [self.person.books allObjects];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.books.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    Book *book = [self.books objectAtIndex:indexPath.row];
    cell.textLabel.text = book.title;
    cell.detailTextLabel.text = book.author;
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"SegueToBookDetailVC"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
        BookDetailViewController *bdvc = segue.destinationViewController;
        bdvc.book = [self.books objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"SegueToAddBookVC"]) {
        AddBookViewController *abvc = segue.destinationViewController;
        abvc.person = self.person;
    }
}



@end
