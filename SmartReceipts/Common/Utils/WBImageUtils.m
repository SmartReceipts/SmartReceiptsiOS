//
//  WBImageUtils.m
//  SmartReceipts
//
//  Created on 04/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBImageUtils.h"
#import "WBPreferences.h"
#import <UIKit/UIKit.h>

@implementation WBImageUtils

+ (UIImage *)image:(UIImage *)image scaledToSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 2.0f);

    [image drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return newImage;
}

+ (UIImage *)image:(UIImage *)image scaledToFitSize:(CGSize)size {
    CGFloat aspect = image.size.width / image.size.height;
    if (size.width / aspect <= size.height) {
        return [WBImageUtils image:image scaledToSize:CGSizeMake(size.width, size.width / aspect)];
    } else {
        return [WBImageUtils image:image scaledToSize:CGSizeMake(size.height * aspect, size.height)];
    }
}

+ (UIImage *)image:(UIImage *)image withOrientation:(UIImageOrientation)orientation {
    CGSize size = image.size;
    UIGraphicsBeginImageContext(CGSizeMake(size.height, size.width));

    [[UIImage imageWithCGImage:[image CGImage] scale:1.0 orientation:orientation] drawInRect:CGRectMake(0, 0, size.height, size.width)];

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)processImage:(UIImage *)image {
    NSInteger defaultSize = 1024;
    NSInteger size = [WBPreferences cameraMaxHeightWidth];
    if (size > 0) {
        image = [self image:image scaledToFitSize:CGSizeMake(size, size)];
    } else {
        image = [self image:image scaledToFitSize:CGSizeMake(defaultSize, defaultSize)];
    }

    if ([WBPreferences cameraSaveImagesBlackAndWhite]) {
        image = [self convertImageToGrayScale:image];
    }

    return image;
}

+ (UIImage *)convertImageToGrayScale:(UIImage *)image {
    CIImage *inputCIImage = [[CIImage alloc] initWithImage:image];

    CIFilter *grayFilter = [CIFilter filterWithName:@"CIColorControls"];
    [grayFilter setValue:@(0) forKeyPath:@"inputSaturation"];

    [grayFilter setValue:inputCIImage forKeyPath:@"inputImage"];

    CIImage *outputCIImage = [grayFilter outputImage];

    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef outputCGImage = [context createCGImage:outputCIImage fromRect:[outputCIImage extent]];
    UIImage *outputImage = [UIImage imageWithCGImage:outputCGImage];
    CGImageRelease(outputCGImage);

    return outputImage;
}

+ (UIImage *)compressImage:(UIImage *)image withRatio:(CGFloat) compressionQuality {
    NSData *imgData = UIImageJPEGRepresentation(image, compressionQuality);
    return [UIImage imageWithData:imgData];
}

+ (UIImage *)withoutScreenScaleImage:(UIImage *)image {
    CGFloat width = image.size.width/UIScreen.mainScreen.scale;
    CGFloat height = image.size.height/UIScreen.mainScreen.scale;
    CGSize size = CGSizeMake(width, height);
    
    return [WBImageUtils image:image scaledToSize:size];
}

@end
