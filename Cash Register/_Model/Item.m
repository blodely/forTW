//
//  Item.m
//  Cash Register
//
//  Created by Luo Yu on 3/16/16.
//  Copyright © 2016 Luo Yu. All rights reserved.
//

#import "Item.h"

@implementation Item

- (id)initWithCoder:(NSCoder *)coder {
	self = [super init];
	if (self) {
		self.name = [coder decodeObjectForKey:@"self.name"];
		self.ID = [coder decodeObjectForKey:@"self.ID"];
		self.category = [coder decodeObjectForKey:@"self.category"];
		self.unit = [coder decodeObjectForKey:@"self.unit"];
		self.price = [coder decodeFloatForKey:@"self.price"];
	}

	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:self.name forKey:@"self.name"];
	[coder encodeObject:self.ID forKey:@"self.ID"];
	[coder encodeObject:self.category forKey:@"self.category"];
	[coder encodeObject:self.unit forKey:@"self.unit"];
	[coder encodeFloat:self.price forKey:@"self.price"];
}

- (id)copyWithZone:(NSZone *)zone {
	Item *copy = [[[self class] allocWithZone:zone] init];

	if (copy != nil) {
		copy.name = [self.name copy];
		copy.ID = [self.ID copy];
		copy.category = [self.category copy];
		copy.unit = [self.unit copy];
		copy.price = self.price;
	}

	return copy;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"Item {\n\tID=%@\n\tname=%@\n\tcategory=%@\n\tunit=%@\n\tprice=%0.2f\n}", self.ID, self.name, self.category, self.unit, self.price];
}

@end
