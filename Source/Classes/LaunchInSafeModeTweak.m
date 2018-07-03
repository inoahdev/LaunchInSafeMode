//
//  Source/Classes/LaunchInSafeModeTweak.m
//  LaunchInSafeMode
//
//  Created by inoahdev on 5/20/17.
//  Copyright © 2017 - 2018 inoahdev. All rights reserved.
//

#import "LaunchInSafeModeTweak.h"

@interface LaunchInSafeModeTweak ()
@property (nonatomic, strong) NSDictionary *preferences;
@end

#ifdef DEBUG
static FILE *logFile = NULL;
#endif

static CFStringRef applicationID = (__bridge CFStringRef)@"com.inoahdev.launchinsafemode";

static void InitializePreferences(NSDictionary **preferences) {
    if (CFPreferencesAppSynchronize(applicationID)) {
        CFArrayRef keyList =
            CFPreferencesCopyKeyList(applicationID,
                                     kCFPreferencesCurrentUser,
                                     kCFPreferencesAnyHost);

        if (keyList) {
            *preferences =
                (NSDictionary *)CFPreferencesCopyMultiple(
                    keyList,
                    applicationID,
                    kCFPreferencesCurrentUser,
                    kCFPreferencesAnyHost);

            CFRelease(keyList);
        }
    }

    if (!*preferences) {
        NSNumber *enabledNumber = [[NSNumber alloc] initWithBool:YES];
        *preferences =
            [[NSDictionary alloc] initWithObjectsAndKeys:enabledNumber,
                                                         @"kEnabled",
                                                         nil];

        [enabledNumber release];
    }
}

static void LoadPreferences() {
    NSDictionary *preferences = nil;
    InitializePreferences(&preferences);

    LaunchInSafeModeTweak *tweak = [LaunchInSafeModeTweak sharedInstance];
    LaunchInSafeModeLogFormat(@"Loaded preferences: %@, old: %@",
                              preferences,
                              [tweak preferences]);

    [tweak setPreferences:preferences];
}

static CFStringRef preferencesChangedNotificationString =
(__bridge CFStringRef)@"iNoahDevLaunchInSafeModePreferencesChangedNotification";

@implementation LaunchInSafeModeTweak
+ (instancetype)sharedInstance {
    static LaunchInSafeModeTweak *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[LaunchInSafeModeTweak alloc] init];

        CFNotificationCenterAddObserver(
            CFNotificationCenterGetDarwinNotifyCenter(),
            NULL,
            (CFNotificationCallback)LoadPreferences,
            preferencesChangedNotificationString,
            NULL,
            CFNotificationSuspensionBehaviorDeliverImmediately);
    });

    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _cachedShortcutItems = [[NSMutableDictionary alloc] init];
        _currentBundleIdentifier = nil;
        _safeModeNumber = [[NSNumber alloc] initWithBool:YES];

#ifdef DEBUG
        logFile = fopen("/User/LaunchInSafeMode_Logs.txt", "w");
#endif

        InitializePreferences(&_preferences);
    }

    return self;
}

- (BOOL)isEnabled {
    return [[_preferences objectForKey:@"kEnabled"] boolValue];
}

#ifdef DEBUG
- (void)logString:(NSString *)string {
    if (logFile) {
        fprintf(logFile, "%s\n", [string UTF8String]);
        fflush(logFile);
    }
}
#endif

- (void)dealloc {
    [_cachedShortcutItems release];
    [_safeModeNumber release];

#ifdef DEBUG
    if (logFile) {
        fclose(logFile);
    }
#endif

    [_preferences release];
    [super dealloc];
}
@end
