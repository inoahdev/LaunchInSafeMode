//
//  Source/Headers/FrontBoard/FBSystemService.h
//  LaunchInSafeMode
//
//  Created by inoahdev on 5/20/17.
//  Copyright © 2017 - 2018 inoahdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../BaseBoard/BSAuditToken.h"

@interface FBSystemService : NSObject
+ (instancetype)sharedInstance;
- (void)terminateApplication:(NSString *)application forReason:(NSInteger)reason andReport:(BOOL)report withDescription:(NSString *)description source:(BSAuditToken *)source completion:(id)completion;
@end
