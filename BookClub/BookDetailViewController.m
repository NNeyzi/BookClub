//
//  BookDetailViewController.m
//  BookClub
//
//  Created by Nader Neyzi on 5/21/15.
//  Copyright (c) 2015 Nader Neyzi. All rights reserved.
//

#import "BookDetailViewController.h"
#import "Comment.h"
#import "AppDelegate.h"

@interface BookDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSArray *comments;
@property NSManagedObjectContext *moc;

@end

@implementation BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.moc = delegate.managedObjectContext;

    self.authorLabel.text = self.book.author;
    self.titleLabel.text = self.book.title;
    UIImage *image = [UIImage imageNamed:self.book.image];
    self.imageView.image = image;
}

-(void)viewWillAppear:(BOOL)animated {
    [self loadComments];
}

- (void)loadComments {
    self.comments = [self.book.comments allObjects];
    [self.tableView reloadData];
}

- (IBAction)addButtonPreseed:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Leave a comment" message:nil preferredStyle:UIAlertControllerStyleAlert];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Your comment..";
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        UITextField *commentTextField = [[alertController textFields] firstObject];
        NSString *enteredComment = commentTextField.text;

        Comment *comment = [NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:self.book.managedObjectContext];
        comment.commentText = enteredComment;
        [self.book addCommentsObject:comment];
        [self.book.managedObjectContext save:nil];
        [self loadComments];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:addAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma tableView
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Comment *comment = [self.comments objectAtIndex:indexPath.row];
    cell.textLabel.text = comment.commentText;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}




@end
