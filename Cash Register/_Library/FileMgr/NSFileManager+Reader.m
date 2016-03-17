//
//  NSFileManager+Reader.m
//  Cash Register
//
//  Created by Luo Yu on 3/16/16.
//  Copyright © 2016 Luo Yu. All rights reserved.
//

#import "NSFileManager+Reader.h"

@implementation NSFileManager (Reader)

+ (NSArray *)arrayFromFilePath:(NSString *)filePath {
	
	// CHECK FILE PATH STRING
	if (!filePath || [filePath isKindOfClass:[NSString class]] == NO || [filePath isEqualToString:@""]) {
		return nil;
	}
	
	// CHECK FILE EXISTENCE
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO) {
		return nil;
	}
	
	return [NSArray arrayWithContentsOfFile:filePath];
}

+ (NSDictionary *)dictionaryFromFilePath:(NSString *)filePath {
	// CHECK FILE PATH STRING
	if (!filePath || [filePath isKindOfClass:[NSString class]] == NO || [filePath isEqualToString:@""]) {
		return nil;
	}
	
	// CHECK FILE EXISTENCE
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO) {
		return nil;
	}
	
	return [NSDictionary dictionaryWithContentsOfFile:filePath];
}

@end
