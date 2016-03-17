//
//  Discount.m
//  Cash Register
//
//  CREATED BY LUO YU ON 3/16/16.
//  COPYRIGHT © 2016 LUO YU. ALL RIGHTS RESERVED.
//

#import "Discount.h"

@implementation Discount

- (NSString *)description {
	return [NSString stringWithFormat:@"Discount ID=%@ buy=%@ free=%@ dc=%@", self.ID, @(self.buy), @(self.free), @(self.dc)];
}

@end
