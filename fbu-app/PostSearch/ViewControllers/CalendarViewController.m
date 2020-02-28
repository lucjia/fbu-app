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
@property NSInteger weekday; // weekday of start of month (can be 1 - 7)
@property (strong, nonatomic) NSDate *numberOfDays; // in month
@property (strong, nonatomic) NSCalendar *calendar;
@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initCollectionView];
    [self initCalendar];
    [self.collectionView reloadData];
}

// initializes the collection view
- (void)initCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat yPostion = 120;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, yPostion, self.view.bounds.size.width, self.view.bounds.size.height - yPostion) collectionViewLayout:layout];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    
    [self.collectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"CalendarCell"];
    [self.collectionView setBackgroundColor:[UIColor redColor]];
    
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    CGFloat postersPerLine = 7;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumLineSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = 1.5 * itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    self.collectionView.contentInsetAdjustmentBehavior = NO;
    
    [self.view addSubview:self.collectionView];
}

// initialized the calendar
- (void)initCalendar {
    self.calendar = [NSCalendar currentCalendar];
    // allows for a date to specified in specific units, day, month, year, etc.
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

// finds the first day of the current month and what day of the week it falls on
- (void)startOfMonthForCalendar:(NSCalendar *)calendar dateComponent:(NSDateComponents *)component {
    [component setDay:1];
    [component setMonth:self.currentMonth];
    [component setYear:self.currentYear];
    NSDate *startDate = [calendar dateFromComponents:component];
    component = [self.calendar components:NSCalendarUnitWeekday fromDate:startDate];
    self.weekday = [component weekday];
}

// returns the number of days in the month for the date passed in
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
        
    if (indexPath.item <= self.weekday - 2) {
        [cell setHidden:YES];
    } else {
        [cell setHidden:NO];
        cell.backgroundColor = [UIColor greenColor];
        
        [cell initDateLabelInCell:(indexPath.row - self.weekday + 2)];
    }
    
    return cell;
}

// returns the number of days in the current month + the day of the week the month starts on - 1 (for indexing starting at 0)
// additional cells are created in order to have cells displayed on the calendar on the correct day of the week. ex: july starts on monday not sunday
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self numberDaysInMonthFromDate:[NSDate date]] + (self.weekday - 1);
}

@end
