//
//  Source/Hooks/BSLaunchdUtilities.x
//  LaunchInSafeMode
//
//  Created by inoahdev on 5/20/17.
//  Copyright © 2017 - 2018 inoahdev. All rights reserved.
//

#import <version.h>
#import "../Classes/LaunchInSafeModeTweak.h"

%group UptoiOS11
%hook BSLaunchdUtilities
+ (BOOL)createJobWithLabel:(NSString *)jobLabel bundleIdentifier:(NSString *)bundleIdentifier path:(NSString *)path containerPath:(NSString *)containerPath arguments:(NSArray<NSString *> *)arguments environment:(NSMutableDictionary *)environment standardOutputPath:(NSString *)standardOutputPath standardErrorPath:(NSString *)standardErrorPath machServices:(NSArray<NSString *> *)machServices threadPriority:(NSInteger)threadPriority waitForDebugger:(BOOL)waitForDebugger denyCreatingOtherJobs:(BOOL)denyCreatingOtherJobs runAtLoad:(BOOL)runAtLoad disableASLR:(BOOL)disableASLR systemApp:(BOOL)systemApp {    
    LaunchInSafeModeTweak *tweak = [LaunchInSafeModeTweak sharedInstance];
    NSString *currentBundleIdentifier = [tweak currentBundleIdentifier];

    if (!currentBundleIdentifier) {
        LaunchInSafeModeLog(@"currentBundleIdentifier is nil, LaunchInSafeMode shortcut was not invoked");
        return %orig();
    }

    if (![currentBundleIdentifier isEqualToString:bundleIdentifier]) {
        LaunchInSafeModeLogFormat(@"currentBundleIdentifier does not match app being launched, currentBundleIdentifier: %@ vs %@", currentBundleIdentifier, bundleIdentifier);
        return %orig();
    }

    [tweak setCurrentBundleIdentifier:nil];

    BOOL environmentShouldBeReleased = NO;
    if (![environment isKindOfClass:%c(NSMutableDictionary)]) {
        environment = [environment mutableCopy];
        environmentShouldBeReleased = YES;
    }

    [environment setObject:[tweak safeModeNumber] forKey:@"_MSSafeMode"];
    LaunchInSafeModeLogFormat(@"Resulting environment for app launched with LaunchInSafeMode: %@", environment);

    BOOL result = %orig();
    if (environmentShouldBeReleased) {
        [environment release];
    }

    return result;
}
%end
%end

%ctor {
    if (IS_IOS_OR_OLDER(iOS_10_3)) {
        %init(UptoiOS11);
    }
}
