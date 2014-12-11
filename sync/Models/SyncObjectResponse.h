//
//  SyncObjectResponse.h
//  sync
//
//  Created by Craig Phares on 12/10/14.
//  Copyright (c) 2014 sixoverground. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncObjectResponse : NSObject

@property (strong, nonatomic) NSArray *success;
@property (strong, nonatomic) NSArray *error;

@end
