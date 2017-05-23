//
//  Source/Hooks/SBUIAppIconForceTouchController.x
//  LaunchInSafeMode
//
//  Created by inoahdev on 5/20/17.
//  Copyright © 2017 inoahdev. All rights reserved.
//

#include "../Classes/LaunchInSafeModeTweak.h"

#include "../Headers/FrontBoardServices/FBSystemService.h"
#include "../Headers/SpringBoardUI/SBUIAppIconForceTouchShortcutViewController.h"

static NSString *const kLaunchInSafeModeTweakShortcutItemIdentifier = @"com.inoahdev.launchinsafemode.safemode";

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
