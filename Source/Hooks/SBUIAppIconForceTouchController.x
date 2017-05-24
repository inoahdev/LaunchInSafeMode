//
//  Source/Hooks/SBUIAppIconForceTouchController.x
//  LaunchInSafeMode
//
//  Created by inoahdev on 5/20/17.
//  Copyright © 2017 inoahdev. All rights reserved.
//

#import <version.h>
#import "../Classes/LaunchInSafeModeTweak.h"

#import "../Headers/FrontBoard/FBSystemService.h"
#import "../Headers/SpringBoardUI/SBUIAppIconForceTouchShortcutViewController.h"

static NSString *const kLaunchInSafeModeTweakShortcutItemIdentifier = @"com.inoahdev.launchinsafemode.safemode";

%group iOS10
%hook SBUIAppIconForceTouchController
- (void)appIconForceTouchShortcutViewController:(SBUIAppIconForceTouchShortcutViewController *)appIconForceTouchShortcutViewController activateApplicationShortcutItem:(SBSApplicationShortcutItem *)applicationShortcutItem {
    NSString *applicationShortcutItemType = [applicationShortcutItem type];
    if (![applicationShortcutItemType isEqualToString:kLaunchInSafeModeTweakShortcutItemIdentifier]) {
        return %orig();
    }

    LaunchInSafeModeTweak *launchInSafeModeTweak = [LaunchInSafeModeTweak sharedInstance];
    NSString *currentApplicationBundleIdentifier = [applicationShortcutItem bundleIdentifierToLaunch];

    [launchInSafeModeTweak setCurrentApplicationBundleIdentifier:currentApplicationBundleIdentifier];
    [[%c(FBSystemService) sharedInstance] terminateApplication:currentApplicationBundleIdentifier forReason:1 andReport:YES withDescription:nil source:[%c(BSAuditToken) tokenForCurrentProcess] completion:nil];

    %orig();
}

%end
%end

%ctor {
    if (IS_IOS_BETWEEN(iOS_10_0, iOS_10_2)) {
        %init(iOS10);
    }
}
