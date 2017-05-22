//
//  Source/Classes/LaunchInSafeModeTweak.h
//  LaunchInSafeMode
//
//  Created by inoahdev on 5/20/17.
//  Copyright © 2017 inoahdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Headers/SpringBoardServices/SBSApplicationShortcutItem.h"

@interface LaunchInSafeModeTweak : NSObject
+ (instancetype)sharedInstance;
- (BOOL)isEnabled;

@property (nonatomic, strong) NSString *currentApplicationBundleIdentifier;
@property (nonatomic, strong) NSNumber *safeModeNumber;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray<SBSApplicationShortcutItem *> *> *cachedShortcutItems;
@end
