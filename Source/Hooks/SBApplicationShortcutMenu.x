//
//  Source/Hooks/SBApplicationShortcutMenu.x
//  LaunchInSafeMode
//
//  Created by inoahdev on 5/20/17.
//  Copyright © 2017 - 2018 inoahdev. All rights reserved.
//

#import <version.h>

#import "../Classes/LaunchInSafeModeTweak.h"
#import "../Headers/SpringBoard/SBApplicationShortcutMenu.h"

%group iOS9
%hook SBApplicationShortcutMenu
- (NSArray<SBSApplicationShortcutItem *> *)_shortcutItemsToDisplay {
    LaunchInSafeModeTweak *tweak = [LaunchInSafeModeTweak sharedInstance];
    NSMutableArray *originalShortcutItems = (NSMutableArray *)%orig();

    BOOL isEnabled = [tweak isEnabled];
    if (!isEnabled) {
        LaunchInSafeModeLog(@"Tweak is not enabled");
        return originalShortcutItems;
    }

    SBApplication *application = [self application];
    NSString *bundleIdentifier = [application bundleIdentifier];

    NSMutableDictionary *cachedShortcutItems = [tweak cachedShortcutItems];
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

        LaunchInSafeModeLogFormat(@"newShortcutItems: %@", newShortcutItems);
        return [newShortcutItems autorelease];
    }

    [originalShortcutItems addObject:shortcutItem];

    LaunchInSafeModeLogFormat(@"originalShortcutItems: %@", originalShortcutItems);
    return originalShortcutItems;
}

%end
%end

%ctor {
    if (IS_IOS_BETWEEN(iOS_9_0, iOS_9_3)) {
        %init(iOS9);
    }
}
