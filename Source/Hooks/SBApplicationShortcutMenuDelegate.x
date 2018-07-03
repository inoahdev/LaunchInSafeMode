//
//  Source/Hooks/SBApplicationShortcutMenu.x
//  LaunchInSafeMode
//
//  Created by inoahdev on 5/20/17.
//  Copyright © 2017 - 2018 inoahdev. All rights reserved.
//

#import <version.h>
#import "../Classes/LaunchInSafeModeTweak.h"

#import "../Headers/BaseBoard/BSAuditToken.h"
#import "../Headers/FrontBoard/FBSystemService.h"
#import "../Headers/SpringBoard/SBApplicationShortcutMenu.h"

%group iOS9
%hook SBApplicationShortcutMenuDelegate
- (void)applicationShortcutMenu:(SBApplicationShortcutMenu *)applicationShortcutMenu activateShortcutItem:(SBSApplicationShortcutItem *)shortcutItem index:(NSUInteger)index {
    NSString *shortcutItemType = [shortcutItem type];
    if (![shortcutItemType isEqualToString:kLaunchInSafeModeShortcutItemIdentifier]) {
        LaunchInSafeModeLogFormat(@"did not invoke LaunchInSafeMode shortcut, invoked shortcut with \"type\": %@", shortcutItemType);
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
    if (IS_IOS_BETWEEN(iOS_9_0, iOS_9_3)) {
        %init(iOS9);
    }
}
