//
//  Source/Hooks/SBApplicationShortcutStoreManager.x
//  LaunchInSafeMode
//
//  Created by inoahdev on 5/20/17.
//  Copyright © 2017 - 2018 inoahdev. All rights reserved.
//

#import <version.h>
#import "../Classes/LaunchInSafeModeTweak.h"

#import "../Headers/SpringBoardServices/SBSApplicationShortcutItem.h"
#import "../Headers/SpringBoardUI/SBUIAppIconForceTouchControllerDataProvider.h"

%group iOS10Up
%hook SBUIAppIconForceTouchControllerDataProvider
- (NSArray *)applicationShortcutItems {
    LaunchInSafeModeTweak *tweak = [LaunchInSafeModeTweak sharedInstance];
    NSMutableArray *originalShortcutItems = (NSMutableArray *)%orig();

    BOOL isEnabled = [tweak isEnabled];
    if (!isEnabled) {
        return originalShortcutItems;
    }

    NSMutableDictionary *cachedShortcutItems = [tweak cachedShortcutItems];
    NSString *bundleIdentifier = [self applicationBundleIdentifier];

    if (!bundleIdentifier || ![bundleIdentifier isKindOfClass:%c(NSString)]) {
        return originalShortcutItems;
    }

    SBSApplicationShortcutItem *shortcutItem =
        [cachedShortcutItems objectForKey:bundleIdentifier];

    if (!shortcutItem) {
        shortcutItem = [[%c(SBSApplicationShortcutItem) alloc] init];

        [shortcutItem setLocalizedTitle:@"Safe Mode"];
        [shortcutItem setBundleIdentifierToLaunch:bundleIdentifier];
        [shortcutItem setType:kLaunchInSafeModeShortcutItemIdentifier];

        [cachedShortcutItems setObject:shortcutItem forKey:bundleIdentifier];
        [shortcutItem release];
    }

    if (![originalShortcutItems isKindOfClass:%c(NSMutableArray)]) {
        NSMutableArray *newShortcutItems = [originalShortcutItems mutableCopy];
        [newShortcutItems addObject:shortcutItem];

        return [newShortcutItems autorelease];
    }

    [originalShortcutItems addObject:shortcutItem];
    return originalShortcutItems;
}

%end
%end

%ctor {
    if (IS_IOS_BETWEEN(iOS_10_0, iOS_11_2)) {
        %init(iOS10Up);
    }
}
