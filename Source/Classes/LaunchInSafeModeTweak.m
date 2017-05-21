//
//  Source/Classes/LaunchInSafeModeTweak.m
//  LaunchInSafeMode
//
//  Created by inoahdev on 5/20/17.
//  Copyright © 2017 inoahdev. All rights reserved.
//

#include "LaunchInSafeModeTweak.h"

@interface LaunchInSafeModeTweak ()
@end

static NSDictionary *preferences;
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

@implementation LaunchInSafeModeTweak
+ (instancetype)sharedInstance {
    static LaunchInSafeModeTweak *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[LaunchInSafeModeTweak alloc] init];

        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                        NULL,
                                        (CFNotificationCallback)LoadPreferences,
                                        (__bridge CFStringRef)@"iNoahDevLaunchInSafeModePreferencesChangedNotification",
                                        NULL,
                                        CFNotificationSuspensionBehaviorDeliverImmediately);
        LoadPreferences();
    });

    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _cachedShortcutItems = [[NSMutableDictionary alloc] init];
        _currentApplicationBundleIdentifier = nil;
    }

    return self;
}

- (BOOL)isEnabled {
    return [[preferences objectForKey:@"kEnabled"] boolValue];
}

- (void)dealloc {
    [_cachedShortcutItems release];
    [super dealloc];
}
@end
