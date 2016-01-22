//
//  RootTableViewController.m
//  BookClub
//
//  Created by Nader Neyzi on 5/21/15.
//  Copyright (c) 2015 Nader Neyzi. All rights reserved.
//

#import "RootTableViewController.h"
#import "Person.h"
#import "FriendDetailViewController.h"
#import "AppDelegate.h"


@interface RootTableViewController ()<UISearchResultsUpdating, UISearchBarDelegate>

@property NSMutableArray *people;
@property NSMutableArray *filteredPeople;
@property NSManagedObjectContext *moc;
@property BOOL sortTapped;

@property (strong, nonatomic) UISearchController *searchController;

typedef NS_ENUM(NSInteger, BookClubSearchScope)
{
    searchScopeName = 0,
    searchScopeNumber = 1
};

@end

@implementation RootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sortTapped = NO;

    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.moc = delegate.managedObjectContext;

    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.scopeButtonTitles = @[@"Name",@"Number of Books"];
    self.searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    [self.searchController.searchBar sizeToFit];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadPeople];
}

- (void)loadPeople {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    self.people = [[self.moc executeFetchRequest:request error:nil] mutableCopy];
    [self.tableView reloadData];
}

- (IBAction)onSortTapped:(id)sender {

    //NSSortDescriptor might have been a better option

    if (self.sortTapped) {
        self.people = [[[self.people reverseObjectEnumerator] allObjects] mutableCopy];
    }else {
        [self.people sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSNumber *num1 = [(Person *)obj1 numBooks];
            NSNumber *num2 = [(Person *)obj2 numBooks];
            return [num1 compare:num2];
        }];
    }
    [self.tableView reloadData];
    self.sortTapped = !self.sortTapped;
}


#pragma mark - UISearchBarDelegate

-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {

}
#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {

    NSString *searchString = searchController.searchBar.text;
    [self searchForText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
}

- (void)searchForText:(NSString *)searchText scope:(BookClubSearchScope)scopeOption {
    if (self.moc)
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
        if (scopeOption == searchScopeName) {
            request.predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@", searchText];
        } else {
            request.predicate = [NSPredicate predicateWithFormat:@"books.@count = %d", [searchText intValue]];
        }
        self.filteredPeople = [[self.moc executeFetchRequest:request error:nil] mutableCopy];
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.searchController.active) {
        return self.filteredPeople.count;
    } else {
        return self.people.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Person *person;
    if (self.searchController.active) {
        person = [self.filteredPeople objectAtIndex:indexPath.row];
    } else {
        person = [self.people objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = person.name;
    UIImage *image = [UIImage imageNamed:person.image];
    cell.imageView.image = image;

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"SegueToFriendDetailVC"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
        FriendDetailViewController *destVC = segue.destinationViewController;
        destVC.person = [self.people objectAtIndex:indexPath.row];
    }
}

@end
