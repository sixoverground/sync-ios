//
//  RestKitService.h
//  viply
//
//  Created by Craig Phares on 11/13/14.
//  Copyright (c) 2014 viply. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface RestKitService : NSObject

@property (strong, nonatomic) RKObjectManager *objectManager;

+ (RestKitService *)sharedService;

- (NSString *)getErrorMessage:(NSError *)error;

@end
