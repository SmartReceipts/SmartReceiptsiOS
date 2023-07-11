//
//  ReceiptFilesManager.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 17/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReceiptFilesManager.h"
#import "WBReceipt.h"
#import "WBTrip.h"
#import "Constants.h"
#import "WBImageUtils.h"
#import <SmartReceipts-Swift.h>

@interface ReceiptFilesManager ()

@property (nonatomic, copy) NSString *pathToTripsFolder;

@end

@implementation ReceiptFilesManager

- (id)initWithTripsFolder:(NSString *)pathToTripsFolder {
    if (self) {
        _pathToTripsFolder = pathToTripsFolder;
    }
    return self;
}

- (BOOL)saveImage:(UIImage *)image forReceipt:(WBReceipt *)receipt {
    NSData *imageData = UIImageJPEGRepresentation(image, kImageCompression);
    NSString *path = [self pathForReceiptFile:receipt];
    [self ensureContainingFolderExists:path];
    NSError *writeError = nil;
    [imageData writeToFile:path options:NSDataWritingAtomic error:&writeError];
    if (writeError) {
        ErrorEvent *errorEvent = [[ErrorEvent alloc] initWithError:writeError
                                                              file:NSStringFromClass([self class])
                                                          function:NSStringFromSelector(_cmd)
                                                              line:__LINE__];
        [[AnalyticsManager sharedManager] recordWithEvent:errorEvent];
        return NO;
    }

    return YES;
}

- (BOOL)copyFileForReceipt:(WBReceipt *)receipt toTrip:(WBTrip *)trip {
    if (![self fileExistsForReceipt:receipt]) {
        return YES;
    }

    NSString *sourcePath = [self pathForReceiptFile:receipt];
    NSString *destinationPath = [self pathForReceiptFile:receipt withTrip:trip];
    [self ensureContainingFolderExists:destinationPath];
    NSError *copyError = nil;
    [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&copyError];
    if (copyError) {
        ErrorEvent *errorEvent = [[ErrorEvent alloc] initWithError:copyError
                                                              file:NSStringFromClass([self class])
                                                          function:NSStringFromSelector(_cmd)
                                                              line:__LINE__];
        [[AnalyticsManager sharedManager] recordWithEvent:errorEvent];
        return NO;
    }

    return YES;
}

- (BOOL)moveFileForReceipt:(WBReceipt *)receipt toTrip:(WBTrip *)trip {
    if (![self fileExistsForReceipt:receipt]) {
        return YES;
    }

    NSString *sourcePath = [self pathForReceiptFile:receipt];
    NSString *destinationPath = [self pathForReceiptFile:receipt withTrip:trip];
    [self ensureContainingFolderExists:destinationPath];
    NSError *moveError = nil;
    [[NSFileManager defaultManager] moveItemAtPath:sourcePath toPath:destinationPath error:&moveError];
    if (moveError) {
        ErrorEvent *errorEvent = [[ErrorEvent alloc] initWithError:moveError
                                                              file:NSStringFromClass([self class])
                                                          function:NSStringFromSelector(_cmd)
                                                              line:__LINE__];
        [[AnalyticsManager sharedManager] recordWithEvent:errorEvent];
        return NO;
    }

    return YES;
}

- (BOOL)deleteFileForReceipt:(WBReceipt *)receipt {
    if (![self fileExistsForReceipt:receipt]) {
        return YES;
    }
    
    NSString *path = [self pathForReceiptFile:receipt];
    NSError *deleteError = nil;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&deleteError];
    if (deleteError) {
        ErrorEvent *errorEvent = [[ErrorEvent alloc] initWithError:deleteError
                                                              file:NSStringFromClass([self class])
                                                          function:NSStringFromSelector(_cmd)
                                                              line:__LINE__];
        [[AnalyticsManager sharedManager] recordWithEvent:errorEvent];
        return NO;
    }

    return YES;
}

- (BOOL)fileExistsForReceipt:(WBReceipt *)receipt {
    NSString *path = [self pathForReceiptFile:receipt];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

- (NSString *)pathForReceiptFile:(WBReceipt *)receipt {
    return [self pathForReceiptFile:receipt withTrip:receipt.trip];
}

- (NSString *)pathForReceiptFile:(WBReceipt *)receipt withTrip:(WBTrip *)trip {
    NSString *tripFolder = [self.pathToTripsFolder stringByAppendingPathComponent:trip.name];
    NSString *filePath = [tripFolder stringByAppendingPathComponent:receipt.imageFileName];
    return filePath;
}

- (NSString *)receiptsFolderForTrip:(WBTrip *)trip {
    return [self receiptsFolderForTripNamed:trip.name];
}

- (NSString *)receiptsFolderForTripNamed:(NSString *)tripName {
    return [self.pathToTripsFolder stringByAppendingPathComponent:tripName];
}

- (void)ensureContainingFolderExists:(NSString *)filePath {
    NSString *folderPath = [filePath substringToIndex:filePath.length - [filePath lastPathComponent].length];
    NSError *createFolderError = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&createFolderError];
    if (createFolderError) {
        ErrorEvent *errorEvent = [[ErrorEvent alloc] initWithError:createFolderError
                                                              file:NSStringFromClass([self class])
                                                          function:NSStringFromSelector(_cmd)
                                                              line:__LINE__];
        [[AnalyticsManager sharedManager] recordWithEvent:errorEvent];
    }
}

- (void)deleteFolderForTrip:(WBTrip *)trip {
    NSString *path = [self receiptsFolderForTrip:trip];
    NSError *deleteError = nil;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&deleteError];
    if (deleteError) {
        ErrorEvent *errorEvent = [[ErrorEvent alloc] initWithError:deleteError
                                                              file:NSStringFromClass([self class])
                                                          function:NSStringFromSelector(_cmd)
                                                              line:__LINE__];
        [[AnalyticsManager sharedManager] recordWithEvent:errorEvent];
    }
}

- (void)renameFolderForTrip:(WBTrip *)trip originalName:(NSString *)originalName {
    NSString *originalPath = [self receiptsFolderForTripNamed:originalName];
    NSString *destinationPath = [self receiptsFolderForTrip:trip];
    NSError *moveError = nil;
    [[NSFileManager defaultManager] moveItemAtPath:originalPath toPath:destinationPath error:&moveError];
    if (moveError) {
        ErrorEvent *errorEvent = [[ErrorEvent alloc] initWithError:moveError
                                                              file:NSStringFromClass([self class])
                                                          function:NSStringFromSelector(_cmd)
                                                              line:__LINE__];
        [[AnalyticsManager sharedManager] recordWithEvent:errorEvent];
    }
}

@end
