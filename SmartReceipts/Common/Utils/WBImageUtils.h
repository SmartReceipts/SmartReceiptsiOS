//
//  WBImageUtils.h
//  SmartReceipts
//
//  Created on 04/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static const CGFloat kImageCompression = 0.85f;

@interface WBImageUtils : NSObject

+ (UIImage *)image:(UIImage *)image scaledToSize:(CGSize)size;
+ (UIImage *)image:(UIImage *)image scaledToFitSize:(CGSize)size;
+ (UIImage *)image:(UIImage *)image withOrientation:(UIImageOrientation)orientation;
+ (UIImage *)processImage:(UIImage *)image;
+ (UIImage *)compressImage:(UIImage *)image withRatio:(CGFloat) compressionQuality;
+ (UIImage *)withoutScreenScaleImage:(UIImage *)image;
@end
