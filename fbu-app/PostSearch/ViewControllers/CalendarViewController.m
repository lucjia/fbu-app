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
#import "CreateEventViewController.h"

@interface CalendarViewController () <UICollectionViewDelegate, UICollectionViewDataSource, CreateEventViewControllerDelegate>
{
    UICollectionView *collectionView;
    NSMutableArray *eventsArray; // array of events
    NSDate *eventDate;
    NSInteger currentDay;
    NSInteger currentMonth; // month displayed currently displayed currently on calendar
    NSInteger currentYear; // year displayed currently on calendar
    NSInteger weekday; // weekday of start of month (can be 1 - 7)
    NSDate *numberOfDays; // in month
    NSDate *currentDate; // today
    NSCalendar *calendar;
    NSMutableArray *dayIndexPaths; // index path for cells in calendar
    BOOL addPaths;
    BOOL isOnSameDay;
}

@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    addPaths = YES;
    dayIndexPaths = [[NSMutableArray alloc] init];
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
            self->eventsArray = [NSMutableArray arrayWithArray:events];
            // items are reloaded at indexPath in order to avoid cells being created out of order
            [self->collectionView reloadItemsAtIndexPaths:self->dayIndexPaths];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

// initializes the collection view
- (void)initCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat yPostion = 120;
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, yPostion, self.view.bounds.size.width, self.view.bounds.size.height - yPostion) collectionViewLayout:layout];
    [collectionView setDataSource:self];
    [collectionView setDelegate:self];
    
    // allows for CalendarCell to be used
    [collectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"CalendarCell"];
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    CGFloat postersPerLine = 7; // number of posters in a row
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

// changes currentMonth to next or previous month respectively
- (void)changeMonth:(NSInteger)month toMonth:(NSInteger)change changeBy:(NSInteger)delta {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    // handles cases where next button is pressed with December being current month and where
    // prev button is pressed with January being current month and
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

// checks if array contains an event on the same day as date
- (void)doesArrayContainDateOnSameDay:(NSDate *)date forCell:(CalendarCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row - weekday + 2 != 0) {
        // the check is made on a thread in the background in order to avoid blocking the main thread from running
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0.9), ^{
            // switch to a background thread and perform your expensive operation
            for (int i = 0; i < self->eventsArray.count; i++) {
                // object for is is SYNCHRONOUS
                NSDate *event = [self->eventsArray[i] objectForKey:@"eventDate"];
                if ([self->calendar isDate:date inSameDayAsDate:event]) {
                    self->isOnSameDay = YES;
                    break;
                } else {
                    self->isOnSameDay = NO;
                }
            }
            if (self->isOnSameDay) {
                // all UIKit related calls must be done in main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    // switch back to the main thread to update your UI
                    [cell setHidden:NO];
                    cell.backgroundColor = [UIColor whiteColor];
                    [cell drawEventCircle];
                    
                    if ([self isCellToday:indexPath.row - self->weekday + 2]) {
                        [cell drawCurrentDayCircle];
                    }
                });
            }
        });
    }

}

- (void)didCreateEvent:(Event *)event {
    [eventsArray addObject:event];
    addPaths = NO;
   // [self fetchEvents];
    [self initCollectionView];
    [self initCalendar:[NSDate date]];
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
     UINavigationController *navigationController = [segue destinationViewController];
     CreateEventViewController *createEventViewController = (CreateEventViewController*)navigationController.topViewController;
     createEventViewController.delegate = self;
 }
 

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarCell" forIndexPath:indexPath];
    eventDate = [self dateWithYear:currentYear month:currentMonth day:indexPath.row - weekday + 2];
    // will check in background thread
    [self doesArrayContainDateOnSameDay:eventDate forCell:cell atIndexPath:indexPath];
    
    if (indexPath.item <= weekday - 2) {
        [cell setHidden:YES];
    } else {
        if ([self isCellToday:indexPath.row - weekday + 2]) {
            [cell setHidden:NO];
            cell.backgroundColor = [UIColor whiteColor];
            [cell drawCurrentDayCircle];
            
        } else {
            [cell setHidden:NO];
            cell.backgroundColor = [UIColor whiteColor];
            
        }
    }
    
    // adds date label to content view of cell
    
    [cell initDateLabelInCell:(indexPath.row - weekday + 2) newLabel:YES];
   
   // [cell initDateLabelInCell:(indexPath.row - weekday + 2) newLabel:NO];
    
    if (addPaths){
        [dayIndexPaths addObject:indexPath];
    }
    
    return cell;
}

// returns the number of days in the current month + the day of the week the month starts on - 1 (for indexing starting at 0)
// additional cells are created in order to have cells displayed on the calendar on the correct day of the week. ex: july starts on monday not sunday
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self numberDaysInMonthFromDate:[NSDate date]] + (weekday - 1);
}

@end
