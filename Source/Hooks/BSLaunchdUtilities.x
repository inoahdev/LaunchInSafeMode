//
//  Source/Hooks/BSLaunchdUtilities.x
//  LaunchInSafeMode
//
//  Created by inoahdev on 5/20/17.
//  Copyright © 2017 inoahdev. All rights reserved.
//

#import "../Classes/LaunchInSafeModeTweak.h"

%hook BSLaunchdUtilities
+ (BOOL)createJobWithLabel:(NSString *)jobLabel bundleIdentifier:(NSString *)bundleIdentifier path:(NSString *)path containerPath:(NSString *)containerPath arguments:(NSArray<NSString *> *)arguments environment:(NSMutableDictionary *)environment standardOutputPath:(NSString *)standardOutputPath standardErrorPath:(NSString *)standardErrorPath machServices:(NSArray<NSString *> *)machServices threadPriority:(NSInteger)threadPriority waitForDebugger:(BOOL)waitForDebugger denyCreatingOtherJobs:(BOOL)denyCreatingOtherJobs runAtLoad:(BOOL)runAtLoad disableASLR:(BOOL)disableASLR systemApp:(BOOL)systemApp {
    LaunchInSafeModeTweak *tweak = [LaunchInSafeModeTweak sharedInstance];
    NSString *currentBundleIdentifier = [tweak currentBundleIdentifier];

    if (!currentBundleIdentifier) {
        return %orig();
    }

    if (![currentBundleIdentifier isEqualToString:bundleIdentifier]) {
        return %orig();
    }

    [tweak setCurrentBundleIdentifier:nil];

    BOOL environmentShouldBeReleased = NO;
    if (![environment isKindOfClass:%c(NSMutableDictionary)]) {
        environment = [environment mutableCopy];
        environmentShouldBeReleased = YES;
    }

    [environment setObject:[tweak safeModeNumber] forKey:@"_MSSafeMode"];

    BOOL result = %orig();
    if (environmentShouldBeReleased) {
        [environment release];
    }

    return result;
}
%end
