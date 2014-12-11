//
//  SyncRestKitConfig.h
//  sync
//
//  Created by Craig Phares on 12/9/14.
//  Copyright (c) 2014 sixoverground. All rights reserved.
//

#import "RestKitConfig.h"

@interface SyncRestKitConfig : RestKitConfig

+ (SyncRestKitConfig *)sharedConfig;

- (void)config;

@end
