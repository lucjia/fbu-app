//
//  Bill.m
//  fbu-app
//
//  Created by sophiakaz on 8/4/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "Bill.h"
#import "Balance.h"

@implementation Bill

@dynamic createdAt;
@dynamic date;
@dynamic payer;
@dynamic debtors;
@dynamic image;
@dynamic memo;
@dynamic portions;
@dynamic paid;

+ (nonnull NSString *)parseClassName {
    return @"Bill";
}

+ (Bill *) createBill:(NSDate *)date billMemo:(NSString *)memo payer:(Persona*)payer totalPaid:(NSDecimalNumber *)paid debtors:(NSArray *)debtors portionLent:(NSArray*)portions image:(UIImage * _Nullable)image withCompletion:(PFBooleanResultBlock  _Nullable)completion {
    
    Bill *newBill = [Bill objectWithClassName:@"Bill"];
    newBill.date = date;
    newBill.memo = memo;
    newBill.payer = payer;
    newBill.paid = paid;
    newBill.debtors = debtors;
    newBill.portions = portions;
    newBill.image = [self getPFFileFromImage:image];
    [newBill save];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0.91), ^{
        // switch to a background thread and perform your expensive operation
        for(int i = 0; i < debtors.count; i++){
            Persona *debtor = debtors[i];
            Balance *balance = [Balance getBalance:payer housemateTwo:debtor];
            [balance addObject:newBill forKey:@"bills"];
            [balance updateBalance:newBill indexOfDebtor:i];
            [balance saveInBackground];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // switch back to the main thread to update your UI
            
        });
    });
    
    return newBill;
}


+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

+ (UIImage *)getImageFromPFFile:(PFFileObject *)file {
    NSData *data = [file getData];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

@end
