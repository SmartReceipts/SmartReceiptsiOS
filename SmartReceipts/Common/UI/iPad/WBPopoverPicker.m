//
//  WBPopoverPicker.m
//  SmartReceipts
//
//  Created on 14/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBPopoverPicker.h"
#import <UIKit/UIKit.h>

@implementation WBPopoverPicker {
    __weak UIViewController *rootViewController;
    UIViewController *viewController;
    UILabel *titleLabel;
}

- (id)initAsDatePicker:(BOOL) asDatePicker withController:(UIViewController*) vc {
    self = [super init];
    if (self) {
        rootViewController = vc;
        UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 245)];
        UIToolbar *pickerToolbar = [self createPickerToolbarWithTitle:@""];
        [rootView addSubview:pickerToolbar];
        CGRect pickerFrame = CGRectMake(0, 44, 300, 245);
        
        if (asDatePicker) {
            UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
            self.datePicker = datePicker;
            datePicker.datePickerMode = UIDatePickerModeDate;
            datePicker.date = [NSDate date];
            [rootView addSubview:datePicker];
        } else {
            UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
            self.pickerView = pickerView;
            [pickerView setShowsSelectionIndicator:YES];
            [rootView addSubview:pickerView];
        }
        
        viewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
        viewController.view = rootView;
        viewController.preferredContentSize = viewController.view.frame.size;
        viewController.modalPresentationStyle = UIModalPresentationPopover;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    titleLabel.text = title;
}

- (void)showPickerFromView:(UIView*) view {
    [self removePopoverAnimated:YES];
    [self.pickerView reloadComponent:0];
    
    viewController.popoverPresentationController.sourceView = view;
    [rootViewController presentViewController:viewController animated:YES completion:nil];
}

- (void)showPickerFromBarButtonItem:(UIBarButtonItem*) barButtonItem {
    [self removePopoverAnimated:YES];
    [self.pickerView reloadComponent:0];
    
    viewController.popoverPresentationController.barButtonItem = barButtonItem;
    [rootViewController presentViewController:viewController animated:YES completion:nil];
}

- (UIToolbar *)createPickerToolbarWithTitle:(NSString *)title {
    CGRect frame = CGRectMake(0, 0, 300, 44);
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:frame];
    pickerToolbar.barStyle = UIBarStyleDefault;
    pickerToolbar.barTintColor = [UIColor whiteColor];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    [barItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionPickerCancel:)]];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexSpace];
    
    if (title){
        UIBarButtonItem *labelButton = [self createToolbarLabelWithTitle:title];
        [barItems addObject:labelButton];
        [barItems addObject:flexSpace];
    }
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionPickerDone:)];
    [barItems addObject:doneButton];
    
    [pickerToolbar setItems:barItems animated:YES];
    return pickerToolbar;
}

- (UIBarButtonItem *)createToolbarLabelWithTitle:(NSString *)aTitle {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100,30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:17];
    label.backgroundColor = [UIColor clearColor];
    label.text = aTitle;
    titleLabel = label;
    UIBarButtonItem *buttonLabel = [[UIBarButtonItem alloc]initWithCustomView:label];
    return buttonLabel;
}

- (void)actionPickerDone:(id)sender {
    [viewController dismissViewControllerAnimated:YES completion:nil];
    [self.delegate abstractPickerDone:self];
}

- (void)actionPickerCancel:(id)sender {
    [viewController dismissViewControllerAnimated:YES completion:nil];
    [self.delegate abstractPickerCancel:self];
}

- (void)removePopoverAnimated:(BOOL) animated {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
