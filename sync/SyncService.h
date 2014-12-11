//
//  SyncService.h
//  sync
//
//  Created by Craig Phares on 12/10/14.
//  Copyright (c) 2014 sixoverground. All rights reserved.
//

#import "RestKitService.h"

typedef NS_ENUM(NSInteger, SyncStatus) {
  SyncStatusSynced,
  SyncStatusUpdated,
  SyncStatusDeleted
};

@interface SyncService : RestKitService

+ (SyncService *)sharedService;

- (void)sync;

@end
