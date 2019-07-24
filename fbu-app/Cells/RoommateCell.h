//
//  RoommateCell.h
//  fbu-app
//
//  Created by jordan487 on 7/16/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Persona.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RoommateCellDelegate

-(void)showAlertOnTimeline:(UIAlertController *)alert;

@end

@interface RoommateCell : UITableViewCell

- (void)updateProperties:(Persona *)user;
+ (void)sendRequestToPersona:(Persona *)receiverPersona  sender:(Persona *)senderPersona requestsSentToUsers:(NSMutableArray *)requestsSent allertReceiver:(id)receiver;

@property (nonatomic, weak) id<RoommateCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
