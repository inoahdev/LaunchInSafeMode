//
//  Source/Classes/LaunchInSafeModeTweak.h
//  LaunchInSafeMode
//
//  Created by inoahdev on 5/20/17.
//  Copyright © 2017 inoahdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Headers/SpringBoardServices/SBSApplicationShortcutItem.h"

#ifdef DEBUG
#define LaunchInSafeModeLog(str, ...) \
do { \
    NSString *formattedString = [[NSString alloc] initWithFormat:str, ##__VA_ARGS__]; \
    [[LaunchInSafeModeTweak sharedInstance] logString:formattedString]; \
    \
    [formattedString release]; \
} while (false);
#else
#define LaunchInSafeModeLog(str, ...)
#endif

@interface LaunchInSafeModeTweak : NSObject
+ (instancetype)sharedInstance;
- (BOOL)isEnabled;

- (void)logString:(NSString *)string;

@property (nonatomic, strong) NSString *currentApplicationBundleIdentifier;
@property (nonatomic, strong) NSNumber *safeModeNumber;
@property (nonatomic, strong) NSMutableDictionary<NSString *, SBSApplicationShortcutItem *> *cachedShortcutItems;
@end
