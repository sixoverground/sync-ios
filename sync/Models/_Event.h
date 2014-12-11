// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Event.h instead.

@import CoreData;

extern const struct EventAttributes {
	__unsafe_unretained NSString *deletedAt;
	__unsafe_unretained NSString *syncStatus;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *updatedAt;
	__unsafe_unretained NSString *uuid;
} EventAttributes;

@interface EventID : NSManagedObjectID {}
@end

@interface _Event : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) EventID* objectID;

@property (nonatomic, strong) NSDate* deletedAt;

//- (BOOL)validateDeletedAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* syncStatus;

@property (atomic) int16_t syncStatusValue;
- (int16_t)syncStatusValue;
- (void)setSyncStatusValue:(int16_t)value_;

//- (BOOL)validateSyncStatus:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* updatedAt;

//- (BOOL)validateUpdatedAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* uuid;

//- (BOOL)validateUuid:(id*)value_ error:(NSError**)error_;

@end

@interface _Event (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveDeletedAt;
- (void)setPrimitiveDeletedAt:(NSDate*)value;

- (NSNumber*)primitiveSyncStatus;
- (void)setPrimitiveSyncStatus:(NSNumber*)value;

- (int16_t)primitiveSyncStatusValue;
- (void)setPrimitiveSyncStatusValue:(int16_t)value_;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (NSDate*)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(NSDate*)value;

- (NSString*)primitiveUuid;
- (void)setPrimitiveUuid:(NSString*)value;

@end
