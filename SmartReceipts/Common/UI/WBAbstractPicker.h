//
//  WBPopoverPicker.h
//  SmartReceipts
//
//  Created on 14/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class WBAbstractPicker;

@protocol WBAbstractPickerDelegate <NSObject>

-(void) abstractPickerDone:(WBAbstractPicker*) picker;
-(void) abstractPickerCancel:(WBAbstractPicker*) picker;

@end

@interface WBAbstractPicker : NSObject

@property (weak, nonatomic) id<WBAbstractPickerDelegate> delegate;
@property (weak, nonatomic) UIPickerView* pickerView;
@property (weak, nonatomic) UIDatePicker* datePicker;

- (id)initAsDatePicker:(BOOL) asDatePicker withController:(UIViewController*) vc;

- (void)setTitle:(NSString*) title;

- (void)showPickerFromView:(UIView*) view;
- (void)showPickerFromBarButtonItem:(UIBarButtonItem*) barButtonItem;
    
@end
