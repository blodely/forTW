//
//  Operator.m
//  Cash Register
//
//  Created by Luo Yu on 3/16/16.
//  Copyright © 2016 Luo Yu. All rights reserved.
//

#import "Operator.h"
#import "Item.h"
#import "Discount.h"
#import "LibsHeader.h"

@implementation Operator

+ (Item *)getItemByID:(NSString *)itemID {
	
	if (!itemID || [itemID isKindOfClass:[NSString class]] == NO || [itemID isEqualToString:@""]) {
		return nil;
	}
	
	NSDictionary *items = [NSFileManager dictionaryFromFilePath:[[NSBundle mainBundle] pathForResource:@"SampleItem" ofType:@"plist"]];
	
	if (!items) {
		return nil;
	}
	
	Item *item = [[Item alloc] init];
	
	for (NSString *one in [items allKeys]) {
		if ([one isEqualToString:itemID]) {
			NSDictionary *rawItem = items[one];
			item.ID = one;
			item.name = rawItem[@"name"];
			item.category = rawItem[@"category"];
			item.unit = rawItem[@"unit"];
			item.price = [rawItem[@"price"] floatValue];
			break;
		}
	}
	
	if (item.ID == nil) {
		return nil;
	}
	
	return item;
}

+ (Discount *)getDiscountByID:(NSString *)itemID inArray:(NSArray *)array {
	
	if (!itemID || [itemID isKindOfClass:[NSString class]] == NO || [itemID isEqualToString:@""]) {
		return nil;
	}
	
	Discount *discount = [[Discount alloc] init];
	
	for (NSDictionary *one in array) {
		if ([one[@"ID"] isEqualToString:itemID]) {
			discount.ID = itemID;
			discount.buy = [one[@"buy"] integerValue];
			discount.free = [one[@"free"] integerValue];
			discount.dc = [one[@"dc"] floatValue];
			break;
		}
	}
	
	if (discount.ID == nil) {
		return nil;
	}
	
	return discount;
}

+ (BOOL)isItem:(NSString *)itemID hasDiscountIn:(NSArray *)sets {

	if (sets == nil || [sets count] == 0) {
		return NO;
	}
	
	for (NSDictionary *one in sets) {
		if ([one[@"ID"] isEqualToString:itemID]) {
			return YES;
		}
	}
	
	return NO;
}

@end
