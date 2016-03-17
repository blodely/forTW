//
//  NSFileManager+Reader.h
//  Cash Register
//
//  Created by Luo Yu on 3/16/16.
//  Copyright © 2016 Luo Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Reader)

+ (NSArray *)arrayFromFilePath:(NSString *)filePath;

+ (NSDictionary *)dictionaryFromFilePath:(NSString *)filePath;

@end
