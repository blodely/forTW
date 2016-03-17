//
//  Discount.h
//  Cash Register
//
//  CREATED BY LUO YU ON 3/16/16.
//  COPYRIGHT © 2016 LUO YU. ALL RIGHTS RESERVED.
//

#import <Foundation/Foundation.h>

@interface Discount : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, assign) NSUInteger buy;
@property (nonatomic, assign) NSUInteger free;
@property (nonatomic, assign) float dc;

@end
