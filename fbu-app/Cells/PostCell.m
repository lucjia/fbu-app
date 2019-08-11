//
//  PostCell.m
//  fbu-app
//
//  Created by lucjia on 8/4/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "PostCell.h"
#import "Persona.h"
#import "Accessibility.h"

@implementation PostCell

- (void) setCell {
    Persona *sender = [self.post objectForKey:@"postSender"];
    self.posterLabel.text = [[sender.firstName stringByAppendingString:@" "] stringByAppendingString:sender.lastName];
    
    self.textLabel.text = [self.post objectForKey:@"postText"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE, MMMM d, yyyy h:mm a"];
    NSString *dateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:self.post.createdAt]];
    self.dateLabel.text = dateString;
    
    PFFileObject *imageFile = sender.profileImage;
    [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            self.postImage.image = [UIImage imageWithData:data];
            self.postImage.layer.cornerRadius = self.postImage.frame.size.height / 2;
            self.postImage.layer.masksToBounds = YES;
        }
    }];
    
    // large text
    [Accessibility largeTextCompatibilityWithLabel:self.posterLabel style:UIFontTextStyleTitle3];
    [Accessibility largeTextCompatibilityWithLabel:self.textLabel style:UIFontTextStyleBody];
    [Accessibility largeTextCompatibilityWithLabel:self.dateLabel style:UIFontTextStyleFootnote];
    
    // shadow
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2.0f);
    self.layer.shadowRadius = 2.0f;
    self.layer.shadowOpacity = 0.8f;
    self.layer.masksToBounds = NO;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.contentView.layer.cornerRadius].CGPath;
}

@end
