//
//  EditTripViewController.m
//  SmartReceipts
//
//  Created on 17/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "EditTripViewController.h"
#import "WBTrip.h"
#import "WBPreferences.h"
#import "WBAutocompleteHelper.h"
#import "WBCustomization.h"
#import "TitledAutocompleteEntryCell.h"
#import "UIView+LoadHelpers.h"
#import "UITableViewCell+Identifier.h"
#import "InputCellsSection.h"
#import "UIApplication+DismissKeyboard.h"
#import "PickerCell.h"
#import "ProperNameInputValidation.h"
#import "NSString+Validation.h"
#import "InlinedDatePickerCell.h"
#import "Pickable.h"
#import "StringPickableWrapper.h"
#import "Database+Trips.h"
#import "NSDate+Calculations.h"
#import "SmartReceipts-Swift.h"

@interface EditTripViewController ()

@property (nonatomic, strong) WBDateFormatter *dateFormatter;
@property (nonatomic, strong) TitledAutocompleteEntryCell *nameCell;
@property (nonatomic, strong) PickerCell *startDateCell;
@property (nonatomic, strong) InlinedDatePickerCell *startDatePickerCell;
@property (nonatomic, strong) PickerCell *endDateCell;
@property (nonatomic, strong) InlinedDatePickerCell *endDatePickerCell;
@property (nonatomic, strong) PickerCell *currencyCell;
@property (nonatomic, strong) InlinedPickerCell *currencyPickerCell;
@property (nonatomic, strong) TitledTextEntryCell *commentCell;
@property (nonatomic, strong) TitledTextEntryCell *costCenterCell;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSTimeZone *startTimeZone;
@property (nonatomic, strong) NSTimeZone *endTimeZone;

@property (nonatomic, assign) BOOL creatingNewTrip;

@end

@implementation EditTripViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [WBCustomization customizeOnViewDidLoad:self];

    __weak EditTripViewController *weakSelf = self;

    [self.tableView registerNib:[TitledAutocompleteEntryCell viewNib] forCellReuseIdentifier:[TitledAutocompleteEntryCell cellIdentifier]];
    [self.tableView registerNib:[PickerCell viewNib] forCellReuseIdentifier:[PickerCell cellIdentifier]];
    [self.tableView registerNib:[InlinedDatePickerCell viewNib] forCellReuseIdentifier:[InlinedDatePickerCell cellIdentifier]];
    [self.tableView registerNib:[TitledTextEntryCell viewNib] forCellReuseIdentifier:[TitledTextEntryCell cellIdentifier]];
    [self.tableView registerNib:[InlinedPickerCell viewNib] forCellReuseIdentifier:[InlinedPickerCell cellIdentifier]];

    self.nameCell = [self.tableView dequeueReusableCellWithIdentifier:[TitledAutocompleteEntryCell cellIdentifier]];
    [self.nameCell setTitle:NSLocalizedString(@"edit.trip.name.label", nil)];
    if ([WBPreferences isAutocompleteEnabled]) {
        [self.nameCell setAutocompleteHelper:[[WBAutocompleteHelper alloc] initWithAutocompleteField:self.nameCell.entryField useReceiptsHints:NO]];
    }
    [self.nameCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
    [self.nameCell setInputValidation:[[ProperNameInputValidation alloc] init]];

    self.startDateCell = [self.tableView dequeueReusableCellWithIdentifier:[PickerCell cellIdentifier]];
    [self.startDateCell setTitle:NSLocalizedString(@"edit.trip.start.date.label", nil)];

    self.startDatePickerCell = [self.tableView dequeueReusableCellWithIdentifier:[InlinedDatePickerCell cellIdentifier]];
    [self.startDatePickerCell setChangeHandler:^(NSDate *selected) {
        [weakSelf.startDateCell setValue:[weakSelf.dateFormatter formattedDate:selected inTimeZone:weakSelf.startTimeZone]];
        weakSelf.startDate = selected;
        [weakSelf.endDatePickerCell setMinDate:selected maxDate:nil];
    }];

    self.endDateCell = [self.tableView dequeueReusableCellWithIdentifier:[PickerCell cellIdentifier]];
    [self.endDateCell setTitle:NSLocalizedString(@"edit.trip.end.date.label", nil)];

    self.endDatePickerCell = [self.tableView dequeueReusableCellWithIdentifier:[InlinedDatePickerCell cellIdentifier]];
    [self.endDatePickerCell setChangeHandler:^(NSDate *selected) {
        [weakSelf.endDateCell setValue:[weakSelf.dateFormatter formattedDate:selected inTimeZone:weakSelf.endTimeZone]];
        weakSelf.endDate = selected;
        [weakSelf.startDatePickerCell setMinDate:nil maxDate:selected];
    }];

    self.currencyCell = [self.tableView dequeueReusableCellWithIdentifier:[PickerCell cellIdentifier]];
    [self.currencyCell setTitle:NSLocalizedString(@"edit.trip.default.currency.label", nil)];

    self.currencyPickerCell = [self.tableView dequeueReusableCellWithIdentifier:[InlinedPickerCell cellIdentifier]];
    NSArray *cachedCurrencyCodes = [[RecentCurrenciesCache shared] cachedCurrencyCodes];
    [self.currencyPickerCell setAllValues:[cachedCurrencyCodes arrayByAddingObjectsFromArray:[Currency allCurrencyCodes]]];
    [self.currencyPickerCell setValueChangeHandler:^(id<Pickable> selected) {
        [weakSelf.currencyCell setValue:selected.presentedValue];
    }];

    self.commentCell = [self.tableView dequeueReusableCellWithIdentifier:[TitledTextEntryCell cellIdentifier]];
    [self.commentCell setTitle:NSLocalizedString(@"edit.trip.comment.label", nil)];
    [self.commentCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];

    self.costCenterCell = [self.tableView dequeueReusableCellWithIdentifier:[TitledTextEntryCell cellIdentifier]];
    [self.costCenterCell setTitle:NSLocalizedString(@"edit.trip.cost.center.label", nil)];
    [self.costCenterCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];

    NSMutableArray *presentedCells = [NSMutableArray array];

    [presentedCells addObject:self.nameCell];
    [presentedCells addObject:self.startDateCell];
    [presentedCells addObject:self.endDateCell];
    [presentedCells addObject:self.currencyCell];
    [presentedCells addObject:self.commentCell];
    if ([WBPreferences trackCostCenter]) {
        [presentedCells addObject:self.costCenterCell];
    }

    [self addSectionForPresentation:[InputCellsSection sectionWithCells:presentedCells]];

    [self addInlinedPickerCell:self.startDatePickerCell forCell:self.startDateCell];
    [self addInlinedPickerCell:self.endDatePickerCell forCell:self.endDateCell];
    [self addInlinedPickerCell:self.currencyPickerCell forCell:self.currencyCell];

    self.dateFormatter = [[WBDateFormatter alloc] init];
    
    [self.nameCell.entryField becomeFirstResponder];

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(unfocusTextField:)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;

    [self loadDataToCells];
}

// unfocus textfield on touch out
- (void)unfocusTextField:(UITapGestureRecognizer *)recognizer {
    [UIApplication dismissKeyboard];
}

- (void)loadDataToCells {
    [self setCreatingNewTrip:!self.trip];

    NSString *currency;
    if (_trip) {
        self.navigationItem.title = NSLocalizedString(@"edit.trip.controller.edit.title", nil);
        self.nameCell.value = [_trip name];
        _startDate = [_trip startDate];
        _endDate = [_trip endDate];
        _startTimeZone = [_trip startTimeZone];
        _endTimeZone = [_trip endTimeZone];
        currency = self.trip.defaultCurrency.code;
        [self.commentCell setValue:self.trip.comment];
        [self.costCenterCell setValue:self.trip.costCenter];
    } else {
        self.navigationItem.title = NSLocalizedString(@"edit.trip.controller.add.title", nil);
        _startDate = [[NSDate date] dateAtBeginningOfDay];

        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = [WBPreferences defaultTripDuration] - 1;
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        _endDate = [[theCalendar dateByAddingComponents:dayComponent toDate:_startDate options:0] dateAtEndOfDay];

        _startTimeZone = _endTimeZone = [NSTimeZone localTimeZone];
        currency = [WBPreferences defaultCurrency];
    }

    [self.startDateCell setValue:[self.dateFormatter formattedDate:_startDate inTimeZone:_startTimeZone]];
    [self.endDateCell setValue:[self.dateFormatter formattedDate:_endDate inTimeZone:_endTimeZone]];
    [self.startDatePickerCell setDate:_startDate];
    [self.startDatePickerCell setMinDate:nil maxDate:self.endDate];
    [self.endDatePickerCell setDate:_endDate];
    [self.endDatePickerCell setMinDate:self.startDate maxDate:nil];
    [self.currencyCell setValue:currency];
    [self.currencyPickerCell setSelectedValue:[StringPickableWrapper wrapValue:currency]];
}

- (IBAction)actionDone:(id)sender {
    NSString *name = [self.nameCell.value lastPathComponent];

    if (![name hasValue]) {
        [EditTripViewController showAlertWithTitle:nil message:NSLocalizedString(@"edit.trip.name.missing.alert.message", nil)];
        return;
    }

    if (!self.trip) {
        // We're inserting a new Trip
        [[AnalyticsManager sharedManager] recordWithEvent:[Event reportsPersistNewReport]];
        self.trip = [[WBTrip alloc] init];
    } else {
        // We're updating the current Trip
        [[AnalyticsManager sharedManager] recordWithEvent:[Event reportsPersistUpdateReport]];
    }

    [self.trip setName:name];
    [self.trip setStartDate:self.startDate];
    [self.trip setEndDate:self.endDate];
    [self.trip setDefaultCurrency:[Currency currencyForCode:self.currencyCell.value]];
    [self.trip setComment:self.commentCell.value];
    [self.trip setCostCenter:self.costCenterCell.value];

    if (self.creatingNewTrip && [[Database sharedInstance] saveTrip:self.trip]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if ([[Database sharedInstance] updateTrip:self.trip]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [EditTripViewController showAlertWithTitle:nil message:NSLocalizedString(@"edit.trip.generic.save.error.message", nil)];
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"generic.button.title.ok", nil) otherButtonTitles:nil] show];
}

@end
