//
//  SplitDebtorCell.m
//  fbu-app
//
//  Created by sophiakaz on 8/5/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "SplitDebtorCell.h"

@implementation SplitDebtorCell
@synthesize delegate;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.moneyField.delegate = self;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)tapSwitch:(id)sender {
    
    if([self.debtorSwitch isOn]){
        [self.delegate addDebtor:self.debtor portion:[NSDecimalNumber zero] indexPath:self.indexPath];
    }else{
        [self.delegate removeDebtor:self.debtor indexPath:self.indexPath];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if([self.debtorSwitch isOn]){
        if(string.length > 0){
            NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
            NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:string];
            
            if (![numbersOnly isSupersetOfSet:characterSetFromTextField]){
                return NO;
            }
            
            NSString *newString = [self.moneyField.text stringByReplacingCharactersInRange:range withString:string];
            NSArray *arrayOfString = [newString componentsSeparatedByString:@"."];
            if ([arrayOfString count] > 2)
                return NO;
            else if ([arrayOfString count] == 2){
                if([arrayOfString[1] length] > 2)
                    return NO;
            }
        }
        return YES;
    }
    else{
        return NO;
    }
}

@end
