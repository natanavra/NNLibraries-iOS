//
//  NNAutocompleteViewController.m
//  NNLibraries
//
//  Created by Natan Abramov on 1/9/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NNAutocompleteViewController.h"

@interface NNAutocompleteViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, weak) IBOutlet UITableView *autocompleteTable;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeButton;
@property (nonatomic, weak) IBOutlet UINavigationBar *navBar;

@property (nonatomic, strong) NSString *navBarTitle;
@property (nonatomic, strong) NSArray *autocompleteData;
@property (nonatomic, strong) NSArray *filteredData;
@property (nonatomic, assign) BOOL filtered;
@end

@implementation NNAutocompleteViewController

static NSString *const cellID = @"autocompleteCell";

#pragma mark - Init

- (instancetype)init {
    NSAssert(NO, @"NNAutocompleteViewController--Use only 'initWithDelegate:andData:'");
    return nil;
}

- (instancetype)initWithTitle:(NSString *)title delegate:(id<NNAutoCompleteDelegate>)delegate data:(NSArray *)data {
    if(self = [super initWithNibName: NSStringFromClass([self class]) bundle: nil]) {
        _autocompleteData = data;
        _filteredData = nil;
        _filtered = NO;
        _navBarTitle = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _navBar.topItem.title = _navBarTitle;
    _navBarTitle = nil;
}

#pragma mark - IBActions

- (void)setCloseButtonTitle:(NSString *)title {
    [_closeButton setTitle: title];
}

- (IBAction)closeAction:(id)sender {
    if(_delegate) {
        [_delegate selectionCancelled];
    }
    [self dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - UISearchBar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(searchText.length > 0) {
            NSPredicate *predicate = [NSPredicate predicateWithBlock: ^BOOL(id evaluatedObject, NSDictionary *bindings) {
                if([evaluatedObject conformsToProtocol: @protocol(NNSelectableObject)]) {
                    NSString *title = [evaluatedObject title];
                    if([title rangeOfString: searchText options: NSCaseInsensitiveSearch].location != NSNotFound) {
                        return YES;
                    }
                }
                return NO;
            }];
            _filteredData = [_autocompleteData filteredArrayUsingPredicate: predicate];
            _filtered = YES;
        } else {
            _filtered = NO;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_autocompleteTable reloadData];
        });
    });
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing: YES];
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_filtered) {
        return _filteredData.count;
    } else {
        return _autocompleteData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellID];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellID];
    }
    id<NNSelectableObject> object = nil;
    if(_filtered) {
        object = _filteredData[indexPath.row];
    } else {
        object = _autocompleteData[indexPath.row];
    }
    
    cell.textLabel.text = [object title];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_delegate) {
        id<NNSelectableObject> object = nil;
        if(_filtered) {
            object = _filteredData[indexPath.row];
        } else {
            object = _autocompleteData[indexPath.row];
        }
        [_delegate selectionDone: object];
        [self dismissViewControllerAnimated: YES completion: nil];
    }
}

@end
