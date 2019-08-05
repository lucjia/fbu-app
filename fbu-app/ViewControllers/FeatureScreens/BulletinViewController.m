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

@interface BulletinViewController () <UICollectionViewDelegate, UICollectionViewDataSource> {
    NSMutableArray *posts;
}

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation BulletinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set background image
    self.backgroundImage.image = [UIImage imageNamed:@"corkboard"];
    self.backgroundImage.clipsToBounds = YES;
    self.backgroundImage.alpha = 0.8;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
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

@end
