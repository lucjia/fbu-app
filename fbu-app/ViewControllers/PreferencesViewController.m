//
//  PreferencesViewController.m
//  fbu-app
//
//  Created by lucjia on 7/17/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "PreferencesViewController.h"
#import "PreferenceCell.h"
#import "Parse/Parse.h"

@interface PreferencesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *preferences;
@property (strong, nonatomic) NSDictionary *preferencesSmokeQ;
@property (strong, nonatomic) NSDictionary *preferencesTimeQ;
@property (strong, nonatomic) NSDictionary *preferencesCleanQ;
@property (strong, nonatomic) NSMutableArray *preferencesSmoke;
@property (strong, nonatomic) NSMutableArray *preferencesTime;
@property (strong, nonatomic) NSMutableArray *preferencesClean;
@property (strong, nonatomic) NSMutableArray *userPreferences;
@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UIButton *submitButton;

@end

@implementation PreferencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    
    // Create Dictionary of preferences
    self.preferencesSmoke = [NSMutableArray arrayWithObjects: @"No", @"Yes", nil];
    self.preferencesSmokeQ = [NSDictionary dictionaryWithObject:@"Do you smoke?" forKey:self.preferencesSmoke];
    self.preferencesTime = [NSMutableArray arrayWithObjects:@"Early Bird", @"Night Owl", nil];
    self.preferencesTimeQ = [NSDictionary dictionaryWithObject:@"Are you an early bird or night owl?" forKey:self.preferencesTime];
    self.preferencesClean = [NSMutableArray arrayWithObjects:@"Neat", @"Messy", @"In Between", nil];
    self.preferencesCleanQ = [NSDictionary dictionaryWithObject:@"Are you neat or messy?" forKey:self.preferencesClean];
    self.preferences = [NSMutableArray arrayWithObjects:self.preferencesSmokeQ, self.preferencesTimeQ, self.preferencesCleanQ, nil];
    
    // Create Set Preferences button
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(50, 70, 300, 45)];
    self.submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [self.submitButton setFrame:CGRectMake(10, 15, 280, 44)];
    [self.submitButton addTarget:self action:@selector(setPreferences) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:self.submitButton];
    [self.tableView setTableFooterView:self.footerView];
    
    // Initialize UserPreferences array
    self.userPreferences = [[NSMutableArray alloc] init];
}

// creates table view
- (void)initTableView {
    // full screen
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // allows for reusable cells
    [self.tableView registerClass:[PreferenceCell class] forCellReuseIdentifier:@"PreferenceCell"];
    
    [self.view addSubview:self.tableView];
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PreferenceCell";
    
    PreferenceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell = [[PreferenceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    NSDictionary *currentPrefDictionary = [self.preferences objectAtIndex:indexPath.row];
    NSString *prefQ = [currentPrefDictionary.allValues objectAtIndex:0];
    cell.preferenceQ = prefQ;
    cell.answerArray = [currentPrefDictionary.allKeys objectAtIndex:0];
    [cell updateProperties];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.userArray.count;
    return self.preferences.count;
}

- (void)setPreferences {
    [self.userPreferences removeAllObjects];
    for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:0]; ++i) {
        PreferenceCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [self.userPreferences addObject:[cell getChoice]];
    }
    
    NSLog(@"%@", self.userPreferences);
    
    // Revisit this - set the content of the text field to be the preference on Parse
    [[PFUser currentUser] setObject:self.userPreferences forKey:@"preferences"];

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
