#import "Event.h"
#import "SyncService.h"

@interface Event ()

// Private interface goes here.

@end

@implementation Event

// Custom logic goes here.

+ (NSDate *)maxUpdatedAt:(NSManagedObjectContext *)managedObjectContext {
  NSDate *date = nil;
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:[[Event class] entityName] inManagedObjectContext:managedObjectContext];
  [request setEntity:entity];
  [request setResultType:NSDictionaryResultType];
  NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"updatedAt"];
  NSExpression *maxUpdatedAtExpression = [NSExpression expressionForFunction:@"max:" arguments:[NSArray arrayWithObject:keyPathExpression]];
  NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
  [expressionDescription setName:@"maxUpdatedAt"];
  [expressionDescription setExpression:maxUpdatedAtExpression];
  [expressionDescription setExpressionResultType:NSDateAttributeType];
  [request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
  NSError *error = nil;
  NSArray *objects = [managedObjectContext executeFetchRequest:request error:&error];
  if (objects != nil) {
    if ([objects count] > 0) {
      date = [[objects firstObject] valueForKey:@"maxUpdatedAt"];
    }
  }
  return date;
}

+ (NSArray *)eventsToSync:(NSManagedObjectContext *)managedObjectContext {
  NSArray *events = [[NSArray alloc] init];
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[[Event class] entityName]];
  request.predicate = [NSPredicate predicateWithFormat:@"syncStatus > %d", SyncStatusSynced];
  NSError *error = nil;
  NSArray *objects = [managedObjectContext executeFetchRequest:request error:&error];
  if (objects != nil) {
    events = objects;
  }
  return events;
}

+ (Event *)eventWithUUID:(NSString *)uuid inMOC:managedObjectContext {
  Event *event = nil;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[[Event class] entityName]];
  request.predicate = [NSPredicate predicateWithFormat:@"uuid == %@", uuid];
  NSError *error = nil;
  NSArray *objects = [managedObjectContext executeFetchRequest:request error:&error];
  if (objects != nil) {
    if ([objects count] > 0) {
      event = [objects firstObject];
    }
  }
  return event;
}

- (void)updateWithEvent:(Event *)event {
  self.title = event.title;
  self.deletedAt = event.deletedAt;
  self.updatedAt = event.updatedAt;
}


@end
