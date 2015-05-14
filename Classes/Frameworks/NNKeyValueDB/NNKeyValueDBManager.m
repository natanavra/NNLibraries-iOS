//
//  WMKeyValueDBManager.m
//  WorldMate Live
//
//  Created by Natan Abramov on 11/24/14.
//
//

#import "NNKeyValueDBManager.h"
#import "NNKeyValueDB.h"
#import "NNUtilities.h"
#import "NNLogger.h"

#define kDefaultDBFileName @"NNKeyValueDatabases.dat"

@implementation NNKeyValueDBManager

#pragma mark - Singleton init

+ (instancetype)sharedManager {
    static NNKeyValueDBManager *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
    });
    return _shared;
}

- (instancetype)init {
    if(self = [super init]) {
        NSString *path = [self filePath];
        if([[NSFileManager defaultManager] fileExistsAtPath: path]) {
            self = [NSKeyedUnarchiver unarchiveObjectWithFile: path];
        } else {
            _databases = [NSMutableArray array];
            [self addDatabase: [[NNKeyValueDB alloc] init]];
        }
        
        //Save data when app crashes or goes to background.
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(saveDataToFile) name: UIApplicationWillTerminateNotification object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(saveDataToFile) name: UIApplicationDidEnterBackgroundNotification object: nil];
        
        if([NNUtilities isDebugMode]) {
            //Save data every 2 minutes only in debug mode to bypass the "stop debugging". Regardless of app state.
            [NSTimer scheduledTimerWithTimeInterval: 60.0f * 2
                                             target: self
                                           selector: @selector(saveDataToFile)
                                           userInfo: nil repeats: YES];
        }
    }
    return self;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if(self = [super init]) {
        _databases = [decoder decodeObjectForKey: @"databases"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    NSMutableArray *persistantDBs = [NSMutableArray array];
    for(NNKeyValueDB *db in _databases) {
        if(db.isPersistent) {
            [persistantDBs addObject: db];
        }
    }
    [encoder encodeObject: persistantDBs forKey: @"databases"];
}

#pragma mark - Database Management

- (NNKeyValueDB *)databaseWithID:(NSString *)databaseID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"databaseID MATCHES[c] %@", databaseID];
    NSArray *filtered = [_databases filteredArrayUsingPredicate: predicate];
    id retVal = nil;
    if(filtered.count > 0) {
        retVal = filtered[0];
    } else {
        retVal = [[NNKeyValueDB alloc] initWithDatabaseID: databaseID];
        [self addDatabase: retVal];
    }
    return retVal;
}

- (void)addDatabase:(NNKeyValueDB *)database {
    if(database) {
        [NNLogger logFromInstance: self message: @"Database added" data: database.databaseID];
        [_databases addObject: database];
    } else {
        [NNLogger logFromInstance: self message: @"'nil' database can not be added"];
    }
}

- (void)removeDatabaseWithID:(NSString *)databaseID {
    if(![databaseID isEqualToString: NSStringFromClass(NNKeyValueDB.class)]) {
        id db = [self databaseWithID: databaseID];
        if(db) {
            [NNLogger logFromInstance: self message: @"Removed database" data: databaseID];
            [_databases removeObject: db];
        } else {
            [NNLogger logFromInstance: self message: @"Database does not exist" data: databaseID];
        }
    } else {
        [NNLogger logFromInstance: self message: @"Default database can't be removed!"];
    }
}

- (NNKeyValueDB *)defaultDatabase {
    return [self databaseWithID: @"defaultDatabase"];
}

#pragma mark - File Handling

- (BOOL)saveDataToFile {
    [NNLogger logFromInstance: self message: @"Saving databases"];
    NSString *path = [self filePath];
    BOOL success = [NSKeyedArchiver archiveRootObject: self toFile: path];
    return success;
}

- (NSString *)filePath {
    return [NNUtilities pathToFileInDocumentsDirectory: kDefaultDBFileName];
}

- (void)clearAllDatabases {
    [NNLogger logFromInstance: self message: @"Clearing all databases"];
    _databases = [NSMutableArray array];
    [self saveDataToFile];
}

@end
