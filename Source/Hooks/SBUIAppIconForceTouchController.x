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

%group iOS10Up
%hook SBUIAppIconForceTouchController
- (void)appIconForceTouchShortcutViewController:(SBUIAppIconForceTouchShortcutViewController *)shortcutViewController activateApplicationShortcutItem:(SBSApplicationShortcutItem *)shortcutItem {
    NSString *shortcutItemType = [shortcutItem type];
    if (![shortcutItemType isEqualToString:kLaunchInSafeModeShortcutItemIdentifier]) {
        return %orig();
    }

    LaunchInSafeModeTweak *tweak = [LaunchInSafeModeTweak sharedInstance];

    NSString *bundleIdentifier = [shortcutItem bundleIdentifierToLaunch];
    [tweak setCurrentBundleIdentifier:bundleIdentifier];

    BSAuditToken *token = [%c(BSAuditToken)tokenForCurrentProcess];
    [[%c(FBSystemService) sharedInstance] terminateApplication:bundleIdentifier
                                                     forReason:1
                                                     andReport:NO
                                               withDescription:nil
                                                        source:token
                                                    completion:nil];

    %orig();
}

%end
%end

%ctor {
    if (IS_IOS_BETWEEN(iOS_10_0, iOS_11_2)) {
        %init(iOS10Up);
    }
}
