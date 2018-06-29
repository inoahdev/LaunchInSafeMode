//
//  Source/Headers/SpringBoard/SBApplicationShortcutStoreManager.h
//  LaunchInSafeMode
//
//  Created by inoahdev on 5/20/17.
//  Copyright © 2017 - 2018 inoahdev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBApplicationShortcutStoreManager : NSObject
+ (instancetype)sharedManager;
- (void)setApplicationShortcutItems:(NSArray *)applicationShortcutItems forBundleIdentifier:(NSString *)bundleIdentifier withVersion:(unsigned long long)version;
@end
