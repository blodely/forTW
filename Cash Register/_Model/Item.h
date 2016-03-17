//
//  Item.h
//  Cash Register
//
//  Created by Luo Yu on 3/16/16.
//  Copyright © 2016 Luo Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, assign) float price;

- (id)copyWithZone:(NSZone *)zone;

- (id)initWithCoder:(NSCoder *)coder;

- (void)encodeWithCoder:(NSCoder *)coder;

@end
