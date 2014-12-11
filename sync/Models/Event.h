#import "_Event.h"

@interface Event : _Event {}
// Custom logic goes here.

+ (NSDate *)maxUpdatedAt:(NSManagedObjectContext *)managedObjectContext;
+ (NSArray *)eventsToSync:(NSManagedObjectContext *)managedObjectContext;
+ (Event *)eventWithUUID:(NSString *)uuid inMOC:managedObjectContext;

- (void)updateWithEvent:(Event *)event;

@end
