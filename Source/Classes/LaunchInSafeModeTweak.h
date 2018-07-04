//
//  Source/Classes/LaunchInSafeModeTweak.h
//  LaunchInSafeMode
//
//  Created by inoahdev on 5/20/17.
//  Copyright © 2017 - 2018 inoahdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Headers/SpringBoardServices/SBSApplicationShortcutItem.h"

#ifdef DEBUG
#define LaunchInSafeModeLog(str) \
do { \
    NSString *formattedString = [[NSString alloc] initWithFormat:@"%s " str, __PRETTY_FUNCTION__]; \
    [[LaunchInSafeModeTweak sharedInstance] logString:formattedString]; \
    \
    [formattedString release]; \
} while (false);

#define LaunchInSafeModeLogFormat(str, ...) \
do { \
    NSString *formattedString = [[NSString alloc] initWithFormat:@"%s " str, __PRETTY_FUNCTION__, ##__VA_ARGS__]; \
    [[LaunchInSafeModeTweak sharedInstance] logString:formattedString]; \
    \
    [formattedString release]; \
} while (false);
#else
#define LaunchInSafeModeLog(str)
#define LaunchInSafeModeLogFormat(str, ...)
#endif

static NSString *const kLaunchInSafeModeShortcutItemIdentifier =
    @"com.inoahdev.launchinsafemode.safemode";

@interface LaunchInSafeModeTweak : NSObject
+ (instancetype)sharedInstance;
- (BOOL)isEnabled;

#ifdef DEBUG
- (void)logString:(NSString *)string;
#endif

@property (nonatomic, strong) NSString *currentBundleIdentifier;
@property (nonatomic, strong) NSNumber *safeModeNumber;
@property (nonatomic, strong) NSMutableDictionary<NSString *, SBSApplicationShortcutItem *> *cachedShortcutItems;
@end
