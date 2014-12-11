//
//  RestKitService.m
//  viply
//
//  Created by Craig Phares on 11/13/14.
//  Copyright (c) 2014 viply. All rights reserved.
//

#import "RestKitService.h"

@implementation RestKitService

@synthesize objectManager;

+ (RestKitService *)sharedService {
  static RestKitService *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
    sharedInstance.objectManager = [RKObjectManager sharedManager];
  });
  return sharedInstance;
}

/// Parse the error message.
- (NSString *)getErrorMessage:(NSError *)error {
  RKErrorMessage *errorMessage = [[error.userInfo
                                   objectForKey:RKObjectMapperErrorObjectsKey]
                                  firstObject];
  // Handle unmapped error.
  if (errorMessage == nil) {
    return [error.userInfo objectForKey:NSLocalizedDescriptionKey];
  }
  // Handle mapped error.
  return errorMessage.errorMessage;
}

@end
