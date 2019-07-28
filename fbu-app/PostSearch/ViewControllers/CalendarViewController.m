//
//  CalendarViewController.m
//  fbu-app
//
//  Created by jordan487 on 7/26/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarCell.h"

@interface CalendarViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property NSInteger currentDay;
@property NSInteger currentMonth;
@property NSInteger currentYear;
@property NSInteger weekday; // weekday of start of month
@property (strong, nonatomic) NSDate *numberOfDays; // in month
@property (strong, nonatomic) NSCalendar *calendar;
@property (strong, nonatomic) NSArray *months;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self initCollectionView];
    [self initCalendar];
    [self.collectionView reloadData];
}

- (void)initCollectionView {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    CGFloat postersPerLine = 7;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumLineSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = 1.5 * itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    self.collectionView.contentInsetAdjustmentBehavior = NO;
}

- (void)initCalendar {
    self.calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [self.calendar components:NSCalendarUnitCalendar |
                                                                 NSCalendarUnitYear |
                                                                 NSCalendarUnitMonth |
                                                                 NSCalendarUnitDay |
                                                                 NSCalendarUnitWeekday fromDate:[NSDate date]];
    self.currentMonth = [dateComponent month];
    self.currentDay = [dateComponent day];
    self.currentYear = [dateComponent year];

    [self startOfMonthForCalendar:self.calendar dateComponent:dateComponent];
}

- (void)startOfMonthForCalendar:(NSCalendar *)calendar dateComponent:(NSDateComponents *)component {
    [component setDay:1];
    [component setMonth:self.currentMonth];
    [component setYear:self.currentYear];
    NSDate *startDate = [calendar dateFromComponents:component];
    component = [self.calendar components:NSCalendarUnitWeekday fromDate:startDate];
    self.weekday = [component weekday];
}

- (NSInteger)numberDaysInMonthFromDate:(NSDate *)date {
    NSRange range = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    
    return range.length;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarCell" forIndexPath:indexPath];
    
    [cell updateProperties:3];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self numberDaysInMonthFromDate:[NSDate date]];
}

@end
