//
//  CalendarViewController.m
//  fbu-app
//
//  Created by jordan487 on 7/26/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarCell.h"
#import <Parse/Parse.h>
#import "Event.h"

@interface CalendarViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property NSInteger currentDay;
@property NSInteger currentMonth;
@property NSInteger currentYear;
@property NSInteger weekday; // weekday of start of month (can be 1 - 7)
@property (strong, nonatomic) NSDate *numberOfDays; // in month
@property (strong, nonatomic) NSDate *currentDate; // today
@property (strong, nonatomic) NSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *eventsArray;
@property (strong, nonatomic) NSDate *eventDate;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self fetchEvents];
    [self initCollectionView];
    [self initCalendar:[NSDate date]];
    [self setMonthLabelText];
    [self.collectionView reloadData];
}

- (void)fetchEvents {
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"title"];
    [query includeKey:@"memo"];
    [query includeKey:@"eventDate"];
    [query includeKey:@"isAllDay"];
    [query includeKey:@"house"];
    
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *events, NSError *error) {
        if (events != nil) {
            // do something with the array of object returned by the call
            self.eventsArray = events;
           [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)colorCellForEvent:(CalendarCell *)cell {
    
}

// initializes the collection view
- (void)initCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat yPostion = 120;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, yPostion, self.view.bounds.size.width, self.view.bounds.size.height - yPostion) collectionViewLayout:layout];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    
    [self.collectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"CalendarCell"];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    
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
- (void)initCalendar:(NSDate *)date {
    self.calendar = [NSCalendar currentCalendar];
    // allows for a date to specified in specific units, day, month, year, etc.
    NSDateComponents *dateComponent = [self.calendar components:NSCalendarUnitCalendar |
                                                                 NSCalendarUnitYear |
                                                                 NSCalendarUnitMonth |
                                                                 NSCalendarUnitDay |
                                                                 NSCalendarUnitWeekday fromDate:date];
    self.currentMonth = [dateComponent month];
    self.currentDay = [dateComponent day];
    self.currentYear = [dateComponent year];
    if (!self.currentDate) {
        self.currentDate = [self.calendar dateFromComponents:dateComponent];
    }

    [self startOfMonthForCalendar:self.calendar dateComponent:dateComponent];
}

- (void)setMonthLabelText {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *monthName = [[df monthSymbols] objectAtIndex:(self.currentMonth - 1)];
    NSString *completeString = [NSString stringWithFormat:@"%@ %ld", monthName, self.currentYear];
    
    self.monthLabel.text = completeString;
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

- (IBAction)didTapNextMonth:(id)sender {
    [self changeMonth:12 toMonth:1 changeBy:1];
}

- (IBAction)didTapPreviousMonth:(id)sender {
    [self changeMonth:1 toMonth:12 changeBy:-1];
}

- (void)changeMonth:(NSInteger)month toMonth:(NSInteger)change changeBy:(NSInteger)delta {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    if (self.currentMonth == month){
        [comps setDay:1];
        [comps setMonth:change];
        [comps setYear:self.currentYear + delta];
    } else {
        [comps setDay:1];
        [comps setMonth:self.currentMonth + delta];
        [comps setYear:self.currentYear];
    }
    
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    [self initCollectionView];
    [self initCalendar:date];
    [self setMonthLabelText];
    [self.collectionView reloadData];
}

// checks to see if the cell in the calendar is today
- (BOOL)isCellToday:(NSInteger)date {
    NSDateComponents *dateComponent = [self.calendar components:NSCalendarUnitCalendar |
                                       NSCalendarUnitYear |
                                       NSCalendarUnitMonth |
                                       NSCalendarUnitDay |
                                       NSCalendarUnitWeekday fromDate:self.currentDate];
    
    return [dateComponent day] == date &&
           [dateComponent month] == self.currentMonth &&
           [dateComponent year] == self.currentYear;
}

- (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    return [self.calendar dateFromComponents:components];
}

- (BOOL)doesArrayContainDateOnSameDay:(NSArray *)array date:(NSDate *)date {
    for (int i = 0; i < array.count; i++) {
        NSDate *event = [self.eventsArray[i] objectForKey:@"eventDate"];
        if ([self.calendar isDate:date inSameDayAsDate:event]) {
            return YES;
        }
    }
    
    return NO;
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
    self.eventDate = [self dateWithYear:self.currentYear month:self.currentMonth day:indexPath.row - self.weekday + 2];
    
    if (indexPath.item <= self.weekday - 2) {
        [cell setHidden:YES];
    } else if ([self doesArrayContainDateOnSameDay:self.eventsArray date:self.eventDate]) {
        [cell setHidden:NO];
        cell.backgroundColor = [UIColor blueColor];
        
        [cell initDateLabelInCell:(indexPath.row - self.weekday + 2)];
    } else if ([self isCellToday:indexPath.row - self.weekday + 2]) {
        [cell setHidden:NO];
        cell.backgroundColor = [UIColor redColor];
        
        [cell initDateLabelInCell:(indexPath.row - self.weekday + 2)];
    } else {
        [cell setHidden:NO];
        cell.backgroundColor = [UIColor whiteColor];
        
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
