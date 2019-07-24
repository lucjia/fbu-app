//
//  RequestsViewController.m
//  fbu-app
//
//  Created by jordan487 on 7/19/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "RequestsViewController.h"
#import <Parse/Parse.h>
#import "Request.h"
#import "RequestCell.h"
#import "DetailsViewController.h"
#import "Persona.h"

@interface RequestsViewController () <UITableViewDelegate, UITableViewDataSource, RequestCellDelegate>

@property (strong, nonatomic) NSMutableArray *sendersArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RequestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchRequestTimeline];
}

- (void) fetchRequestTimeline {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Request"];
    [query whereKey:@"requestReceiver" equalTo:[PFUser currentUser]]; // requests sent to current user
    
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"requestSender"];
    [query includeKey:@"requestReceiver"];
    [query includeKey:@"acceptedRequests"];
    [query includeKey:@"persona"];
    
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *requests, NSError *error) {
        if (requests != nil) {
            // do something with the array of object returned by the call
            self.sendersArray = [NSMutableArray arrayWithArray:requests];
            [self.tableView reloadData];
        }
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"requestToDetailsSegue"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Persona *user = [self.sendersArray[indexPath.row] objectForKey:@"requestSender"];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.user = user;
    } else {
        // do nothing
    }
}

- (void)acceptRequest:(nonnull Request *)request {
    // sender of Request
    PFUser *requestSender = [request objectForKey:@"requestSender"];
    Persona *senderPersona = [requestSender objectForKey:@"persona"];
    [senderPersona fetchIfNeeded];
    NSMutableArray *senderAcceptedRequests = [NSMutableArray arrayWithArray:[senderPersona objectForKey:@"acceptedRequests"]];
    
    Persona *receiverPersona = [[PFUser currentUser] objectForKey:@"persona"];
    NSMutableArray *acceptedRequests = [NSMutableArray arrayWithArray:[receiverPersona objectForKey:@"acceptedRequests"]];
    
    if (receiverPersona) {
        [senderAcceptedRequests insertObject:receiverPersona atIndex:0];
        senderPersona.acceptedRequests = senderAcceptedRequests;
        [senderPersona saveInBackground];
    }
    if (senderPersona) {
        [acceptedRequests insertObject:senderPersona atIndex:0];
        receiverPersona.acceptedRequests = acceptedRequests;
        [receiverPersona saveInBackground];
    }
    
    // remove from table view
    [self declineRequest:request];
}

// removes request sent to current user from tableView
- (void)declineRequest:(nonnull Request *)request {
    [self.sendersArray removeObject:request];
    [request deleteInBackground]; // removes from parse
    [self.tableView reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RequestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RequestCell"];
    
    Request *request = self.sendersArray[indexPath.row];
    
    cell.delegate = self;
    [cell updateProperties:request];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sendersArray.count;
}

@end