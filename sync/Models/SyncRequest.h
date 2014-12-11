//
//  SyncRequest.h
//  sync
//
//  Created by Craig Phares on 12/9/14.
//  Copyright (c) 2014 sixoverground. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncRequest : NSObject

@property (strong, nonatomic) NSDate *updatedAt;
@property (strong, nonatomic) NSArray *events;

@end
