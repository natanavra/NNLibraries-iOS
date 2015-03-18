//
//  WMKeyValueDB.h
//  WorldMate Live
//
//  Created by Natan Abramov on 11/19/14.
//
//

#import <Foundation/Foundation.h>

#define kDefaultMaxNumberOfRecords 50

typedef enum {
    NNKeyValueDBOperationFailed,
    NNKeyValueDBOperationSuccess,
    NNKeyValueDBOperationObjectUpdated,
} NNKeyValueDBOperationResult;

/**
 *  @author natanavra
 *  Base class for key-value database with maximum number of values.
 */
@interface NNKeyValueDB : NSObject <NSFastEnumeration, NSCoding> {
    NSMutableDictionary *_dictionary;
    /** All of the keys ordered by time added, for easy "max size" management */
    NSMutableArray *_keys;
}
/** Just in case somebody wants to pull the database from singleton by id. */
@property (nonatomic) NSString *databaseID;

/** Tries to load the database from the file name specified. If does not exist, falls back to default file name. */
- (instancetype)initWithFileName:(NSString *)fileName;

- (instancetype)initWithDatabaseID:(NSString *)dbID;

/** Specify the maximum number of records in the dictionay, if exceeded, delete the oldest record. */
@property (nonatomic) NSUInteger maxNumberOfRecords;

/** Determines if the database will be saved to file or not. Defaults to YES. */
@property (nonatomic, getter=isPersistent) BOOL persistent;

/** The file name to which the database will be saved, if not specified the class name will be used. */
@property (nonatomic, strong) NSString *fileName;

/** Objects that do not conform to the <NSCoding> protocol will not be saved. */
- (NNKeyValueDBOperationResult)setObject:(id)object forKey:(id<NSCopying>)key;
/* Support subscripting, e.g. set values like so 'baseKeyValueDB["myvalue"] = myNewValue' */
- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)key;

- (id)objectForKey:(id<NSCopying>)key;
/* Support subscripting, e.g. get values like so: 'value = baseKeyValueDB["myValue"]' */
- (id)objectForKeyedSubscript:(id<NSCopying>)key;

- (BOOL)booleanForKey:(id<NSCopying>)key;
- (void)setBoolean:(BOOL)boolean forKey:(id<NSCopying>)key;

- (NSInteger)integerForKey:(id<NSCopying>)key;
- (void)setInteger:(NSInteger)integer forKey:(id<NSCopying>)key;

- (NSArray *)allKeys;
- (BOOL)saveDataToFile;

- (BOOL)isKeySet:(id<NSCopying>)key;

@end
