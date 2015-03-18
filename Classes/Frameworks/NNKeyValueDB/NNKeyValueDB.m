//
//  WMKeyValueDB.m
//  WorldMate Live
//
//  Created by Natan Abramov on 11/19/14.
//
//

#import "NNKeyValueDB.h"
#import "NNUtilities.h"
#import "NNLogger.h"

@implementation NNKeyValueDB

- (instancetype)init {
    if(self = [super init]) {
        _dictionary = [NSMutableDictionary dictionary];
        _keys = [NSMutableArray array];
        _maxNumberOfRecords = kDefaultMaxNumberOfRecords;
        _databaseID = NSStringFromClass(self.class);
        _persistent = YES;
    }
    return self;
}

- (instancetype)initWithFileName:(NSString *)fileName {
    if(self = [super init]) {
        _persistent = YES;
        //Try to load from file name.
        BOOL defaultFile = [fileName isEqualToString: NSStringFromClass(self.class)];
        id object = [NNUtilities unarchiveObjectFromDocumentsDirectory: fileName];
        //If no file with the specified name, and it's not the default file. Try to load the default file.
        if(!object && !defaultFile) {
            object = [NNUtilities unarchiveObjectFromDocumentsDirectory: NSStringFromClass(self.class)];
        }
        
        //If no file was found - initialize from scratch.
        if(!object) {
            self = [self init];
        } else {
            self = object;
        }
    }
    return self;
}

- (instancetype)initWithDatabaseID:(NSString *)dbID {
    if(self = [self init]) {
        _databaseID = dbID;
    }
    return self;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if(self = [super init]) {
        _databaseID = [decoder decodeObjectForKey: @"db_id"];
        _dictionary = [decoder decodeObjectForKey: @"dictionary"];
        _keys = [decoder decodeObjectForKey: @"hash"];
        _persistent = [[decoder decodeObjectForKey: @"isPersistent"] boolValue];
        NSNumber *maxRecords = [decoder decodeObjectForKey: @"maxNumRecords"];
        _maxNumberOfRecords = [maxRecords unsignedIntegerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    if(_persistent) {
        [encoder encodeObject: _databaseID forKey: @"db_id"];
        
        //Remove objects that do not support being saved to file.
        NSMutableDictionary *temporary = [NSMutableDictionary dictionary];
        for(id key in _keys) {
            id object = _dictionary[key];
            if(![object conformsToProtocol: @protocol(NSCoding)]) {
                temporary[key] = object;
                [_dictionary removeObjectForKey: key];
            }
        }
        //Save the dictionary to file.
        [encoder encodeObject: _dictionary forKey: @"dictionary"];
        
        if(temporary.count > 0) {
            [NNLogger logFromInstance: self message: [self formatMessage: @"Not saved objects"] data: temporary];
        }
        
        //Re-enter the objects that do not support being saved.
        [_dictionary addEntriesFromDictionary: temporary];
        
        [encoder encodeObject: _keys forKey: @"hash"];
        [encoder encodeObject: [NSNumber numberWithBool: _persistent] forKey: @"isPersistent"];
        [encoder encodeObject: [NSNumber numberWithUnsignedInteger: _maxNumberOfRecords] forKey: @"maxNumRecords"];
    }
}

#pragma mark - Setters

- (NNKeyValueDBOperationResult)setObject:(id<NSCoding>)object forKey:(id<NSCopying>)key {
    if(key == nil || object == nil) {
        [NNLogger logFromInstance: self message: [self formatMessage: @"Key and Object must not be 'nil'"]];
        return NNKeyValueDBOperationFailed;
    } else {
        //If key exists, don't manipulate the hash, just move it to be a new key. (i.e. changing the "freshness" of the key).
        BOOL existed = NO;
        if([_keys containsObject: key]) {
            [_keys exchangeObjectAtIndex: [_keys indexOfObject: key] withObjectAtIndex: _keys.count - 1];
            existed = YES;
        } else {
            //If exceeds max number of records, remove the oldest record.
            if(_keys.count >= _maxNumberOfRecords) {
                id oldestKey = _keys[0];
                [_dictionary removeObjectForKey: oldestKey];
                [_keys removeObjectAtIndex: 0];
                
                NSString *message = [self formatMessage: @"Exceeded max records, deleting key"];
                [NNLogger logFromInstance: self message: message data: oldestKey];
            }
            [_keys addObject: key];
        }
        [_dictionary setObject: object forKey: key];
        
        if(existed) {
            [NNLogger logFromInstance: self message: [self formatMessage: @"updated"] data: @{key : object}];
            return NNKeyValueDBOperationObjectUpdated;
        } else {
            [NNLogger logFromInstance: self message: [self formatMessage: @"set"] data: @{key : object}];
            return NNKeyValueDBOperationSuccess;
        }
    }
}

- (void)setObject:(id<NSCoding>)object forKeyedSubscript:(id<NSCopying>)key {
    [self setObject: object forKey: key];
}

#pragma mark - Boolean Handlers

- (BOOL)booleanForKey:(id)key {
    NSNumber *number = [self objectForKey: key];
    return [number boolValue];
}

- (void)setBoolean:(BOOL)boolean forKey:(id<NSCopying>)key {
    NSNumber *number = [NSNumber numberWithBool: boolean];
    [self setObject: number forKey: key];
}

#pragma mark - NSInteger Handlers

- (NSInteger)integerForKey:(id<NSCopying>)key {
    NSNumber *number = [self objectForKey: key];
    return [number integerValue];
}

- (void)setInteger:(NSInteger)integer forKey:(id<NSCopying>)key {
    NSNumber *number = [NSNumber numberWithInteger: integer];
    [self setObject: number forKey: key];
}

#pragma mark - Save Files

- (BOOL)saveDataToFile {
    if(!_persistent) {
        return NO;
    }
    if(!_fileName) {
        self.fileName = NSStringFromClass(self.class);
    }
    [NNLogger logFromInstance: self message: [self formatMessage: @"Saving data with file name"] data: _fileName];
    NSString *filePath = [NNUtilities pathToFileInDocumentsDirectory: _fileName];
    return [NSKeyedArchiver archiveRootObject: self toFile: filePath];
}

#pragma mark - Getters

- (BOOL)isKeySet:(id<NSCopying>)key {
    return [NNUtilities validObjectFromObject: [self objectForKey: key]] != nil;
}

- (id)objectForKey:(id<NSCopying>)key {
    return [_dictionary objectForKey: key];
}

- (id)objectForKeyedSubscript:(id<NSCopying>)key {
    return [self objectForKey: key];
}

- (NSArray *)allKeys {
    return [_dictionary allKeys];
}

#pragma mark - Fast Enumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len {
    return [_dictionary countByEnumeratingWithState: state objects: buffer count: len];
}

#pragma mark - Logger Helpers

- (NSString *)formatMessage:(NSString *)message {
    if(![_databaseID isEqualToString: NSStringFromClass(self.class)]) {
        return [NSString stringWithFormat: @"Database: %@ Message: %@", _databaseID, message];
    } else {
        return message;
    }
}

@end
