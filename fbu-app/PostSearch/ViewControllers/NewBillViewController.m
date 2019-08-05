//
//  NewBillViewController.m
//  fbu-app
//
//  Created by sophiakaz on 8/4/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "NewBillViewController.h"
#import "Bill.h"
#import "Persona.h"

@interface NewBillViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *dateField;
- (IBAction)tapAdd:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *memoField;
@property (weak, nonatomic) IBOutlet UITextField *paidField;

@end

@implementation NewBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.paidField.delegate = self;
    
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)tapAdd:(id)sender {
    NSDecimalNumber *paid = [NSDecimalNumber decimalNumberWithString:self.paidField.text];
    Persona *payer = [PFUser.currentUser objectForKey:@"persona"];
    [payer fetchIfNeeded];
    
    House *house = [House getHouse:payer];
    NSMutableArray *debtors = house.housemates;
    [debtors removeObject:payer];
    
    NSDecimalNumber* numSplit = (NSDecimalNumber*)[NSDecimalNumber numberWithInteger:(debtors.count+1)];
    NSDecimalNumber *portion = [paid decimalNumberByDividingBy:numSplit];
    NSArray *portions = [NSArray array];
    for (int i = 0; i < debtors.count; i++) {
        portions = [portions arrayByAddingObject:portion];
    }
    
    [Bill createBill:self.dateField.date billMemo:self.memoField.text payer:payer totalPaid:paid debtors:debtors portionLent:portions image:nil withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        NSLog(@"new bill created");
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(string.length > 0){
        NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:string];
        
        if (![numbersOnly isSupersetOfSet:characterSetFromTextField]){
            return NO;
        }
        
        NSString *newString = [self.paidField.text stringByReplacingCharactersInRange:range withString:string];
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

@end
