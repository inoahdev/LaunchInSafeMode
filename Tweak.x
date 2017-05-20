//
//  Tweak.x
//  LaunchInSafeMode
//
//  Created by inoahdev on 5/20/17.
//  Copyright © 2017 inoahdev. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>

static NSDictionary *preferences = nil;
static CFStringRef applicationID = (__bridge CFStringRef)@"com.inoahdev.launchinsafemode";

static void LoadPreferences() {
    if (CFPreferencesAppSynchronize(applicationID)) {
        CFArrayRef keyList = CFPreferencesCopyKeyList(applicationID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
        if (keyList) {
            preferences = (NSDictionary *)CFPreferencesCopyMultiple(keyList, applicationID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
            CFRelease(keyList);
        }
    }

    if (!preferences) {
        preferences = @{ @"kEnabled" : @YES };
    }
}

%hook SBApplicationShortcutStoreManager
- (NSArray<SBSApplicationShortcutItem *> *)applicationShortcutItemsForBundleIdentifier:(NSString*)bundleIdentifier withVersion:(NSUInteger)version {
    NSArray<SBSApplicationShortcutItem *> *applicationShortcutItems = %orig();
    BOOL hasLaunchInSafeModeShortcutItem = NO;

    for (SBSApplicationShortcutItem *applicationShortcutItem in applicationShortcutItems) {
        NSString *applicationShortcutItemType = [applicationShortcutItem type];
        if (![applicationShortcutItemType isEqualToString:@"kLaunchInSafeModeTweakLaunchInSafeMode"]) {
            continue;
        }

        hasLaunchInSafeModeShortcutItem = YES;
        break;
    }

    if (!hasLaunchInSafeModeShortcutItem) {
        SBSApplicationShortcutItem *applicationShortcutItem = [[SBSApplicationShortcutItem alloc] init];

        [applicationShortcutItem setLocalizedTitle:@"Launch in Safe Mode"];
        [applicationShortcutItem setBundleIdentifierToLaunch:bundleIdentifier];
        [applicationShortcutItem setType:@"kLaunchInSafeModeTweakLaunchInSafeMode"];

        NSMutableArray *applicationShortcutItems = [[NSMutableArray alloc] initWithObjects:applicationShortcutItem, nil];
        NSArray *applicationShortcutItemsCopy = [applicationShortcutItems copy];

        [[SBApplicationShortcutStoreManager sharedManager] setApplicationShortcutItems:applicationShortcutItemsCopy forBundleIdentifier:bundleIdentifier withVersion:version];

        [applicationShortcutItemsCopy release];
        [applicationShortcutItems release];
        [applicationShortcutItem release];

        return %orig();
    }

    return applicationShortcutItems;
}
%end

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                            NULL,
                                            (CFNotificationCallback)LoadPreferences,
                                            (__bridge CFStringRef)@"iNoahDevLaunchInSafeModePreferencesChangedNotification",
                                            NULL,
                                            CFNotificationSuspensionBehaviorDeliverImmediately);
    LoadPreferences();
}
