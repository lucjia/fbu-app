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

@interface BulletinViewController () <UICollectionViewDelegate, UICollectionViewDataSource> {
    NSMutableArray *posts;
    NSLayoutConstraint *heightConstraint;
    UIRefreshControl *refreshControl;
}

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewLayout *layout;

@end

@implementation BulletinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set background image
    self.backgroundImage.image = [UIImage imageNamed:@"grid"];
    self.backgroundImage.clipsToBounds = YES;
    self.backgroundImage.alpha = 0.8;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    // Refresh control for "pull to refresh"
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:refreshControl atIndex:0];
    
    [self fetchPosts];
}

- (void) fetchPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    
    [query includeKey:@"postSender"];
    [query includeKey:@"postText"];
    [query includeKey:@"location"];
    [query includeKey:@"createdAt"];
    
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *fetchedPosts, NSError *error) {
        if (fetchedPosts != nil) {
            posts = (NSMutableArray *)fetchedPosts;
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    [refreshControl endRefreshing];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return self.layout.collectionViewContentSize;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCell" forIndexPath:indexPath];
    cell.post = posts[indexPath.row];
    [cell setCell];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [posts count];
}

- (IBAction)didPressLeft:(id)sender {
    [self showLeftViewAnimated:self];
}

@end
