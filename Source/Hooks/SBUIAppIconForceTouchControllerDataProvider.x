//
//  Source/Hooks/SBApplicationShortcutStoreManager.x
//  LaunchInSafeMode
//
//  Created by inoahdev on 5/20/17.
//  Copyright © 2017 inoahdev. All rights reserved.
//

#import <version.h>
#import "../Classes/LaunchInSafeModeTweak.h"

#import "../Headers/SpringBoardServices/SBSApplicationShortcutItem.h"
#import "../Headers/SpringBoardUI/SBUIAppIconForceTouchControllerDataProvider.h"

static NSString *const kLaunchInSafeModeTweakShortcutItemIdentifier = @"com.inoahdev.launchinsafemode.safemode";

%group iOS10
%hook SBUIAppIconForceTouchControllerDataProvider
- (NSArray *)applicationShortcutItems {
    LaunchInSafeModeTweak *launchInSafeModeTweak = [LaunchInSafeModeTweak sharedInstance];
    NSMutableArray *originalApplicationShortcutItems = (NSMutableArray *)%orig();

    BOOL launchInSafeModeTweakIsEnabled = [launchInSafeModeTweak isEnabled];
    if (!launchInSafeModeTweakIsEnabled) {
        return originalApplicationShortcutItems;
    }

    NSMutableDictionary *launchInSafeModeTweakCachedShortcutItems = [launchInSafeModeTweak cachedShortcutItems];
    NSString *bundleIdentifier = [self applicationBundleIdentifier];

    if (!bundleIdentifier || ![bundleIdentifier isKindOfClass:%c(NSString)]) {
        return originalApplicationShortcutItems;
    }

    SBSApplicationShortcutItem *applicationShortcutItem = [launchInSafeModeTweakCachedShortcutItems objectForKey:bundleIdentifier];
    if (!applicationShortcutItem) {
        applicationShortcutItem = [[%c(SBSApplicationShortcutItem) alloc] init];

        [applicationShortcutItem setLocalizedTitle:@"Safe Mode"];
        [applicationShortcutItem setBundleIdentifierToLaunch:bundleIdentifier];
        [applicationShortcutItem setType:kLaunchInSafeModeTweakShortcutItemIdentifier];

        [launchInSafeModeTweakCachedShortcutItems setObject:applicationShortcutItem forKey:bundleIdentifier];
        [applicationShortcutItem release];
    }

    if (![originalApplicationShortcutItems isKindOfClass:%c(NSMutableArray)]) {
        NSMutableArray *newApplicationShortcutItems = [originalApplicationShortcutItems mutableCopy];
        [newApplicationShortcutItems addObject:applicationShortcutItem];

        return [newApplicationShortcutItems autorelease];
    }

    [originalApplicationShortcutItems addObject:applicationShortcutItem];
    return originalApplicationShortcutItems;
}

- (void)_installedAppsDidChange:(NSNotification *)installedAppsChangedNotification {
    NSDictionary *installedAppsChangedNotificationUserInfo = [installedAppsChangedNotification userInfo];
    NSSet *removedApplicationBundleIdentifiers = [installedAppsChangedNotificationUserInfo objectForKey:@"SBInstalledApplicationsRemovedBundleIDs"];

    if (removedApplicationBundleIdentifiers) {
        LaunchInSafeModeTweak *launchInSafeModeTweak = [LaunchInSafeModeTweak sharedInstance];
        NSMutableDictionary *launchInSafeModeTweakCachedShortcutItems = [launchInSafeModeTweak cachedShortcutItems];

        for (NSString *removedApplicationBundleIdentifier in removedApplicationBundleIdentifiers) {
            [launchInSafeModeTweakCachedShortcutItems removeObjectForKey:removedApplicationBundleIdentifier];
        }
    }

    %orig();
}

%end
%end

%ctor {
    if (IS_IOS_BETWEEN(iOS_10_0, iOS_10_2)) {
        %init(iOS10);
    }
}
