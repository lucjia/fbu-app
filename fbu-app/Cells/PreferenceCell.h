//
//  PreferenceCell.h
//  fbu-app
//
//  Created by lucjia on 7/17/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PreferenceCell : UITableViewCell

- (void)updateProperties;

@property (strong, nonatomic) NSString *preferenceQ;
@property (strong, nonatomic) NSString *preferenceA;
@property (strong, nonatomic) NSArray *answerArray;

@end

NS_ASSUME_NONNULL_END
