//
//  SyncService.m
//  sync
//
//  Created by Craig Phares on 12/10/14.
//  Copyright (c) 2014 sixoverground. All rights reserved.
//

#import "SyncService.h"
#import "Constants.h"
#import "SyncRestKitConfig.h"
#import "SyncRequest.h"
#import "SyncResponse.h"
#import "SyncObjectResponse.h"
#import "SyncErrorResponse.h"
#import "Event.h"

@interface SyncService ()

@property (nonatomic) BOOL syncInProgress;

@end

@implementation SyncService

//NSString *const kLastSyncedAt = @"lastSyncedAt";

+ (SyncService *)sharedService {
  static SyncService *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
    sharedInstance.objectManager = [SyncRestKitConfig sharedConfig].objectManager;
  });
  return sharedInstance;
}

- (void)sync {
  if (!self.syncInProgress) {
    self.syncInProgress = YES;
    [self syncToServer];
  }
}

- (void)syncToServer {
  
  NSManagedObjectContext *managedObjectContext = [[RKManagedObjectStore defaultStore] newChildManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType tracksChanges:YES];
  
  // Find the most recent updated at property.
  NSDate *maxUpdatedAt = [Event maxUpdatedAt:managedObjectContext];
  
  // Find events marked as updated.
  NSArray *events = [Event eventsToSync:managedObjectContext];
  
  // Create the sync request.
  SyncRequest *syncRequest = [SyncRequest new];
  syncRequest.updatedAt = maxUpdatedAt;
  syncRequest.events = events;
  
  // Sync to server.
  [self.objectManager
   postObject:syncRequest
   path:@"sync"
   parameters:nil
   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
     SyncResponse *syncResponse = [mappingResult firstObject];
     for (SyncObjectResponse *syncObjectResponse in syncResponse.events) {
       
       // Mark all events as synced.
       for (Event *event in syncObjectResponse.success) {
         Event *eventToSave = [Event eventWithUUID:event.uuid inMOC:managedObjectContext];
         [eventToSave updateWithEvent:event];
         eventToSave.syncStatusValue = SyncStatusSynced;
         
         // Delete object if needed.
         // Disabled to keep sync date.
//         if (eventToSave.deletedAt != nil) {
//           [managedObjectContext deleteObject:eventToSave];
//         }
       }
       
       // Handle errors.
       for (SyncErrorResponse *syncErrorResponse in syncObjectResponse.error) {
         // TODO: Handle error.
         NSLog(@"Sync Error: %@", syncErrorResponse.message);
       }
       
     }
     NSError *error = nil;
     [managedObjectContext saveToPersistentStore:&error];
     [self completeSync];
   }
   failure:^(RKObjectRequestOperation *operation, NSError *error) {
     // TODO: Handle error.
     [self completeSync];
   }];
  
}

- (void)completeSync {
  self.syncInProgress = NO;
}


@end
