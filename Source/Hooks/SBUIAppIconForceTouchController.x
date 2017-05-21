//
//  Tweak.x
//  LaunchInSafeMode
//
//  Created by inoahdev on 5/20/17.
//  Copyright © 2017 inoahdev. All rights reserved.
//

#include "../Classes/LaunchInSafeModeTweak.h"

#include "../Headers/FrontBoardServices/FBSystemService.h"
#include "../Headers/SpringBoardUI/SBUIAppIconForceTouchShortcutViewController.h"

static NSString *const kLaunchInSafeModeTweakLaunchInSafeMode = @"kLaunchInSafeModeTweakLaunchInSafeMode";

%hook SBUIAppIconForceTouchController
- (void)appIconForceTouchShortcutViewController:(SBUIAppIconForceTouchShortcutViewController *)appIconForceTouchShortcutViewController activateApplicationShortcutItem:(SBSApplicationShortcutItem *)applicationShortcutItem {
    NSString *applicationShortcutItemType = [applicationShortcutItem type];
    if (![applicationShortcutItemType isEqualToString:kLaunchInSafeModeTweakLaunchInSafeMode]) {
        return %orig();
    }

    LaunchInSafeModeTweak *launchInSafeModeTweak = [LaunchInSafeModeTweak sharedInstance];
    NSString *currentApplicationBundleIdentifier = [launchInSafeModeTweak currentApplicationBundleIdentifier];

    [launchInSafeModeTweak setCurrentApplicationBundleIdentifier:[applicationShortcutItem bundleIdentifierToLaunch]];
    [[%c(FBSystemService) sharedInstance] terminateApplication:currentApplicationBundleIdentifier forReason:1 andReport:YES withDescription:nil source:[%c(BSAuditToken) tokenForCurrentProcess] completion:nil];

    %orig();
}
%end
