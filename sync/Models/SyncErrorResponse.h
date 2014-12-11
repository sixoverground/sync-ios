//
//  SyncErrorResponse.h
//  sync
//
//  Created by Craig Phares on 12/10/14.
//  Copyright (c) 2014 sixoverground. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncErrorResponse : NSObject

@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *message;

@end
