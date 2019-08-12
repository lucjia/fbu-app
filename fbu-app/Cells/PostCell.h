//
//  PostCell.h
//  fbu-app
//
//  Created by lucjia on 8/4/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PostCellDelegate

- (void) deletePost:(Post *)post;

@end

@interface PostCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *posterLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) Post *post;

@property (nonatomic, weak) id<PostCellDelegate> delegate;

- (void) setCell;

@end

NS_ASSUME_NONNULL_END
