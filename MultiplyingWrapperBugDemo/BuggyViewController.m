//
//  BuggyViewController.m
//  MultiplyingWrapperBugDemo
//
//  Created by Chris Murphy on 9/27/16.
//  Copyright © 2016 Chris Murphy. All rights reserved.
//

#import "BuggyViewController.h"

@interface BuggyViewController () <UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate> {
    NSArray<NSString*>* toyData;
    NSArray<NSString*>* filteredToyData;
    NSInteger disappearCount;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) UISearchController* searchController;

@end

@implementation BuggyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    toyData = @[ @"Apples", @"Peach", @"Gasoline", @"Fog", @"Coffee", @"Africa", @"Phone", @"Sunglasses", @"Paper bag", @"Wrapper", @"Pony", @"Detail", @"Appointment", @"Guitar", @"Frog", @"Stall", @"Camera", @"Cord", @"Computer", @"Programmer"];
 
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.delegate = self;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchResultsUpdater = self;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
    
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.delegate = self;
    self.searchController.active = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (disappearCount <= 0) {
        self.navigationItem.title = @"This will look fine";
    } else if (disappearCount == 1) {
        self.navigationItem.title = @"This won't";
    } else {
        self.navigationItem.title = @"Nor will this";
    }
    disappearCount++;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (!self.presentingViewController) {
        [self.searchController dismissViewControllerAnimated:NO completion:nil]; //This needs to be done or dealloc will never be called
    }
}

- (void)dealloc {
    NSLog(@"Dealloc called");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return filteredToyData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"theCell"];
    cell.textLabel.text = filteredToyData[indexPath.row];
    
    return cell;
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    [searchController.searchBar becomeFirstResponder];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString* searchText = searchController.searchBar.text;
    if (searchText.length <= 0) {
        filteredToyData = toyData;
    } else {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"self BEGINSWITH[cd] %@", searchController.searchBar.text];
        filteredToyData = [toyData filteredArrayUsingPredicate:predicate];
    }
    [self.tableView reloadData];
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

@end
