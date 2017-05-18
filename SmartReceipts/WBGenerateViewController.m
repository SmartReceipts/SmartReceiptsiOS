//
//  WBGenerateViewController.m
//  SmartReceipts
//
//  Created on 18/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBGenerateViewController.h"

#import "WBImageStampler.h"

#import "WBReceiptAndIndex.h"
#import "WBPreferences.h"

#import "WBReportUtils.h"

#import "TripCSVGenerator.h"
#import "TripImagesPDFGenerator.h"
#import "TripFullPDFGenerator.h"
#import "Database.h"
#import "Database+Receipts.h"
#import "PendingHUDView.h"
#import "Constants.h"
#import "SmartReceipts-Swift.h"
#import "SettingsViewController.h"

@interface WBGenerateViewController () <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *fullPdfReportField;
@property (weak, nonatomic) IBOutlet UISwitch *pdfImagesField;
@property (weak, nonatomic) IBOutlet UISwitch *csvFileField;
@property (weak, nonatomic) IBOutlet UISwitch *zipImagesField;
@property (weak, nonatomic) IBOutlet UILabel *labelFullPdfReport;
@property (weak, nonatomic) IBOutlet UILabel *labelPdfReport;
@property (weak, nonatomic) IBOutlet UILabel *labelCsvFile;
@property (weak, nonatomic) IBOutlet UILabel *labelZipImages;

@end

@implementation WBGenerateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"generate.report.controller.title", nil);
    
    self.labelFullPdfReport.text = NSLocalizedString(@"generate.report.option.full.pdf", nil);
    self.labelPdfReport.text = NSLocalizedString(@"generate.report.option.pdf.no.table", nil);
    self.labelCsvFile.text = NSLocalizedString(@"generate.report.option.csv", nil);
    self.labelZipImages.text = NSLocalizedString(@"generate.report.option.zip.stamped", nil);
    
    [self trackConfigureReportevent];
}

- (NSArray *)splitValueFrom:(NSString *)joined {
    return [joined componentsSeparatedByString:@","];
}

- (IBAction)actionDone:(id)sender {
    
    if (!self.fullPdfReportField.on && !self.pdfImagesField.on && !self.csvFileField.on && !self.zipImagesField.on) {
        [self showAlertWithTitle:NSLocalizedString(@"generic.error.alert.title", nil)
                         message:NSLocalizedString(@"generate.report.no.options.selected.alert.message", nil)];
        return;
    }
    
    [self generate];
}

- (IBAction)actionCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showAlertWithTitle:(NSString*) title message:(NSString*) message {
    [[[UIAlertView alloc]
      initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"generic.button.title.ok",nil) otherButtonTitles:nil] show];
}

- (void)openSettingsAtSection {
    [[AnalyticsManager sharedManager] recordWithEvent:[Event informationalConfigureReport]];
    
    UIStoryboard *currentStoryBoard = self.storyboard;
    UINavigationController *settingsOverflow = [currentStoryBoard instantiateViewControllerWithIdentifier:@"SettingsOverflow"];
    if (settingsOverflow == nil) {
        LOGGER_WARNING(@"goToSettings: SettingsOverflow is Nil");
        return;
    }
    
    // find Settings VC and set true for wasPresentedFromGeneratorVC
    SettingsViewController *settingsVC = settingsOverflow.viewControllers.firstObject;
    if (settingsVC) {
        LOGGER_INFO(@"goToSettings: wasPresentedFromGeneratorVC = YES");
        settingsVC.wasPresentedFromGeneratorVC = YES;
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        settingsOverflow.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    
    [settingsOverflow setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:settingsOverflow animated:YES completion:nil];
}

#pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath == [NSIndexPath indexPathForRow:0 inSection:0]) {
        // customizing tooltip tapped:
        [self openSettingsAtSection];
    }
}

@end
