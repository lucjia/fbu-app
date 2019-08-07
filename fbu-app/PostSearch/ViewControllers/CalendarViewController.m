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
#import "EventReminderCell.h"
#import "EventDetailsViewController.h"
#import <LGSideMenuController/LGSideMenuController.h>
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>
#import "CustomColor.h"

@interface CalendarViewController () <UICollectionViewDelegate, UICollectionViewDataSource, CreateEventViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    // Collection view instance variables
    UICollectionView *collectionView;
    NSMutableArray *eventsArray; // array of events
    NSDate *eventDate;
    NSInteger currentDay;
    NSInteger currentMonth; // month displayed currently displayed currently on calendar
    NSInteger currentYear; // year displayed currently on calendar
    NSInteger monthStartweekday; // weekday of start of month (can be 1 - 7)
    NSUInteger numberOfDays; // in month
    NSDate *currentDate; // today
    NSDate *displayedMonthStartDate;
    NSDate *weekStartDate;
    NSDate *WeekEndDate;
    NSInteger weekStart;
    NSCalendar *calendar;
    NSMutableArray *dayIndexPaths; // index path for cells in calendar
    CalendarCell *selectedCell; // the cell the user has most recently tapped
    CGFloat cellWidth;
    double calendarHeight;
    double calendarYPosition;
    BOOL addPaths; // should index paths of cells continue to be added to dayIndexPaths
    BOOL isOnSameDay; // are two dates on the same aay
    BOOL isInWeeklyMode;
    
    // Table view instance variables
    UITableView *tableView;
    NSMutableArray *eventsForSelectedDay; // events that occur on the most recently tapped cell
    
    // Month and day Labels
    UILabel *sundayLabel;
    UILabel *mondayLabel;
    UILabel *tuesdayLabel;
    UILabel *wednesdayLabel;
    UILabel *thursdayLabel;
    UILabel *fridayLabel;
    UILabel *saturdayLabel;
}

@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[CustomColor darkMainColor:1.0]];
    
    addPaths = YES;
    dayIndexPaths = [[NSMutableArray alloc] init];
    
    Persona *persona = [PFUser currentUser][@"persona"];
    [persona fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if ([object objectForKey:@"house"]) {
            [self fetchEvents:(Persona *)object];
            [self initCollectionView];
            [self initCalendar:[NSDate date]];
            [self setMonthLabelText];
            [self->collectionView reloadData];
            [self initDayLabels];
        }
    }];
    
    [self initSwipeGestureRecognizers];
}

- (void)fetchEvents:(Persona *)persona {
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    
    [query whereKey:@"house" equalTo:[persona objectForKey:@"house"]];
    [query orderByAscending:@"eventDate"];
    [query includeKey:@"title"];
    [query includeKey:@"memo"];
    [query includeKey:@"eventDate"];
    [query includeKey:@"isAllDay"];
    [query includeKey:@"house"];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *events, NSError *error) {
        if (events != nil) {
            // do something with the array of object returned by the call
            self->eventsArray = [NSMutableArray arrayWithArray:events];
            // items are reloaded at indexPath in order to avoid cells being created out of order
            [self->collectionView reloadItemsAtIndexPaths:self->dayIndexPaths];
            [self initTableView];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)initLabel:(UILabel *)label xPos:(NSInteger)labelX yPos:(NSInteger)labelY withText:(NSString *)text {
    label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, 94 + labelY, 50, 50)];
    label.text = text;
    label.textColor = [CustomColor midToneOne:1.0];
    
    [self.view addSubview:label];
}

- (void)initDayLabels {
    CGFloat spacing = 6;
    CGFloat labelY = self.monthLabel.frame.size.height;
    
    CGFloat sundayX = cellWidth / 4;
    [self initLabel:sundayLabel xPos:sundayX yPos:labelY withText:@"Su"];

    CGFloat mondayX = sundayX + cellWidth + spacing;
    [self initLabel:mondayLabel xPos:mondayX yPos:labelY withText:@"Mo"];
    
    CGFloat tuesdayX = mondayX + cellWidth + spacing;
    [self initLabel:tuesdayLabel xPos:tuesdayX yPos:labelY withText:@"Tu"];
    
    CGFloat wednesdayX = tuesdayX + cellWidth + spacing;
    [self initLabel:wednesdayLabel xPos:wednesdayX yPos:labelY withText:@"We"];
    
    CGFloat thursdayX = wednesdayX + cellWidth + spacing;
    [self initLabel:thursdayLabel xPos:thursdayX yPos:labelY withText:@"Th"];
    
    CGFloat fridayX = thursdayX + cellWidth + spacing;
    [self initLabel:fridayLabel xPos:fridayX yPos:labelY withText:@"Fr"];
    
    CGFloat saturdayX = fridayX + cellWidth + spacing;
    [self initLabel:saturdayLabel xPos:saturdayX yPos:labelY withText:@"Sa"];
}

// initializes the collection view
- (void)initCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    calendarYPosition = 160;
    calendarHeight = isInWeeklyMode ? 94 + self.monthLabel.frame.size.height + 20 : (self.view.bounds.size.height - calendarYPosition) / 2;
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, calendarYPosition, self.view.bounds.size.width, calendarHeight) collectionViewLayout:layout];
    [collectionView setDataSource:self];
    [collectionView setDelegate:self];
    
    // allows for CalendarCell to be used
    [collectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"CalendarCell"];
    [collectionView setBackgroundColor:[CustomColor darkMainColor:1.0]];
    
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    CGFloat postersPerLine = 7; // number of posters in a row
    CGFloat itemWidth = (collectionView.frame.size.width - layout.minimumLineSpacing * (postersPerLine - 1)) / postersPerLine;
    cellWidth = itemWidth;
    CGFloat itemHeight = 1 * itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    collectionView.contentInsetAdjustmentBehavior = NO;
    
    [self.view addSubview:collectionView];
}

- (void)initSwipeGestureRecognizers {
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(didSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(didSwipe:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(didSwipe:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
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
    monthStartweekday = [component weekday];
    displayedMonthStartDate = startDate;
}

// returns the number of days in the month for the date passed in
- (NSUInteger)numberDaysInMonthFromDate:(NSDate *)date {
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    numberOfDays = range.length;
    return numberOfDays;
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
    
    [collectionView removeFromSuperview];
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
    [components setHour:0];
    
    return [calendar dateFromComponents:components];
}

// checks if array contains an event on the same day as date
- (void)doesArrayContainDateOnSameDay:(NSDate *)date forCell:(CalendarCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row - monthStartweekday + 2 > 0 && indexPath.row - monthStartweekday + 2 < 32) {
        // the check is made on a thread in the background in order to avoid blocking the main thread from running
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0.9), ^{
            // switch to a background thread and perform your expensive operation
            for (int i = 0; i < self->eventsArray.count; i++) {
                // object for is is SYNCHRONOUS
                NSDate *eventStart = [self->eventsArray[i] objectForKey:@"eventDate"];
                if ([self->calendar isDate:date inSameDayAsDate:eventStart] || [self->eventsArray[i] isDateBetweenEventStartAndEndDates:date]) {
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
                    [cell drawEventCircle];
                    
                    if ([self isCellToday:indexPath.row - self->monthStartweekday + 2]) {
                        [cell setCurrentDayTextColor];
                    }
                });
            }
        });
    }
    
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self changeMonth:12 toMonth:1 changeBy:1];
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        [self changeMonth:1 toMonth:12 changeBy:-1];
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionUp && !isInWeeklyMode) {
        NSLog(@"ee");
        weekStart = [calendar component:NSCalendarUnitDay fromDate:displayedMonthStartDate];
        isInWeeklyMode = YES;
        [collectionView removeFromSuperview];
        [self initCollectionView];
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionDown && isInWeeklyMode) {
        NSLog(@"yy");
        isInWeeklyMode = NO;
        [collectionView removeFromSuperview];
        [self initCollectionView];
    }
}

- (IBAction)didTapNextWeek:(id)sender {
    [collectionView removeFromSuperview];
    [self initCollectionView];
}

- (void)changeWeek {
    
}

- (void)didCreateEvent:(Event *)event {
    [eventsArray addObject:event];
    addPaths = NO;
    // [self fetchEvents];
    [self initCollectionView];
    [self initCalendar:[NSDate date]];
    // sorts the array by eventDate in order to maintain order
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"eventDate"
                                                 ascending:YES];
    eventsArray = [NSMutableArray arrayWithArray:[eventsArray sortedArrayUsingDescriptors:@[sortDescriptor]]];
    [tableView reloadData];
}

- (IBAction)didTapToday:(id)sender {
    NSDateComponents *dateComponent = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger year = [dateComponent year];
    [self changeMonth:currentMonth toMonth:[dateComponent month] changeBy:currentYear == year ? 0 : year - currentYear];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = [segue destinationViewController];
    CreateEventViewController *createEventViewController = (CreateEventViewController*)navigationController.topViewController;
    createEventViewController.delegate = self;
    
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarCell" forIndexPath:indexPath];
    
    if (!isInWeeklyMode) {
        eventDate = [self dateWithYear:currentYear month:currentMonth day:indexPath.row - monthStartweekday + 2];
        // will check in background thread
        [self doesArrayContainDateOnSameDay:eventDate forCell:cell atIndexPath:indexPath];
        
        if (indexPath.item <= monthStartweekday - 2 || indexPath.row - monthStartweekday + 2 > numberOfDays) {
            [cell setHidden:YES];
        } else {
            if ([self isCellToday:indexPath.row - monthStartweekday + 2]) {
                [cell setHidden:NO];
                [cell setCurrentDayTextColor];
                
            } else {
                [cell setHidden:NO];
            }
        }
    } else {
        eventDate = [self dateWithYear:currentYear month:currentMonth day:weekStart];
        // will check in background thread
        [self doesArrayContainDateOnSameDay:eventDate forCell:cell atIndexPath:indexPath];
        NSInteger fistDayOfWeekOfMonth = [calendar component:NSCalendarUnitWeekday fromDate:displayedMonthStartDate];
        if ([eventDate compare:displayedMonthStartDate] == 0 && indexPath.item < fistDayOfWeekOfMonth - 1) {
            [cell setHidden:YES];
        } else {
            if ([self isCellToday:indexPath.row - monthStartweekday + 2]) {
                [cell setHidden:NO];
                [cell setCurrentDayTextColor];
                [cell initDateLabelInCell:(weekStart++) newLabel:YES];
            } else {
                [cell setHidden:NO];
                [cell initDateLabelInCell:(weekStart++) newLabel:YES];
            }
        }
    }
    
    if (cell.selected) {
        [cell colorSelectedCell]; // highlight selection
    }
    
    if (isInWeeklyMode) {
        if ([eventDate compare:displayedMonthStartDate] >= 0) {
            weekStartDate = weekStartDate == nil ? [[NSDate alloc] init] : weekStartDate;
            weekStartDate = [eventDate compare:weekStartDate] < 0 ? eventDate : weekStartDate;
        }
        WeekEndDate = eventDate;
    }
    
    // adds date label to content view of cell
    if (isInWeeklyMode) {
        
    } else {
        [cell initDateLabelInCell:(indexPath.row - monthStartweekday + 2) newLabel:YES];
    }
    
    if (addPaths){
        [dayIndexPaths addObject:indexPath];
    }
    
    return cell;
}

// returns the number of days in the current month + the day of the week the month starts on - 1 (for indexing starting at 0)
// additional cells are created in order to have cells displayed on the calendar on the correct day of the week. ex: july starts on monday not sunday
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return isInWeeklyMode ? 7 : [self numberDaysInMonthFromDate:displayedMonthStartDate] + (monthStartweekday - 1);
}

// called when a CalendarCell is tapped
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    selectedCell = (CalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [selectedCell colorSelectedCell];
    [self filterArrayForSelectedDate];
    if (eventsForSelectedDay > 0) {
        [tableView removeFromSuperview];
        [tableView setHidden:NO];
        [self initTableView];
    } else {
        [tableView setHidden:YES];
    }
}

// called when a different CalendarCell is tapped
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    [selectedCell decolorSelectedCell];
}

/***********************************
 Table View of Reminders and Events
 ***********************************/

//initializes tableView underneath calendar
- (void)initTableView {
    if (eventsForSelectedDay > 0) {
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, calendarHeight + calendarYPosition, self.view.frame.size.width, self.view.frame.size.height - (calendarHeight + calendarYPosition)) style:UITableViewStylePlain];
        [tableView setDataSource:self];
        [tableView setDelegate:self];
        
        [tableView setBackgroundColor:[CustomColor darkMainColor:1.0]];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [tableView registerClass:[EventReminderCell class] forCellReuseIdentifier:@"EventReminderCell"];
        [tableView setShowsVerticalScrollIndicator:NO];
        tableView.translatesAutoresizingMaskIntoConstraints = NO;
        tableView.rowHeight = UITableViewAutomaticDimension;
        
        [self.view addSubview:tableView];
        [self updateTableViewConstraints];
    }
}

- (void)updateTableViewConstraints {
    // Left
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:tableView
                              attribute:NSLayoutAttributeTrailing
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeTrailing
                              multiplier:1.0f
                              constant:0.f]];
    // Right
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:tableView
                              attribute:NSLayoutAttributeLeading
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeLeading
                              multiplier:1.0f
                              constant:0.f]];
    // Top
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:tableView
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:collectionView
                              attribute:NSLayoutAttributeBottom
                              multiplier:1.0f
                              constant:0.f]];
    // Bottom
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:tableView
                              attribute:NSLayoutAttributeBottom
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeBottom
                              multiplier:1.0f
                              constant:0.f]];
}

- (void)filterArrayForSelectedDate {
    NSInteger day = [selectedCell.dateLabel.text intValue];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    [comps setMonth:currentMonth];
    [comps setYear:currentYear];
    [comps setHour:0];
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventDate >= %@", date];
    eventsForSelectedDay = [NSMutableArray arrayWithArray:[eventsArray filteredArrayUsingPredicate:predicate]];
    
    [comps setDay:day + 1];
    [comps setMonth:currentMonth];
    [comps setYear:currentYear];
    [comps setHour:0];
    date = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    predicate = [NSPredicate predicateWithFormat:@"eventDate <= %@", date];
    eventsForSelectedDay = [NSMutableArray arrayWithArray:[eventsForSelectedDay filteredArrayUsingPredicate:predicate]];
    
    [comps setDay:day];
    date = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    for (Event *event in eventsArray) {
        if([event isDateBetweenEventStartAndEndDates:date]) {
            [eventsForSelectedDay addObject:event];
        }
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"eventDate"
                                                 ascending:YES];
    eventsForSelectedDay = [NSMutableArray arrayWithArray:[eventsForSelectedDay sortedArrayUsingDescriptors:@[sortDescriptor]]];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"EvemtReminderCell";
    EventReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (!cell) {
        cell = [[EventReminderCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    [cell initCellWithEvent:eventsForSelectedDay[indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return eventsForSelectedDay.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Event *event = eventsForSelectedDay[indexPath.row];
    
    EventDetailsViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetailsViewController"];
    viewController.event = event;

    [self.navigationController pushViewController:viewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 100;
}

- (IBAction)didTapPostLeftMenu:(id)sender {
    [self showLeftViewAnimated:self];
}

@end
