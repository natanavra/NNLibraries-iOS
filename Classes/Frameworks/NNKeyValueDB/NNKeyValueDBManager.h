//
//  WMKeyValueDBManager.h
//  WorldMate Live
//
//  Created by Natan Abramov on 11/24/14.
//
//

#import <Foundation/Foundation.h>

@class NNKeyValueDB;

/**
 *  @author natanavra
 *  This class is used in conjunction with NNKeyValueDB.
 *  The singleton automatically listens to UIApplication states (terminate/background) to save the database.
 *  Create a database and add it here so we save it once.
 *  To use a database pull it and use the NNKeyValueDB methods to make changes.
 */
@interface NNKeyValueDBManager : NSObject <NSCoding> {
    NSMutableArray *_databases;
}

/** Singleton */
+ (instancetype)sharedManager;

/** Returns default general purpose key/value database. */
- (NNKeyValueDB *)defaultDatabase;

/** Returns instance of database with given ID. or creates new one if not exist*/
- (NNKeyValueDB *)databaseWithID:(NSString *)databaseID;

/** Removes the database from the manager, only if the database is not the default database. */
- (void)removeDatabaseWithID:(NSString *)databaseID;

/** Saves the file to documents directory using the default file name. */
- (BOOL)saveDataToFile;

/** Clear all databases */
- (void)clearAllDatabases;

@end
