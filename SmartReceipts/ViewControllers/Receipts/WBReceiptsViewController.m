//
//  WBReceiptsViewController.m
//  SmartReceipts
//
//  Created on 12/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBReceiptsViewController.h"
#import "WBReceiptActionsViewController.h"
#import "WBGenerateViewController.h"
#import "WBDateFormatter.h"
#import "WBFileManager.h"
#import "WBPreferences.h"
#import "ImagePicker.h"
#import "TripDistancesViewController.h"
#import "UIView+LoadHelpers.h"
#import "FetchedModelAdapter.h"
#import "Database+Receipts.h"
#import "Database+Trips.h"
#import "Constants.h"
#import "ReceiptSummaryCell.h"
#import "DistancesToReceiptsConverter.h"
#import "SmartReceipts-Swift.h"

static NSString *CellIdentifier = @"Cell";
static NSString *const PresentTripDistancesSegue = @"PresentTripDistancesSegue";

@interface WBReceiptsViewController ()
{
    // ugly, but segues are limited
    UIImage *_imageForCreatorSegue;
    WBReceipt *_receiptForCretorSegue;
    
    CGFloat _priceWidth;
}

@property (nonatomic, strong) WBReceipt *tapped;
@property (nonatomic, strong) WBDateFormatter *dateFormatter;
@property (nonatomic, assign) BOOL showReceiptDate;
@property (nonatomic, assign) BOOL showReceiptCategory;
@property (nonatomic, copy) NSString *lastDateSeparator;
@property (nonatomic, assign) BOOL showAttachmentMarker;

@end

@implementation WBReceiptsViewController

#pragma mark - VC lifecycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //clear when new tip is opened
    [[WBReceiptsViewController sharedInputCache] setDictionary:@{}];

    [Customization customizeOnViewDidLoad:self];

    [self setShowReceiptDate:[WBPreferences layoutShowReceiptDate]];
    [self setShowReceiptCategory:[WBPreferences layoutShowReceiptCategory]];
    [self setShowAttachmentMarker:[WBPreferences layoutShowReceiptAttachmentMarker]];

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
 
    [self setPresentationCellNib:[ReceiptSummaryCell viewNib]];
    
    self.dateFormatter = [[WBDateFormatter alloc] init];
    
    if (self.trip == nil) {
        return;
    }
    
    [self updateEditButton];
    [self updateTitle];
    [self setLastDateSeparator:[WBPreferences dateSeparator]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tripUpdated:) name:DatabaseDidUpdateModelNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsSaved) name:SmartReceiptsSettingsSavedNotification object:nil];
}

- (NSString *)placeholderTitle {
    return NSLocalizedString(@"fetched.placeholder.receipts.title", nil);
}

#pragma mark -

- (void)tripUpdated:(NSNotification *)notification {
    WBTrip *trip = notification.object;
    LOGGER_DEBUG(@"updatTrip:%@", trip);

    if (![self.trip isEqual:trip]) {
        return;;
    }

    //TODO jaanus: check posting already altered object
    self.trip = [[Database sharedInstance] tripWithName:self.trip.name];
    [self updateTitle];
}

- (void)updateEditButton {
    self.editButtonItem.enabled = self.numberOfItems > 0;
}

- (void)updateTitle {
    LOGGER_DEBUG(@"updateTitle");
    NSString *title = [NSString stringWithFormat:@"%@ - %@", [self.trip formattedPrice], [self.trip name]];
    [self setTitle:title subtitle:[self subtitle] color:[UIColor whiteColor]];
}

- (void)updatePricesWidth {
    CGFloat w = [self computePriceWidth];
    if (w == _priceWidth) {
        return;
    }

    _priceWidth = w;
    for (ReceiptSummaryCell *cell in self.tableView.visibleCells) {
        [cell.priceWidthConstraint setConstant:w];
        [cell layoutIfNeeded];
    }
}

- (CGFloat)computePriceWidth {
    CGFloat maxWidth = 0;

    for (NSUInteger i = 0; i < [self numberOfItems]; ++i) {
        WBReceipt *receipt = [self objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        NSString *str = [receipt formattedPrice];

        CGRect bounds = [str boundingRectWithSize:CGSizeMake(1000, 100) options:NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:21]} context:nil];
        maxWidth = MAX(maxWidth, CGRectGetWidth(bounds) + 10);
    }

    maxWidth = MIN(maxWidth, CGRectGetWidth(self.view.bounds) / 2);
    return MAX(CGRectGetWidth(self.view.bounds) / 6, maxWidth);
}

- (NSUInteger)receiptsCount {
    return [self numberOfItems];
}

- (void)configureCell:(UITableViewCell *)aCell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    ReceiptSummaryCell *cell = (ReceiptSummaryCell *) aCell;

    WBReceipt *receipt = object;

    cell.priceField.text = [receipt formattedPrice];
    cell.nameField.text = [receipt name];
    cell.dateField.text = self.showReceiptDate ? [_dateFormatter formattedDate:[receipt date] inTimeZone:[receipt timeZone]] : @"";
    cell.categoryLabel.text = self.showReceiptCategory ? receipt.category : @"";
    cell.markerLabel.text = self.showAttachmentMarker ? [receipt attachmentMarker] : @"";

    [cell.priceWidthConstraint setConstant:_priceWidth];
}

- (void)contentChanged {
    [self updateEditButton];
    [self updatePricesWidth];
    [self updateTitle];
}

- (void)deleteObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    [[AnalyticsManager sharedManager] recordWithEvent:[Event receiptsReceiptMenuDelete]];
    [[Database sharedInstance] deleteReceipt:object];
}

- (void)swapReceiptAtIndex:(NSUInteger)idx1 withReceiptAtIndex:(NSUInteger)idx2 {
    WBReceipt *rec1 = [self objectAtIndexPath:[NSIndexPath indexPathForRow:idx1 inSection:0]];
    WBReceipt *rec2 = [self objectAtIndexPath:[NSIndexPath indexPathForRow:idx2 inSection:0]];

    if (![[Database sharedInstance] swapReceipt:rec1 withReceipt:rec2]) {
        LOGGER_WARNING(@"Error: cannot swap");
    }
}

- (void)swapUpReceipt:(WBReceipt *)receipt {
    NSUInteger idx = [self indexOfObject:receipt];
    if (idx == 0 || idx == NSNotFound) {
        return;
    }
    [self swapReceiptAtIndex:idx withReceiptAtIndex:(idx - 1)];
}

- (void)swapDownReceipt:(WBReceipt *)receipt {
    NSUInteger idx = [self indexOfObject:receipt];
    if (idx >= ([self numberOfItems] - 1) || idx == NSNotFound) {
        return;
    }
    [self swapReceiptAtIndex:idx withReceiptAtIndex:(idx + 1)];
}

- (BOOL)attachPdfOrImageFile:(NSString *)oldFile toReceipt:(WBReceipt *)receipt {

    NSString *ext = [oldFile pathExtension];

    NSString *imageFileName = [NSString stringWithFormat:@"%tu_%@.%@", [receipt receiptId], [receipt name], ext];
    NSString *newFile = [self.trip fileInDirectoryPath:imageFileName];

    if (![WBFileManager forceCopyFrom:oldFile to:newFile]) {
        LOGGER_ERROR(@"Couldn't force copy from %@ to %@", oldFile, newFile);
        return NO;
    }

    if (![[Database sharedInstance] updateReceipt:receipt changeFileNameTo:imageFileName]) {
        LOGGER_ERROR(@"Error: cannot update image file %@ for receipt %@", imageFileName, receipt.name);
        return NO;
    }

    return YES;
}

- (BOOL)updateReceipt:(WBReceipt *)receipt image:(UIImage *)image {
    NSString *imageFileName = nil;
    if (image) {
        //TODO jaanus: this leaves old file in documents folder
        imageFileName = [NSString stringWithFormat:@"%tu_%@.jpg", [receipt receiptId], [receipt name]];
        NSString *path = [self.trip fileInDirectoryPath:imageFileName];
        if (![WBFileManager forceWriteData:UIImageJPEGRepresentation(image, 0.85) to:path]) {
            imageFileName = nil;
        }
    }

    if (!imageFileName) {
        return NO;
    }

    if (![[Database sharedInstance] updateReceipt:receipt changeFileNameTo:imageFileName]) {
        LOGGER_ERROR(@"Error: cannot update image file");
        return NO;
    }
    return YES;
}

- (void)tappedObject:(id)tapped atIndexPath:(NSIndexPath *)indexPath {
    [self setTapped:tapped];

    if (self.tableView.editing) {
        [self performSegueWithIdentifier:@"ReceiptCreator" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"ReceiptActions" sender:nil];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ReceiptActions"]) {
        // view receipt
        WBReceiptActionsViewController *vc = (WBReceiptActionsViewController *) [[segue destinationViewController] topViewController];
        vc.receiptsViewController = self;
        vc.receipt = self.tapped;
    } else if ([[segue identifier] isEqualToString:@"ReceiptCreator"]) {
        // Edit or create receipt
        EditReceiptViewController *vc = (EditReceiptViewController *) [[segue destinationViewController] topViewController];

        vc.receiptsViewController = self;

        WBReceipt *receipt = nil;
        if (self.tapped) {
            // Edit receipt action
            [[AnalyticsManager sharedManager] recordWithEvent:[Event receiptsReceiptMenuEdit]];
            receipt = self.tapped;
        } else {
            
            if (_imageForCreatorSegue) {
                // image exists, so user is trying AddPictureReceipt
                [[AnalyticsManager sharedManager] recordWithEvent:[Event receiptsAddPictureReceipt]];
            } else {
                // no image, means user creates a text receipt
                [[AnalyticsManager sharedManager] recordWithEvent:[Event receiptsAddTextReceipt]];
            }
            
            [vc setReceiptImage:_imageForCreatorSegue];
            receipt = _receiptForCretorSegue;
            _imageForCreatorSegue = nil;
            _receiptForCretorSegue = nil;
        }
        [vc setReceipt:receipt withTrip:self.trip];
    }
    else if ([[segue identifier] isEqualToString:@"Settings"]) {

    }
    else if ([[segue identifier] isEqualToString:@"GenerateReport"]) {
        WBGenerateViewController *vc = (WBGenerateViewController *) [[segue destinationViewController] topViewController];
        [vc setTrip:self.trip];
    } else if ([PresentTripDistancesSegue isEqualToString:segue.identifier]) {
        TripDistancesViewController *controller = (TripDistancesViewController *) [[segue destinationViewController] topViewController];
        [controller setTrip:self.trip];
    }

    [self setTapped:nil];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

- (FetchedModelAdapter *)createFetchedModelAdapter {
    // This is needed on iPad. When ap is launched, then storyboard pushes unconfigured view.
    // This is replaced right after by configured one
    if (!self.trip) {
        return nil;
    }

    return [[Database sharedInstance] fetchedReceiptsAdapterForTrip:self.trip];
}

- (void)settingsSaved {
    if (self.showReceiptDate == [WBPreferences layoutShowReceiptDate]
            && self.showReceiptCategory == [WBPreferences layoutShowReceiptCategory]
            && self.showAttachmentMarker == [WBPreferences layoutShowReceiptAttachmentMarker]
            && [self.lastDateSeparator isEqualToString:[WBPreferences dateSeparator]]) {
        return;
    }

    [self setLastDateSeparator:[WBPreferences dateSeparator]];
    [self setShowReceiptDate:[WBPreferences layoutShowReceiptDate]];
    [self setShowReceiptCategory:[WBPreferences layoutShowReceiptCategory]];
    [self setShowAttachmentMarker:[WBPreferences layoutShowReceiptAttachmentMarker]];
    [self.tableView reloadData];
}

+ (NSMutableDictionary *)sharedInputCache {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [NSMutableDictionary dictionary];
    });
}

#pragma mark - Actions
    
- (IBAction)actionCamera:(id)sender {
    [[ImagePicker sharedInstance] presentPickerOnController:self completion:^(UIImage *image) {
        if (!image) {
            return;
        }
        
        _imageForCreatorSegue = image;
        _receiptForCretorSegue = nil;
        [self performSegueWithIdentifier:@"ReceiptCreator" sender:self];
    }];
}
    
- (IBAction)onDistancesTap:(id)sender {
    [self openDistancesFor:self.trip];
}


#pragma mark - Private

- (NSString *)dailyTotal {
    NSArray <WBReceipt *> *receipts = [self allObjects];
    PricesCollection *priceCollection = [PricesCollection new];
    [priceCollection addPrice:[Price zeroPriceWithCurrencyCode:[WBPreferences defaultCurrency]]];
    
    if ([WBPreferences printDailyDistanceValues]) {
        receipts = [receipts arrayByAddingObjectsFromArray:[self distanceReceipts]];
    }
    
    for (WBReceipt *receipt in receipts) {
        if ([[NSCalendar currentCalendar] isDateInToday:receipt.date]) {
            Price *price = receipt.exchangedPrice ? receipt.exchangedPrice : receipt.price;
            [priceCollection addPrice:price];
        }
    }
    
    return [NSString stringWithFormat:NSLocalizedString(@"trips.controller.daily.total", nil), priceCollection.currencyFormattedPrice];
}

- (NSString *)nextID {
    NSUInteger ID = [[Database sharedInstance] nextAutoGeneratedIDForTable:ReceiptsTable.TABLE_NAME];
    NSString *idString = [NSString stringWithFormat:@"%lu", ID];
    return [NSString stringWithFormat:NSLocalizedString(@"trips.controller.next.id.subtitle", nil), idString];
}

- (NSString *)subtitle {
    return [WBPreferences showReceiptID] ? [self nextID] : [self dailyTotal];
}

- (NSArray *)distanceReceipts {
    FetchedModelAdapter *distances = [[Database sharedInstance] fetchedAdapterForDistancesInTrip:self.trip ascending:true];
    NSArray *distanceReceipts = [DistancesToReceiptsConverter convertDistances:[distances allObjects]];
    return distanceReceipts;
}

@end
