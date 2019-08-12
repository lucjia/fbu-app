//
//  BillDetailsViewController.h
//  fbu-app
//
//  Created by sophiakaz on 8/9/19.
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

@interface BillDetailsViewController : UIViewController

@property (strong, nonatomic) Bill *bill;
@property (strong, nonatomic) Balance *balance;
@property (strong, nonatomic) Persona *currentPersona;

@end

NS_ASSUME_NONNULL_END
