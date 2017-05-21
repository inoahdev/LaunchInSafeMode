//
//  SBSApplicationShortcutItem.h
//  LaunchInSafeMode
//
//  Created by inoahdev on 5/20/17.
//  Copyright © 2017 inoahdev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBSApplicationShortcutItem : NSObject
@property (nonatomic, copy) NSString *localizedTitle;
@property (nonatomic, copy) NSString *bundleIdentifierToLaunch;
@property (nonatomic, copy) NSString *type;
@end
