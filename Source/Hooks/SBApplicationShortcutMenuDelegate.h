//
//  Source/Hooks/SBApplicationShortcutMenu.x
//  LaunchInSafeMode
//
//  Created by inoahdev on 5/20/17.
//  Copyright © 2017 inoahdev. All rights reserved.
//

#import <version.h>
#import "../Headers/SpringBoardServices/SBSApplicationShortcutItem.h"

static NSString *const kLaunchInSafeModeTweakShortcutItemIdentifier = @"com.inoahdev.launchinsafemode.safemode";

%group iOS9
%hook SBApplicationShortcutMenuDelegate
- (void)applicationShortcutMenu:(SBApplicationShortcutMenu *)applicationShortcutMenu activateShortcutItem:(SBSApplicationShortcutItem *)shortcutItem index:(NSUInteger)index {
    NSString *applicationShortcutItemType = [shortcutItem type];
    if (![applicationShortcutItemType isEqualToString:kLaunchInSafeModeTweakShortcutItemIdentifier]) {
        return %orig();
    }

    LaunchInSafeModeTweak *launchInSafeModeTweak = [LaunchInSafeModeTweak sharedInstance];
    NSString *currentApplicationBundleIdentifier = [shortcutItem bundleIdentifierToLaunch];

    [launchInSafeModeTweak setCurrentApplicationBundleIdentifier:currentApplicationBundleIdentifier];
    [[%c(FBSystemService) sharedInstance] terminateApplication:currentApplicationBundleIdentifier forReason:1 andReport:YES withDescription:nil source:[%c(BSAuditToken) tokenForCurrentProcess] completion:nil];

    %orig();
}

%end
%end

%ctor {
    if (IS_IOS_BETWEEN(iOS_9_0, iOS_9_3_3)) {
        %init(iOS9);
    }
}
