//
//  ImagePicker.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 22/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "RIButtonItem.h"
#import "UIActionSheet+Blocks.h"
#import "ImagePicker.h"
#import "Constants.h"
#import "WBImageUtils.h"
#import "WBPreferences.h"

@interface ImagePicker () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, copy) WBImagePickerResultBlock selectionHandler;

@end

@implementation ImagePicker

+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] initSingleton];
    });
}

- (id)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must use [%@ %@] instead",
                                                                     NSStringFromClass([self class]),
                                                                     NSStringFromSelector(@selector(sharedInstance))]
                                 userInfo:nil];
    return nil;
}

- (id)initSingleton {
    self = [super init];
    if (self) {
        // Custom initialization code
    }
    return self;
}

- (void)presentPickerOnController:(UIViewController *)controller completion:(WBImagePickerResultBlock)completion {
    [self setSelectionHandler:completion];

    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (!hasCamera) {
        [self presentImagePickerWithSource:UIImagePickerControllerSourceTypePhotoLibrary onController:controller];
        return;
    }

    void (^cancelAction)() = ^{
        [self setSelectionHandler:nil];
    };
    void (^chooseFromLibraryAction)() = ^{
        [self presentImagePickerWithSource:UIImagePickerControllerSourceTypePhotoLibrary onController:controller];
    };
    void (^takeImageAction)() = ^{
        [self presentImagePickerWithSource:UIImagePickerControllerSourceTypeCamera onController:controller];
    };

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"image.picker.sheet.title", nil)
                                                     cancelButtonItem:[RIButtonItem itemWithLabel:NSLocalizedString(@"image.picker.sheet.cancel.button.title", nil) action:cancelAction]
                                                destructiveButtonItem:nil
                                                     otherButtonItems:[RIButtonItem itemWithLabel:NSLocalizedString(@"image.picker.sheet.choose.existing.button.title", nil) action:chooseFromLibraryAction],
                                                                      [RIButtonItem itemWithLabel:NSLocalizedString(@"image.picker.sheet.take.photo.button.title", nil) action:takeImageAction], nil];
    [actionSheet showInView:controller.view];
}

- (void)presentCameraOnController:(UIViewController *)controller completion:(WBImagePickerResultBlock)completion {
    [self setSelectionHandler:completion];
    [self presentImagePickerWithSource:UIImagePickerControllerSourceTypeCamera onController:controller];
}

- (void)presentImagePickerWithSource:(UIImagePickerControllerSourceType)source onController:(UIViewController *)controller {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = source;

    [controller presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];

    chosenImage = [WBImageUtils processImage:chosenImage];
    CGFloat compressionRation = 0.95;
    chosenImage = [WBImageUtils compressImage:chosenImage withRatio:compressionRation];

    [picker dismissViewControllerAnimated:YES completion:^{
        self.selectionHandler(chosenImage);
        [self setSelectionHandler:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    self.selectionHandler(nil);
    [self setSelectionHandler:nil];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
