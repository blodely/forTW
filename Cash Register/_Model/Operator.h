//
//  Operator.h
//  Cash Register
//
//  Created by Luo Yu on 3/16/16.
//  Copyright © 2016 Luo Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Item;
@class Discount;

@interface Operator : NSObject

+ (Item *)getItemByID:(NSString *)itemID;

+ (Discount *)getDiscountByID:(NSString *)itemID inArray:(NSArray *)array;

+ (BOOL)isItem:(NSString *)itemID hasDiscountIn:(NSArray *)sets;

@end
