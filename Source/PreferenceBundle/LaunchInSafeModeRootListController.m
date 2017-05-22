//
//  Source/PreferenceBundle/LaunchInSafeModeRootListController.m
//  LaunchInSafeMode
//
//  Created by inoahdev on 5/20/17.
//  Copyright © 2017 inoahdev. All rights reserved.
//

#include "LaunchInSafeModeRootListController.h"

@implementation LaunchInSafeModeRootListController
- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"LaunchInSafeMode" target:self] retain];
    }

    return _specifiers;
}
@end
