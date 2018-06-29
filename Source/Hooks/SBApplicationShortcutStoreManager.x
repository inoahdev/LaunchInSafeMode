//
//  Source/Hooks/SBApplicationShortcutStoreManager.x
//  LaunchInSafeMode
//
//  Created by inoahdev on 6/29/18.
//  Copyright © 2017 inoahdev. All rights reserved.
//

#import <version.h>
#import "../Classes/LaunchInSafeModeTweak.h"

%group iOS9Up
%hook SBApplicationShortcutStoreManager
- (void)_installedAppsDidChange:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSSet *removedBundleIdentifiers =
        [userInfo objectForKey:@"SBInstalledApplicationsRemovedBundleIDs"];

    if (removedBundleIdentifiers) {
        LaunchInSafeModeTweak *tweak = [LaunchInSafeModeTweak sharedInstance];
        NSMutableDictionary *cachedShortcutItems = [tweak cachedShortcutItems];

        for (NSString *removedBundleIdentifier in removedBundleIdentifiers) {
            [cachedShortcutItems removeObjectForKey:removedBundleIdentifier];
        }
    }

    %orig();
}
%end
%end

%ctor {
    if (IS_IOS_BETWEEN(iOS_9_0, iOS_11_2)) {
        %init(iOS9Up);
    }
}