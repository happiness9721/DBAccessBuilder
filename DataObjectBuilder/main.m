//
//  main.m
//  DataObjectBuilder
//
//  Created by wpt2 on 11/13/14.
//  Copyright (c) 2014 happiness9721. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+ContentHelper.h"
#import <sqlite3.h>

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        NSLog(@"Please Input Database File Name:");
        char inputWord[40];
        int nChars = scanf("%39s", inputWord);
        if (nChars)
        {
            NSString *databaseName = [NSString stringWithUTF8String:inputWord];

            NSString *directory = [[[NSProcessInfo processInfo] environment] objectForKey:@"HOME"];
            directory = [directory stringByAppendingFormat:@"/Desktop/%@", databaseName];

            NSString *dbPath = [[[NSProcessInfo processInfo] environment] objectForKey:@"HOME"];
            dbPath = [dbPath stringByAppendingFormat:@"/Desktop/%@.sqlite", databaseName];
            sqlite3 *database;

            int result = sqlite3_open([dbPath UTF8String], &database);
            if (result == SQLITE_OK)
            {
                //Get All Table Name

                NSMutableArray *tableNameArray = [[NSMutableArray alloc] init];
                sqlite3_stmt *statement;
                NSString *sql = @"SELECT name FROM sqlite_master WHERE type='table' AND name!='sqlite_sequence'";
                sqlite3_prepare_v2(database, sql.UTF8String, -1, &statement, NULL);

                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    [tableNameArray addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                }
                sqlite3_finalize(statement);

                //Create database.h and database.m
                NSFileManager *fileManager= [NSFileManager defaultManager];
                NSError *error = nil;
                if(![fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error]) {
                    // An error has occurred, do something to handle it
                    NSLog(@"Failed to create directory \"%@\". Error: %@", directory, error);
                }

                NSString *fileName = [NSString stringWithFormat:@"%@.h", databaseName];
                NSString *filePath = [NSString stringWithFormat:@"%@/%@", directory, fileName];
                NSString *content = [[NSString stringWithFileName:fileName databaseName:databaseName] addDBFileHeader:databaseName];
                NSData *fileContents = [content dataUsingEncoding:NSUTF8StringEncoding];
                if(![fileManager createFileAtPath:filePath contents:fileContents attributes:nil]) {
                    // An error has occurred, do something to handle it
                    NSLog(@"Failed to create directory \"%@\". Error: %@", directory, error);
                }

                fileName = [NSString stringWithFormat:@"%@.m", databaseName];
                filePath = [NSString stringWithFormat:@"%@/%@", directory, fileName];
                content = [[NSString stringWithFileName:fileName databaseName:databaseName] addDBFileImplementation:databaseName];
                fileContents = [content dataUsingEncoding:NSUTF8StringEncoding];
                if(![fileManager createFileAtPath:filePath contents:fileContents attributes:nil]) {
                    // An error has occurred, do something to handle it
                    NSLog(@"Failed to create directory \"%@\". Error: %@", directory, error);
                }

                //Create table.h and table.m
                for (NSString *tableNamed in tableNameArray)
                {
                    NSString *sql = [NSString stringWithFormat:@"PRAGMA table_info(%@)", tableNamed];
                    sqlite3_prepare_v2(database, sql.UTF8String, -1, &statement, NULL);
                    NSMutableArray *nameArray = [[NSMutableArray alloc] init];
                    NSMutableArray *typeArray = [[NSMutableArray alloc] init];
                    while(sqlite3_step(statement) == SQLITE_ROW)
                    {
                        [nameArray addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]];
                        [typeArray addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]];
                    }
                    sqlite3_finalize(statement);

                    fileName = [NSString stringWithFormat:@"%@.h", tableNamed];
                    filePath = [NSString stringWithFormat:@"%@/%@", directory, fileName];
                    content = [[NSString stringWithFileName:fileName databaseName:databaseName] addTableFileHeaderWithDBName:databaseName tableName:tableNamed rowNames:nameArray rowTypes:typeArray];
                    fileContents = [content dataUsingEncoding:NSUTF8StringEncoding];
                    if(![fileManager createFileAtPath:filePath contents:fileContents attributes:nil]) {
                        // An error has occurred, do something to handle it
                        NSLog(@"Failed to create directory \"%@\". Error: %@", directory, error);
                    }

                    fileName = [NSString stringWithFormat:@"%@.m", tableNamed];
                    filePath = [NSString stringWithFormat:@"%@/%@", directory, fileName];
                    content = [[NSString stringWithFileName:fileName databaseName:databaseName] addTableFileImplementation:tableNamed];
                    fileContents = [content dataUsingEncoding:NSUTF8StringEncoding];
                    if(![fileManager createFileAtPath:filePath contents:fileContents attributes:nil]) {
                        // An error has occurred, do something to handle it
                        NSLog(@"Failed to create directory \"%@\". Error: %@", directory, error);
                    }
                }
                sqlite3_close(database);
            }
        }
        // insert code here...
        NSLog(@"Finish!");
    }
    return 0;
}
