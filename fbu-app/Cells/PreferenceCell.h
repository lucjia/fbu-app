//
//  PreferenceCell.h
//  fbu-app
//
//  Created by lucjia on 7/17/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownPicker.h"

NS_ASSUME_NONNULL_BEGIN

@interface PreferenceCell : UITableViewCell

- (void)updateProperties;
- (NSString*)getChoice;

@property (strong, nonatomic) NSString *preferenceQ;
@property (strong, nonatomic) NSArray *answerArray;
@property (strong, nonatomic) DownPicker *downPicker;
@property (strong, nonatomic) NSString *userChoice;

@end

NS_ASSUME_NONNULL_END
