//
//  SplitDebtorCell.m
//  fbu-app
//
//  Created by sophiakaz on 8/5/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "SplitDebtorCell.h"

@implementation SplitDebtorCell


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
        self.backgroundColor = [UIColor clearColor];
        self.moneyField.backgroundColor = [UIColor clearColor];
        [self.delegate addDebtor:self.debtor portion:[NSDecimalNumber decimalNumberWithString:self.moneyField.text]];
    }else{
        [self.delegate removeDebtor:self.debtor];
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.moneyField.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.moneyField.text = @"";
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
