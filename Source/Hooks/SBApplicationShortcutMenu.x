//
//  Source/Hooks/SBApplicationShortcutMenu.x
//  LaunchInSafeMode
//
//  Created by inoahdev on 5/20/17.
//  Copyright © 2017 inoahdev. All rights reserved.
//

#import <version.h>

#import "../Classes/LaunchInSafeModeTweak.h"
#import "../Headers/SpringBoard/SBApplicationShortcutMenu.h"

static NSString *const kLaunchInSafeModeTweakShortcutItemIdentifier = @"com.inoahdev.launchinsafemode.safemode";

%group iOS9
%hook SBApplicationShortcutMenu
- (NSArray<SBSApplicationShortcutItem *> *)_shortcutItemsToDisplay {
    LaunchInSafeModeTweak *launchInSafeModeTweak = [LaunchInSafeModeTweak sharedInstance];
    NSMutableArray *originalApplicationShortcutItems = (NSMutableArray *)%orig();

    BOOL launchInSafeModeTweakIsEnabled = [launchInSafeModeTweak isEnabled];
    if (!launchInSafeModeTweakIsEnabled) {
        return originalApplicationShortcutItems;
    }


    SBApplication *application = [self application];
    NSString *applicationBundleIdentifier = [application bundleIdentifier];

    NSMutableDictionary *launchInSafeModeTweakCachedShortcutItems = [launchInSafeModeTweak cachedShortcutItems];
    SBSApplicationShortcutItem *applicationShortcutItem = [launchInSafeModeTweakCachedShortcutItems objectForKey:applicationBundleIdentifier];

    if (!applicationShortcutItem) {
        applicationShortcutItem = [[%c(SBSApplicationShortcutItem) alloc] init];

        [applicationShortcutItem setLocalizedTitle:@"Safe Mode"];
        [applicationShortcutItem setBundleIdentifierToLaunch:applicationBundleIdentifier];
        [applicationShortcutItem setType:kLaunchInSafeModeTweakShortcutItemIdentifier];

        [launchInSafeModeTweakCachedShortcutItems setObject:applicationShortcutItem forKey:applicationBundleIdentifier];
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

%end
%end

%ctor {
    if (IS_IOS_BETWEEN(iOS_9_0, iOS_9_3)) {
        %init(iOS9);
    }
}
