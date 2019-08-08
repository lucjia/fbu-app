//
//  BalanceDetailsViewController.h
//  fbu-app
//
//  Created by sophiakaz on 8/7/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillCell.h"
#import "Persona.h"
#import "Parse/Parse.h"
#import "House.h"
#import "Bill.h"
#import "Balance.h"

NS_ASSUME_NONNULL_BEGIN

@interface BalanceDetailsViewController : UIViewController

@property (strong, nonatomic) NSArray *bills;
@property (strong, nonatomic) Persona *housemate;
@property (strong, nonatomic) Persona *currentPersona;
@property (strong, nonatomic) Balance *balance;

@end

NS_ASSUME_NONNULL_END
