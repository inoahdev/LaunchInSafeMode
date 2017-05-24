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
    NSArray *originalApplicationShortcutItems = %orig();

    BOOL launchInSafeModeTweakIsEnabled = [launchInSafeModeTweak isEnabled];
    if (!launchInSafeModeTweakIsEnabled) {
        return originalApplicationShortcutItems;
    }

    SBApplication *application = [self application];
    NSString *bundleIdentifier = [application bundleIdentifier];

    NSMutableDictionary *launchInSafeModeTweakCachedShortcutItems = [launchInSafeModeTweak cachedShortcutItems];
    NSArray<SBSApplicationShortcutItem *> *applicationShortcutItems = [launchInSafeModeTweakCachedShortcutItems objectForKey:bundleIdentifier];

    if (applicationShortcutItems) {
        return applicationShortcutItems;
    }

    SBSApplicationShortcutItem *applicationShortcutItem = [[%c(SBSApplicationShortcutItem) alloc] init];

    [applicationShortcutItem setLocalizedTitle:@"Safe Mode"];
    [applicationShortcutItem setBundleIdentifierToLaunch:bundleIdentifier];
    [applicationShortcutItem setType:kLaunchInSafeModeTweakShortcutItemIdentifier];

    NSMutableArray *newApplicationShortcutItems = [originalApplicationShortcutItems mutableCopy];

    [newApplicationShortcutItems addObject:applicationShortcutItem];
    [launchInSafeModeTweakCachedShortcutItems setObject:newApplicationShortcutItems forKey:bundleIdentifier];

    [newApplicationShortcutItems release];
    [applicationShortcutItem release];
    [bundleIdentifier release];

    return [newApplicationShortcutItems autorelease];
}

%end
%end

%ctor {
    if (IS_IOS_BETWEEN(iOS_9_0, iOS_9_3)) {
        %init(iOS9);
    }
}
