//
//  PeopleTableViewController.m
//  BookClub
//
//  Created by Nader Neyzi on 5/21/15.
//  Copyright (c) 2015 Nader Neyzi. All rights reserved.
//

#import "PeopleTableViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "Person.h"


@interface PeopleTableViewController ()
@property NSManagedObjectContext *moc;
@property NSMutableArray *importedPeople;
@property NSArray *people;

@end

@implementation PeopleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.moc = delegate.managedObjectContext;

    self.importedPeople = [NSMutableArray new];
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *myFile = [mainBundle pathForResource:@"friends" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile: myFile];
    self.importedPeople = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    self.people = [self.moc executeFetchRequest:request error:nil];


}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.importedPeople.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = [self.importedPeople objectAtIndex:indexPath.row];

    for (Person *person in self.people) {
        if ([person.name isEqualToString:cell.textLabel.text]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if(cell.accessoryType != UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person"inManagedObjectContext:self.moc];
        person.name = cell.textLabel.text;
        person.image = @"marty";
        [self.moc save:nil];
    }
    else{
        for (Person *person in self.people) {
            if ([person.name isEqualToString:cell.textLabel.text]) {
                [self.moc deleteObject:person];
            }
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    self.people = [self.moc executeFetchRequest:request error:nil];
//    NSLog(@"%@", self.people);
}

@end
