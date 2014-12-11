//
//  RestKitConfig.h
//  viply
//
//  Created by Craig Phares on 11/13/14.
//  Copyright (c) 2014 viply. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>

@interface RestKitConfig : NSObject

@property (strong, nonatomic) RKObjectManager *objectManager;
@property (strong, nonatomic) NSIndexSet *successfulStatusCodes;

+ (id)sharedConfig;

- (void)configWithURL:(NSString *)url accept:(NSString *)accept userAgent:(NSString *)userAgent;

@end
