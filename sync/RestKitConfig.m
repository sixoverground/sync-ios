//
//  RestKitConfig.m
//  viply
//
//  Created by Craig Phares on 11/13/14.
//  Copyright (c) 2014 viply. All rights reserved.
//

#import "RestKitConfig.h"

@interface RestKitConfig ()

@property (strong, nonatomic) NSIndexSet *clientErrorStatusCodes;
@property (strong, nonatomic) NSIndexSet *serverErrorStatusCodes;

@end

@implementation RestKitConfig

+ (id)sharedConfig {
  static RestKitConfig *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (void)configWithURL:(NSString *)url accept:(NSString *)accept userAgent:(NSString *)userAgent {
  
//  RKLogConfigureByName("RestKit/Network", RKLogLevelDebug);
  RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
  //  RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
  RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelOff);
//  RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelDebug);

  // Setup client and header.
  NSURL *baseURL = [NSURL URLWithString:url];
  AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
  [client setDefaultHeader:@"Accept" value:accept];
  [client setDefaultHeader:@"User-Agent" value:userAgent];
  
  // Initialize RestKit.
  self.objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
  self.objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
  
  // Enable network activity spinner.
  [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
  
  // Define status codes.
  
  // Any response in the 2xx status code range.
  self.successfulStatusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
  // Any response in the 4xx status code range with a "message" key path uses this mapping.
  self.clientErrorStatusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError);
  // Any response in the 5xx status code range with a "message" key path uses this mapping.
  self.serverErrorStatusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassServerError);
  
  // Map errors
  // ----------
  
  RKObjectMapping *clientErrorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
  [clientErrorMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"errorMessage"]];
  RKResponseDescriptor *clientErrorDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:clientErrorMapping
                                                                                             method:RKRequestMethodAny
                                                                                        pathPattern:nil
                                                                                            keyPath:@"message"
                                                                                        statusCodes:self.clientErrorStatusCodes];
  [self.objectManager addResponseDescriptor:clientErrorDescriptor];
  RKObjectMapping *serverErrorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
  [serverErrorMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"errorMessage"]];
  
  RKResponseDescriptor *serverErrorDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:serverErrorMapping
                                                                                             method:RKRequestMethodAny
                                                                                        pathPattern:nil
                                                                                            keyPath:@"message"
                                                                                        statusCodes:self.serverErrorStatusCodes];
  [self.objectManager addResponseDescriptor:serverErrorDescriptor];
  
}

@end
