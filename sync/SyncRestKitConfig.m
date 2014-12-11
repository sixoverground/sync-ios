//
//  SyncRestKitConfig.m
//  sync
//
//  Created by Craig Phares on 12/9/14.
//  Copyright (c) 2014 sixoverground. All rights reserved.
//

#import "SyncRestKitConfig.h"
#import "Constants.h"
#import "Event.h"
#import "SyncRequest.h"
#import "SyncResponse.h"
#import "SyncObjectResponse.h"
#import "SyncErrorResponse.h"

@implementation SyncRestKitConfig

+ (SyncRestKitConfig *)sharedConfig {
  static SyncRestKitConfig *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (void)config {
  
  // Configure basics.
  NSString *url = [NSString stringWithFormat:@"%@%@", kWebServiceServer, kWebServiceEndpoint];
  [super configWithURL:url accept:kWebServiceAccept userAgent:kWebServiceUserAgent];
  
  // Core Data
  // ===========================================================================
  
  // Create RestKit managed object store.
  // NSManagedObjectModel *managedObjectModel = [[DataStore sharedStore] managedObjectModel];
  NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
  RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
  self.objectManager.managedObjectStore = managedObjectStore;
  
  // Request Mappings
  // ===========================================================================
  
  RKObjectMapping *syncRequestMapping = [RKObjectMapping requestMapping];
  [syncRequestMapping
   addAttributeMappingsFromDictionary:@{
                                        @"updatedAt": @"updated_at"
                                        }];
  
//  RKObjectMapping *eventRequestMapping = [RKObjectMapping requestMapping];
//  [eventRequestMapping
//   addAttributeMappingsFromDictionary:@{
//                                        @"uuid": @"uuid",
//                                        @"title": @"title",
//                                        @"deletedAt": @"deleted_at",
//                                        @"updatedAt": @"updated_at"
//                                        }];

  
  // Response Mappings
  // ===========================================================================
  
  RKObjectMapping *syncResponseMapping = [RKObjectMapping
                                          mappingForClass:[SyncResponse class]];
  
  RKObjectMapping *syncEventObjectResponseMapping = [RKObjectMapping
                                                     mappingForClass:[SyncObjectResponse class]];
  
  RKEntityMapping *eventResponseMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([Event class]) inManagedObjectStore:managedObjectStore];
  eventResponseMapping.identificationAttributes = @[@"uuid"];
  [eventResponseMapping
   addAttributeMappingsFromDictionary:@{
                                        @"uuid": @"uuid",
                                        @"title": @"title",
                                        @"deleted_at": @"deletedAt",
                                        @"updated_at": @"updatedAt"
                                        }];
  
  RKObjectMapping *syncErrorResponseMapping = [RKObjectMapping
                                               mappingForClass:[SyncErrorResponse class]];
  [syncErrorResponseMapping
   addAttributeMappingsFromDictionary:@{
                                        @"uuid": @"uuid",
                                        @"message": @"message"
                                        }];

  
  // Relational Mappings
  // ===========================================================================
  
  [syncRequestMapping
   addPropertyMapping:[RKRelationshipMapping
                       relationshipMappingFromKeyPath:@"events"
                       toKeyPath:@"events"
                       withMapping:[eventResponseMapping inverseMapping]]];
  
  [syncResponseMapping
   addPropertyMapping:[RKRelationshipMapping
                       relationshipMappingFromKeyPath:@"events"
                       toKeyPath:@"events"
                       withMapping:syncEventObjectResponseMapping]];

  [syncEventObjectResponseMapping
   addPropertyMapping:[RKRelationshipMapping
                       relationshipMappingFromKeyPath:@"success"
                       toKeyPath:@"success"
                       withMapping:eventResponseMapping]];

  [syncEventObjectResponseMapping
   addPropertyMapping:[RKRelationshipMapping
                       relationshipMappingFromKeyPath:@"error"
                       toKeyPath:@"error"
                       withMapping:syncErrorResponseMapping]];
  
  // Dynamic Mappings
  // ===========================================================================
  
  
  // Request/Response Descriptors
  // ===========================================================================
  
  RKRequestDescriptor *syncRequestDescriptor = [RKRequestDescriptor
                                                requestDescriptorWithMapping:syncRequestMapping
                                                objectClass:[SyncRequest class]
                                                rootKeyPath:nil
                                                method:RKRequestMethodPOST];
  [self.objectManager addRequestDescriptor:syncRequestDescriptor];

  RKResponseDescriptor *syncResponseDescriptor = [RKResponseDescriptor
                                                  responseDescriptorWithMapping:syncResponseMapping
                                                  method:RKRequestMethodPOST
                                                  pathPattern:@"sync"
                                                  keyPath:nil
                                                  statusCodes:self.successfulStatusCodes];
  [self.objectManager addResponseDescriptor:syncResponseDescriptor];
  
  // Create application data directory
  // ===========================================================================
  
  NSError *error = nil;
  BOOL success = RKEnsureDirectoryExistsAtPath(RKApplicationDataDirectory(), &error);
  if (!success) {
    RKLogError(@"Failed to create Application Data Directory at path '%@': %@", RKApplicationDataDirectory(), error);
  }
  
  // Persistent Data
  // ===========================================================================
  
  [managedObjectStore createPersistentStoreCoordinator];
  NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"sync.sqlite"];
  //  NSString *seedPath = [[NSBundle mainBundle] pathForResource:@"SeedDatabase" ofType:@"sqlite"];
  NSString *seedPath = nil;
  
  // Migrations.
  NSDictionary *options = @{
                            NSMigratePersistentStoresAutomaticallyOption: @YES,
                            NSInferMappingModelAutomaticallyOption: @YES
                            };
  
  NSPersistentStore *persistentStore = [managedObjectStore
                                        addSQLitePersistentStoreAtPath:storePath
                                        fromSeedDatabaseAtPath:seedPath
                                        withConfiguration:nil
                                        options:options
                                        error:&error];
  if (!persistentStore) {
    RKLogError(@"Failed adding persistent store at path '%@': %@", storePath, error);
  }
  [managedObjectStore createManagedObjectContexts];
  
  // Configure a managed object cache to ensure we do not create duplicate objects
  managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc]
                                           initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
}

@end
