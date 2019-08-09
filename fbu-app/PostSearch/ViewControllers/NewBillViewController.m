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
#import "ChangeSplitViewController.h"
#import "Parse/Parse.h"


@interface NewBillViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ChangeSplitViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *memoField;
@property (weak, nonatomic) IBOutlet UITextField *paidField;
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
- (IBAction)tapAddBill:(id)sender;
@property (strong, nonatomic) IBOutlet NSMutableArray* debtors;
@property (strong, nonatomic) IBOutlet NSMutableArray* portions;
@property (strong, nonatomic) IBOutlet NSMutableArray* housemates;
@property (strong, nonatomic) IBOutlet Persona* payer;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (strong, nonatomic) NSDate *date;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *dateView;
- (IBAction)tapDateField:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *payerButton;
@property (weak, nonatomic) IBOutlet UIButton *debtorsButton;
@property (strong,nonatomic) NSMutableArray* possibleDebtors;
- (IBAction)tapDateDone:(id)sender;
- (IBAction)tapPayerDone:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *payerView;
- (IBAction)changePayer:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *payerPicker;


@end

@implementation NewBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.payerPicker.delegate = self;
    self.payerPicker.dataSource = self;
    
    self.paidField.delegate = self;
    
    self.payer = [PFUser.currentUser objectForKey:@"persona"];
    [self.payer fetchIfNeeded];
    
    [self fetchpossibleDebtors];
    self.debtors = [self.possibleDebtors mutableCopy];
    
    self.dateField.text = [self formatDate:[NSDate date]];
    self.date = [NSDate date];
    
    self.paidField.text = [self formatCurrency:[NSDecimalNumber zero]];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self fetchpossibleDebtors];
    [self.payerButton setTitle:[self getName:self.payer] forState:UIControlStateNormal];
    NSMutableArray *debtorNames = [[NSMutableArray alloc] init];
    for(Persona *debtor in self.debtors) {
        [debtorNames addObject:[self getName:debtor]];
    }
    [self.debtorsButton setTitle:[debtorNames componentsJoinedByString:@", "] forState:UIControlStateNormal];
}

- (void) fetchpossibleDebtors {
    Persona *persona = [PFUser.currentUser objectForKey:@"persona"];
    [persona fetchIfNeeded];
    House *house = [House getHouse:persona];
    self.housemates = [house objectForKey:@"housemates"];
    for(Persona* housemate in self.housemates){
        [housemate fetchIfNeeded];
    }
    self.possibleDebtors = [self.housemates mutableCopy];
    [self.possibleDebtors removeObject:self.payer];
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

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}



- (IBAction)tapAddImage:(id)sender {
    
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Do something with the images (based on your use case)
    editedImage = [self resizeImage:editedImage
                           withSize:CGSizeMake(200, 200)];
    [self.pictureView setImage:editedImage];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)tapAddBill:(id)sender {
    
    [self getPortions];
    
    if (self.paidField.text.length > 1 && (self.memoField.text && self.memoField.text.length > 0)) {
        
        [Bill createBill:self.date billMemo:self.memoField.text payer:self.payer totalPaid:[self getPaid] debtors:self.debtors portionLent:self.portions image:self.pictureView.image isPayment:NO withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        }];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (void)changeSplit:(Persona *)payer debtors:(NSMutableArray*)debtors portions:(NSMutableArray*)portions{
    self.payer = payer;
    self.debtors = debtors;
    self.portions = portions;
    
}

- (NSDecimalNumber*)getPaid {
    if ([self.paidField.text length] > 1){
        return [NSDecimalNumber decimalNumberWithString:[self.paidField.text substringFromIndex:1]];
    }else{
        return [NSDecimalNumber zero];
    }
}


- (IBAction)tapDateField:(id)sender {
    [self.dateView setHidden:NO];
}


- (NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

- (void) getPortions {
    if(self.portions == nil){
        NSDecimalNumber* numSplit = (NSDecimalNumber*)[NSDecimalNumber numberWithInteger:(self.debtors.count+1)];
        NSDecimalNumber *portion = [[self getPaid] decimalNumberByDividingBy:numSplit];
        self.portions = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.debtors.count; i++) {
            [self.portions addObject:portion];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self getPortions];
    
    ChangeSplitViewController *controller = (ChangeSplitViewController *)segue.destinationViewController;
    controller.delegate = self;
    controller.debtors = self.debtors;
    controller.portions = self.portions;
    controller.payer = self.payer;
    controller.paid = [self getPaid];
    controller.possibleDebtors = self.possibleDebtors;
    
}

- (IBAction)tapDateDone:(id)sender {
    [self.dateView setHidden:YES];
    self.date = self.datePicker.date;
    self.dateField.text = [self formatDate:self.datePicker.date];
}

- (NSString *) formatCurrency:(NSDecimalNumber*)money {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    return [numberFormatter stringFromNumber:money];
}


- (IBAction)tapPayerDone:(id)sender {
    [self.payerView setHidden:YES];
    [self fetchpossibleDebtors];
    self.debtors = [self.possibleDebtors mutableCopy];
    self.portions = nil;
    [self viewWillAppear:YES];
    
}

- (IBAction)changePayer:(id)sender {
    [self.payerView setHidden:NO];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView
numberOfRowsInComponent:(NSInteger)component {
    return self.housemates.count;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    Persona *housemate = self.housemates[row];
    return [self getName:housemate];
}

- (void)pickerView:(UIPickerView *)thePickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    Persona *housemate = self.housemates[row];
    self.payer = housemate;
    [self.payerButton setTitle:[self getName:self.payer] forState:UIControlStateNormal];
}

@end
