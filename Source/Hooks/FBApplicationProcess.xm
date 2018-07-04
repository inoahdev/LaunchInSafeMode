//
//  Source/Hooks/BKSProcess.x
//  LaunchInSafeMode
//
//  Created by inoahdev on 5/20/17.
//  Copyright © 2017 - 2018 inoahdev. All rights reserved.
//

#import <version.h>
#import "../Classes/LaunchInSafeModeTweak.h"

#import "../Headers/FrontBoard/FBMutableProcessExecutionContext.h"
#import "../Headers/FrontBoard/FBApplicationProcess.h"

%group iOS11Up
%hook FBApplicationProcess
- (BOOL)_queue_bootstrapAndExecWithContext:(FBMutableProcessExecutionContext *)context {
    LaunchInSafeModeTweak *tweak = [LaunchInSafeModeTweak sharedInstance];
    NSString *currentBundleIdentifier = [tweak currentBundleIdentifier];

    if (!currentBundleIdentifier) {
        LaunchInSafeModeLog(@"currentBundleIdentifier is nil, LaunchInSafeMode shortcut was not invoked");
        return %orig();
    }

    FBApplicationInfo *applicationInfo = [self applicationInfo];
    NSString *bundleIdentifier = MSHookIvar<NSString *>(applicationInfo, "_bundleIdentifier");

    if (![currentBundleIdentifier isEqualToString:bundleIdentifier]) {
        LaunchInSafeModeLogFormat(@"currentBundleIdentifier does not match app being launched, currentBundleIdentifier: %@ vs %@", currentBundleIdentifier, bundleIdentifier);
        return %orig();
    }

    [tweak setCurrentBundleIdentifier:nil];

    NSDictionary *environment = [context environment];
    NSMutableDictionary *mutableEnvironment = [environment mutableCopy];

    [mutableEnvironment setObject:[tweak safeModeNumber] forKey:@"_MSSafeMode"];
    [context setEnvironment:mutableEnvironment];

    [mutableEnvironment release];

    LaunchInSafeModeLogFormat(@"Resulting environment for app launched with LaunchInSafeMode: %@",
                              [context environment]);
    return %orig();   
}
%end
%end

%ctor {
    if (IS_IOS_OR_NEWER(iOS_11_0)) {
        %init(iOS11Up);
    }
}