//
//  NSString+ContentHelper.m
//  DataObjectBuilder
//
//  Created by wpt2 on 11/13/14.
//  Copyright (c) 2014 happiness9721. All rights reserved.
//

#import "NSString+ContentHelper.h"

@implementation NSString (ContentHelper)

+ (instancetype)stringWithFileName:(NSString *)fileName databaseName:(NSString *)databaseName
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yy"];

    NSString *header = @"//\n//  ";
    header = [header stringByAppendingFormat:@"%@\n//  %@\n//\n", fileName, databaseName];
    header = [header stringByAppendingFormat:@"//  Created by %@ on %@.\n", NSUserName(), [dateFormatter stringFromDate:[NSDate date]]];
    header = [header stringByAppendingString:
              @"//  Copyright (c) 2014 happiness9721. All rights reserved.\n"
              @"//\n\n"];
    return header;
}

- (NSString *)addDBFileHeader:(NSString *)fileName
{
    NSString *content = @"#import \"DBObject.h\"\n\n";
    content = [content stringByAppendingFormat:@"@interface %@ : DBObject\n\n@end", fileName];
    return [self stringByAppendingString:content];
}

- (NSString *)addDBFileImplementation:(NSString *)fileName
{
    NSString *content = [NSString stringWithFormat:@"#import \"%@.h\"\n\n", fileName];
    content = [content stringByAppendingFormat:@"@implementation %@\n\n", fileName];
    content = [content stringByAppendingFormat:@"+ (NSString *)getDatabaseNamed\n{\n\treturn @\"%@\";\n}\n\n@end", fileName];
    return [self stringByAppendingString:content];
}

- (NSString *)addTableFileHeaderWithDBName:(NSString *)dbName tableName:(NSString *)tableName rowNames:(NSArray *)rowNames rowTypes:(NSArray *)rowTypes
{
    NSArray *numberTypes = [NSArray arrayWithObjects:@"int", @"integer", @"tinyint", @"smallint", @"mediumint", @"bigint", @"unsigned big int", @"int2", @"int8", @"real", @"double", @"double precision", @"float", @"boolean", nil];
//    NSArray *stringTypes = [NSArray arrayWithObjects:@"character", @"varchar", @"varying character", @"nachar", @"native character", @"nvarchar", @"text", @"blob", nil];
//    NSArray *dateTypes = [NSArray arrayWithObjects:@"date", @"datetime", nil];

    NSString *content = [NSString stringWithFormat:@"#import \"%@.h\"\n\n", dbName];
    content = [content stringByAppendingFormat:@"@interface %@ : %@\n\n", tableName, dbName];
    for (NSUInteger index = 0; index < rowNames.count; index++)
    {
        NSString *rowType = [rowTypes objectAtIndex:index];
        rowType = [[[rowType componentsSeparatedByString:@"("] firstObject] lowercaseString];
        if ([numberTypes indexOfObject:rowType] != NSNotFound)
        {
            content = [content stringByAppendingFormat:@"@property NSNumber *%@;\n", [rowNames objectAtIndex:index]];
        }
//        else if ([dateTypes indexOfObject:rowType] != NSNotFound)
//        {
//            content = [content stringByAppendingFormat:@"@property NSDate *%@;\n", [rowNames objectAtIndex:index]];
//        }
        else
        {
            content = [content stringByAppendingFormat:@"@property NSString *%@;\n", [rowNames objectAtIndex:index]];
        }
    }
    content = [content stringByAppendingString:@"\n@end"];
    return [self stringByAppendingString:content];
}

- (NSString *)addTableFileImplementation:(NSString *)fileName
{
    NSString *content = [NSString stringWithFormat:@"#import \"%@.h\"\n\n", fileName];
    content = [content stringByAppendingFormat:@"@implementation %@\n\n@end", fileName];
    return [self stringByAppendingString:content];
}

@end
