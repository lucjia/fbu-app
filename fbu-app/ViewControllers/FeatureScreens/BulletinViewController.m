//
//  BulletinViewController.m
//  fbu-app
//
//  Created by lucjia on 8/1/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "BulletinViewController.h"
#import "PostCell.h"
#import "Parse/Parse.h"
#import <LGSideMenuController/LGSideMenuController.h>
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>
#import "House.h"
#import "Persona.h"
#import "Accessibility.h"
#import "ComposePostViewController.h"
#import "CustomColor.h"
#import "MapViewController.h"

@interface BulletinViewController () <UICollectionViewDelegate, UICollectionViewDataSource, ComposePostViewControllerDelegate, PostCellDelegate> {
    NSMutableArray *posts;
    NSLayoutConstraint *heightConstraint;
    UIRefreshControl *refreshControl;
    Post *currentPost;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewLayout *layout;

@end

@implementation BulletinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[CustomColor darkMainColor:1.0]}];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    // Refresh control for "pull to refresh"
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    refreshControl.layer.zPosition = -1;
    [self.collectionView insertSubview:refreshControl atIndex:0];
    
    [self fetchPosts];
    
    // animation
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    transition.duration = 0.25;
    [self.collectionView.layer addAnimation:transition forKey:nil];
    
    // add double tap gesture recognizer
    UITapGestureRecognizer *doubleTapFolderGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(processDoubleTap:)];
    [doubleTapFolderGesture setNumberOfTapsRequired:2];
    [doubleTapFolderGesture setNumberOfTouchesRequired:1];
    doubleTapFolderGesture.delaysTouchesBegan = YES;
    [self.collectionView addGestureRecognizer:doubleTapFolderGesture];
    
    // get notification if font size is changed from settings accessibility
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(preferredContentSizeChanged:)
     name:UIContentSizeCategoryDidChangeNotification
     object:nil];
}

// change font size based on accessibility setting
- (void)preferredContentSizeChanged:(NSNotification *)notification {
}

- (void) refresh {
    [self fetchPosts];
    [self.collectionView reloadData];
}

- (void) fetchPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    
    [query includeKey:@"postSender"];
    [query includeKey:@"postText"];
    [query includeKey:@"location"];
    [query includeKey:@"createdAt"];
    
    [query orderByDescending:@"createdAt"];
    
    Persona *persona = [[PFUser currentUser] objectForKey:@"persona"];
    [persona fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        House *house = [persona objectForKey:@"house"];
        [house fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            [query whereKey:@"postSender" containedIn:house.housemates];
            [query findObjectsInBackgroundWithBlock:^(NSArray *fetchedPosts, NSError *error) {
                if (fetchedPosts != nil) {
                    self->posts = (NSMutableArray *)fetchedPosts;
                    [self.collectionView reloadData];
                } else {
                    NSLog(@"%@", error.localizedDescription);
                }
            }];
            [self->refreshControl endRefreshing];
        }];
    }];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return self.layout.collectionViewContentSize;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCell" forIndexPath:indexPath];
    cell.post = posts[indexPath.row];
    
    cell.delegate = self;
    [cell setCell];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [posts count];
}

- (IBAction)didPressLeft:(id)sender {
    [self showLeftViewAnimated:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toCompose"]) {
        ComposePostViewController *composeVC = (ComposePostViewController *)[segue destinationViewController];
        composeVC.delegate = self;
    } else if ([[segue identifier] isEqualToString:@"toMap"]) {
        MapViewController *mapVC = (MapViewController *)[segue destinationViewController];
        self.delegate = mapVC;
        [self.delegate setLocationWithCenter:[currentPost objectForKey:@"location"] poster:[currentPost[@"postSender"] objectForKey:@"firstName"] venue:[currentPost objectForKey:@"venue"]];
    }
}

- (void) didPressItemAtIndexPath:(NSIndexPath *)indexPath {
    // segue to map view which is centered on the location mentioned in the post
    if ([[posts objectAtIndex:indexPath.row] objectForKey:@"location"]) {
        currentPost = [posts objectAtIndex:indexPath.row];
        
        [self performSegueWithIdentifier:@"toMap" sender:self];
    } else {
        // Create alert to display error
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Location Shared"
                                                                       message:@"This post does not include a location."
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  // Handle cancel response here. Doing nothing will dismiss the view.
                                                              }];
        // Add the cancel action to the alertController
        [alert addAction:dismissAction];
        alert.view.tintColor = [CustomColor accentColor:1.0];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)processDoubleTap:(UITapGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint p = [gestureRecognizer locationInView:self.collectionView];
        
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
        if (indexPath == nil){
            NSLog(@"couldn't find index path");
        } else {
            // do stuff with the cell
            [self didPressItemAtIndexPath:indexPath];
        }
    }
}

- (void) deletePost:(Post *)post {
    [posts removeObject:post];
    [post deleteInBackground];
    [self.collectionView reloadData];
}

@end
