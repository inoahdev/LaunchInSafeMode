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
        NSNumber *enabledNumber = [[NSNumber alloc] initWithBool:YES];
        preferences = [[NSDictionary alloc] initWithObjectsAndKeys:enabledNumber, @"kEnabled", nil];

        [enabledNumber release];
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
        _safeModeNumber = [[NSNumber alloc] initWithBool:YES];
    }

    return self;
}

- (BOOL)isEnabled {
    return [[preferences objectForKey:@"kEnabled"] boolValue];
}

- (void)dealloc {
    [_cachedShortcutItems release];
    [_safeModeNumber release];

    [preferences release];
    [super dealloc];
}
@end
