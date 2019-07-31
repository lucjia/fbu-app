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
{
    UICollectionView *collectionView;
    NSArray *eventsArray;
    NSDate *eventDate;
    NSInteger currentDay;
    NSInteger currentMonth;
    NSInteger currentYear;
    NSInteger weekday; // weekday of start of month (can be 1 - 7)
    NSDate *numberOfDays; // in month
    NSDate *currentDate; // today
    NSCalendar *calendar;
}

@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self fetchEvents];
    [self initCollectionView];
    [self initCalendar:[NSDate date]];
    [self setMonthLabelText];
    [collectionView reloadData];
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
            self->eventsArray = events;
           [self initCollectionView];
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
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, yPostion, self.view.bounds.size.width, self.view.bounds.size.height - yPostion) collectionViewLayout:layout];
    [collectionView setDataSource:self];
    [collectionView setDelegate:self];
    
    [collectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"CalendarCell"];
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    CGFloat postersPerLine = 7;
    CGFloat itemWidth = (collectionView.frame.size.width - layout.minimumLineSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = 1.5 * itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    collectionView.contentInsetAdjustmentBehavior = NO;
    
    [self.view addSubview:collectionView];
}

// initialized the calendar
- (void)initCalendar:(NSDate *)date {
    calendar = [NSCalendar currentCalendar];
    // allows for a date to specified in specific units, day, month, year, etc.
    NSDateComponents *dateComponent = [calendar components:NSCalendarUnitCalendar |
                                                                 NSCalendarUnitYear |
                                                                 NSCalendarUnitMonth |
                                                                 NSCalendarUnitDay |
                                                                 NSCalendarUnitWeekday fromDate:date];
    currentMonth = [dateComponent month];
    currentDay = [dateComponent day];
    currentYear = [dateComponent year];
    if (!currentDate) {
        currentDate = [calendar dateFromComponents:dateComponent];
    }

    [self startOfMonthForCalendar:calendar dateComponent:dateComponent];
}

- (void)setMonthLabelText {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *monthName = [[df monthSymbols] objectAtIndex:(currentMonth - 1)];
    NSString *completeString = [NSString stringWithFormat:@"%@ %ld", monthName, currentYear];
    
    self.monthLabel.text = completeString;
}

// finds the first day of the current month and what day of the week it falls on
- (void)startOfMonthForCalendar:(NSCalendar *)calendar dateComponent:(NSDateComponents *)component {
    [component setDay:1];
    [component setMonth:currentMonth];
    [component setYear:currentYear];
    NSDate *startDate = [calendar dateFromComponents:component];
    component = [calendar components:NSCalendarUnitWeekday fromDate:startDate];
    weekday = [component weekday];
}

// returns the number of days in the month for the date passed in
- (NSInteger)numberDaysInMonthFromDate:(NSDate *)date {
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    
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
    
    if (currentMonth == month){
        [comps setDay:1];
        [comps setMonth:change];
        [comps setYear:currentYear + delta];
    } else {
        [comps setDay:1];
        [comps setMonth:currentMonth + delta];
        [comps setYear:currentYear];
    }
    
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    [self initCollectionView];
    [self initCalendar:date];
    [self setMonthLabelText];
    [collectionView reloadData];
}

// checks to see if the cell in the calendar is today
- (BOOL)isCellToday:(NSInteger)date {
    NSDateComponents *dateComponent = [calendar components:NSCalendarUnitCalendar |
                                       NSCalendarUnitYear |
                                       NSCalendarUnitMonth |
                                       NSCalendarUnitDay |
                                       NSCalendarUnitWeekday fromDate:currentDate];
    
    return [dateComponent day] == date &&
           [dateComponent month] == currentMonth &&
           [dateComponent year] == currentYear;
}

- (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    return [calendar dateFromComponents:components];
}

- (BOOL)doesArrayContainDateOnSameDay:(NSArray *)array date:(NSDate *)date {
    for (int i = 0; i < array.count; i++) {
        NSDate *event = [eventsArray[i] objectForKey:@"eventDate"];
        if ([calendar isDate:date inSameDayAsDate:event]) {
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
    eventDate = [self dateWithYear:currentYear month:currentMonth day:indexPath.row - weekday + 2];
    
    if (indexPath.item <= weekday - 2) {
        [cell setHidden:YES];
    } else if ([self doesArrayContainDateOnSameDay:eventsArray date:eventDate]) {
        [cell setHidden:NO];
        cell.backgroundColor = [UIColor whiteColor];
        [cell drawEventCircle];
        
        [cell initDateLabelInCell:(indexPath.row - weekday + 2)];
    } else if ([self isCellToday:indexPath.row - weekday + 2]) {
        [cell setHidden:NO];
        cell.backgroundColor = [UIColor whiteColor];
        [cell drawCurrentDayCircle];
        
        [cell initDateLabelInCell:(indexPath.row - weekday + 2)];
    } else {
        [cell setHidden:NO];
        cell.backgroundColor = [UIColor whiteColor];
        
        [cell initDateLabelInCell:(indexPath.row - weekday + 2)];
    }
    
    return cell;
}

// returns the number of days in the current month + the day of the week the month starts on - 1 (for indexing starting at 0)
// additional cells are created in order to have cells displayed on the calendar on the correct day of the week. ex: july starts on monday not sunday
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self numberDaysInMonthFromDate:[NSDate date]] + (weekday - 1);
}

@end
