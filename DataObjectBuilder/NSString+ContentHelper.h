//
//  NSString+ContentHelper.h
//  DataObjectBuilder
//
//  Created by wpt2 on 11/13/14.
//  Copyright (c) 2014 happiness9721. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ContentHelper)

+ (instancetype)stringWithFileName:(NSString *)fileName databaseName:(NSString *)databaseName;
- (NSString *)addDBFileHeader:(NSString *)fileName;
- (NSString *)addDBFileImplementation:(NSString *)fileName;
- (NSString *)addTableFileHeaderWithDBName:(NSString *)dbName tableName:(NSString *)tableName rowNames:(NSArray *)rowNames rowTypes:(NSArray *)rowTypes;
- (NSString *)addTableFileImplementation:(NSString *)fileName;

@end
