//
//  SplitDebtorCell.h
//  fbu-app
//
//  Created by sophiakaz on 8/5/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Persona.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SplitDebtorCellDelegate
- (void)addDebtor:(Persona*)debtor portion:(NSDecimalNumber*)portion indexPath:(NSIndexPath*)indexPath;
- (void)removeDebtor:(Persona*)debtor indexPath:(NSIndexPath*)indexPath;
@end

@interface SplitDebtorCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyField;
- (IBAction)tapSwitch:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *debtorSwitch;
@property (nonatomic, weak) id<SplitDebtorCellDelegate> delegate;
@property (nonatomic, strong) Persona* debtor;
@property (nonatomic, strong) NSIndexPath* indexPath;

@end

NS_ASSUME_NONNULL_END
