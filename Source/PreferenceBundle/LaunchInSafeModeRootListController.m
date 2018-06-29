//
//  Source/PreferenceBundle/LaunchInSafeModeRootListController.m
//  LaunchInSafeMode
//
//  Created by inoahdev on 5/20/17.
//  Copyright © 2017 - 2018 inoahdev. All rights reserved.
//

#import "LaunchInSafeModeRootListController.h"

@implementation LaunchInSafeModeRootListController
- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"LaunchInSafeMode" target:self] retain];
    }

    return _specifiers;
}

- (void)openURL:(NSURL *)url {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"

    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:url options:@{} completionHandler:nil];
    } else {
        [application openURL:url];
    }

    #pragma clang diagnostic pop
}

- (void)twitter {
    @autoreleasepool {
        UIApplication *application = [UIApplication sharedApplication];
        if ([application canOpenURL:[NSURL URLWithString:@"tweetbot:"]]) {
            [self openURL:[NSURL URLWithString:@"tweetbot:///user_profile/inoahdev"]];
        } else if ([application canOpenURL:[NSURL URLWithString:@"twitterrific:"]]) {
            [self openURL:[NSURL URLWithString:@"twitterrific://user?screen_name=inoahdev"]];
        } else if ([application canOpenURL:[NSURL URLWithString:@"twitter:"]]) {
            [self openURL:[NSURL URLWithString:@"twitter://user?screen_name=inoahdev"]];
        } else {
            [self openURL:[NSURL URLWithString:@"https://twitter.com/inoahdev"]];
        }
    }
}

- (void)github {
    @autoreleasepool {
        [self openURL:[NSURL URLWithString:@"https://github.com/inoahdev/LaunchInSafeMode"]];
    }
}
@end
