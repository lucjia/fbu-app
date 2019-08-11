//
//  PaymentViewController.m
//  fbu-app
//
//  Created by sophiakaz on 8/8/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "PaymentViewController.h"
#import "CustomColor.h"

@interface PaymentViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *moneyField;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *housemateView;
@property (weak, nonatomic) IBOutlet UIImageView *userView;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
- (IBAction)tapRecordPayment:(id)sender;


@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.moneyField.delegate = self;
    
    self.moneyField.text = [self formatCurrency:[NSDecimalNumber zero]];
    self.textLabel.text = [@"You paid " stringByAppendingString:[self getName:self.housemate]];
    
    self.recordButton.layer.cornerRadius = 5;
    self.recordButton.layer.masksToBounds = YES;
    
    
    PFFileObject *imageFile = self.housemate.profileImage;
    [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            self.housemateView.image = [UIImage imageWithData:data];
        }
    }];
    self.housemateView.layer.cornerRadius = self.housemateView.frame.size.height /2;
    self.housemateView.layer.masksToBounds = YES;
    
    PFFileObject *imageFile2 = self.currentPersona.profileImage;
    [imageFile2 getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            self.userView.image = [UIImage imageWithData:data];
        }
    }];
    self.userView.layer.cornerRadius = self.userView.frame.size.height /2;
    self.userView.layer.masksToBounds = YES;
    
}



- (NSDecimalNumber*)getPaid {
    if ([self.moneyField.text length] > 1){
        return [NSDecimalNumber decimalNumberWithString:[self.moneyField.text substringFromIndex:1]];
    }else{
        return [NSDecimalNumber zero];
    }
}

- (NSString *) formatCurrency:(NSDecimalNumber*)money {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    return [numberFormatter stringFromNumber:money];
}

- (NSString *) getName:(Persona*)persona {
    if([persona isEqual:[PFUser.currentUser objectForKey:@"persona"]]){
        return @"You";
    }else{
        return [[persona.firstName stringByAppendingString:@" "] stringByAppendingString:persona.lastName];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(range.location == 0){
        return NO;
    }
    else if(string.length > 0){
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


- (IBAction)tapRecordPayment:(id)sender {
    
    if (self.moneyField.text.length > 1) {
        
        NSDecimalNumber *paid = [self getPaid];
        
        NSArray *debtors = [[NSArray alloc] initWithObjects:self.housemate, nil];
        NSArray *portions = [[NSArray alloc] initWithObjects:paid, nil];
        NSString *memo = @"Payment";
        
        [Bill createBill:[NSDate date] billMemo:memo payer:self.currentPersona totalPaid:paid debtors:debtors portionLent:portions image:nil isPayment:YES withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        }];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
