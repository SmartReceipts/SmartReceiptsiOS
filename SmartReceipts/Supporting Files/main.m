//
//  main.m
//  SmartReceipts
//
//  Created on 11/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WBAppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        Class delegateClass = NSClassFromString(@"WBTestAppDelegate");
        if (!delegateClass) {
            delegateClass = [WBAppDelegate class];
        }
        return UIApplicationMain(argc, argv, nil, NSStringFromClass(delegateClass));
    }
}
