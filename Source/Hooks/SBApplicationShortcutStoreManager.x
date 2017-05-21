//
//  Tweak.x
//  LaunchInSafeMode
//
//  Created by inoahdev on 5/20/17.
//  Copyright © 2017 inoahdev. All rights reserved.
//

#import "../Classes/LaunchInSafeModeTweak.h"
#import "../Headers/SpringBoardServices/SBSApplicationShortcutItem.h"

static NSString *const kLaunchInSafeModeTweakLaunchInSafeMode = @"kLaunchInSafeModeTweakLaunchInSafeMode";

%hook SBApplicationShortcutStoreManager
- (NSArray<SBSApplicationShortcutItem *> *)applicationShortcutItemsForBundleIdentifier:(NSString *)bundleIdentifier withVersion:(NSUInteger)version {
    LaunchInSafeModeTweak *launchInSafeModeTweak = [LaunchInSafeModeTweak sharedInstance];
    NSMutableDictionary<NSString *, NSArray<SBSApplicationShortcutItem *> *> *cachedShortcutItems = [launchInSafeModeTweak cachedShortcutItems];

    NSArray<SBSApplicationShortcutItem *> *applicationShortcutItems = [cachedShortcutItems objectForKey:bundleIdentifier];
    if (applicationShortcutItems) {
        return applicationShortcutItems;
    }

    SBSApplicationShortcutItem *applicationShortcutItem = [[%c(SBSApplicationShortcutItem) alloc] init];

    [applicationShortcutItem setLocalizedTitle:@"Safe Mode"];
    [applicationShortcutItem setBundleIdentifierToLaunch:bundleIdentifier];
    [applicationShortcutItem setType:kLaunchInSafeModeTweakLaunchInSafeMode];

    NSArray *originalApplicationShortcutItems = %orig();
    NSMutableArray *newApplicationShortcutItems = [[NSMutableArray alloc] initWithArray:originalApplicationShortcutItems];

    [newApplicationShortcutItems addObject:applicationShortcutItem];
    [cachedShortcutItems setObject:newApplicationShortcutItems forKey:bundleIdentifier];

    [newApplicationShortcutItems release];
    [applicationShortcutItem release];

    return newApplicationShortcutItems;
}
%end
