//
//  WBAutocompleteHelper.h
//  SmartReceipts
//
//  Created on 08/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AutocompleteHelperDelegate;

@interface WBAutocompleteHelper : NSObject
@property (weak, nonatomic) id<AutocompleteHelperDelegate> delegate;

- (id)initWithAutocompleteField:(UITextField*)field useReceiptsHints:(BOOL) forReceipts;

-(void)textFieldDidBeginEditing:(UITextField *)textField;
-(void)textFieldDidEndEditing:(UITextField *)textField;
/// Forces autocompletion routine, this method should be called in 'textField:shouldChangeCharactersInRange:replacementString:'
-(void)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
