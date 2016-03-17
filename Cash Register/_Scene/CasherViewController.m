//
//  CasherViewController.m
//  Cash Register
//
//  Created by Luo Yu on 3/16/16.
//  Copyright © 2016 Luo Yu. All rights reserved.
//

#import "CasherViewController.h"
#import "ModelHeader.h"
#import "LibsHeader.h"

@interface CasherViewController () {
	
	NSDictionary *raw;
	NSDictionary *discount;
}

@end

@implementation CasherViewController

#pragma mark - ACTIONS

- (IBAction)buttonPressed:(id)sender {
	
	// BUTTON TAG
	
	[self printLog:(int)[sender tag]];
}


#pragma mark - INIT

#pragma mark | VIEW LIFE CYCLE

- (void)viewDidLoad {
    [super viewDidLoad];
    // DO ANY ADDITIONAL SETUP AFTER LOADING THE VIEW.
	
	raw = [NSFileManager dictionaryFromFilePath:[[NSBundle mainBundle] pathForResource:@"SampleCart" ofType:@"plist"]];
	discount = [NSFileManager dictionaryFromFilePath:[[NSBundle mainBundle] pathForResource:@"SampleDiscount" ofType:@"plist"]];
	
	
	if (!raw || !discount) {
		NSLog(@"READ FILE FAILED");
	}
}

#pragma mark | MEMORY MANAGEMENT

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // DISPOSE OF ANY RESOURCES THAT CAN BE RECREATED.
}

/*
#pragma mark - NAVIGATION

// IN A STORYBOARD-BASED APPLICATION, YOU WILL OFTEN WANT TO DO A LITTLE PREPARATION BEFORE NAVIGATION
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// PASS THE SELECTED OBJECT TO THE NEW VIEW CONTROLLER.
}
*/

#pragma mark - METHOD

#pragma mark | PRIVATE METHOD

- (void)printLog:(int)no {
	
	if (no > [raw count]) {
		_tvHint.text = _tvOutput.text = @"";
		return;
	}
	
	NSDictionary *currentRec = raw[[@"sample" stringByAppendingFormat:@"%d", no]];
	
	_tvHint.text = [currentRec[@"desc"] stringByAppendingFormat:@"\n\n输入数据: %@", currentRec[@"bin"]];
	
	// QUERY ITEMS
	NSArray *cart = [currentRec[@"bin"] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
		return [obj1 compare:obj2 options:NSCaseInsensitiveSearch|NSNumericSearch];
	}];
	
	// OUTPUT one[@"bin"]
	
	NSMutableArray *ret = [NSMutableArray arrayWithCapacity:1];
	
	for (__strong NSString *one in cart) {
		
		int preCount = 1;
		if ([[one componentsSeparatedByString:@"-"] count] > 1) {
			
			NSArray *coms = [one componentsSeparatedByString:@"-"];
			one = [NSString stringWithFormat:@"%@", coms[0]];
			preCount = MAX(1, [[coms lastObject] intValue]);
		}
		
		Item *item = [Operator getItemByID:one];
		if (item == nil) {
			break;
		}
		
		NSMutableDictionary *oneItem = [NSMutableDictionary dictionaryWithCapacity:1];
		
		if ([ret count] > 0) {
			
			BOOL has = NO;
			for (int i = 0; i < [ret count]; i++) {
				[oneItem addEntriesFromDictionary:ret[i]];
				if ([one isEqualToString:oneItem[@"ID"]]) {
					// SAME ITEM, ADD COUNT
					[oneItem setObject:[NSString stringWithFormat:@"%d", [oneItem[@"count"] intValue] + preCount] forKey:@"count"];
					[ret replaceObjectAtIndex:i withObject:oneItem];
					
					has = YES;
					break;
				}
			}
			
			if (has == NO) {
				[oneItem setObject:item forKey:@"item"];
				[oneItem setObject:one forKey:@"ID"];
				[oneItem setObject:[NSString stringWithFormat:@"%d", preCount] forKey:@"count"];
				[ret addObject:oneItem];
			}
			
		} else {
			[oneItem setObject:item forKey:@"item"];
			[oneItem setObject:one forKey:@"ID"];
			[oneItem setObject:[NSString stringWithFormat:@"%d", preCount] forKey:@"count"];
			[ret addObject:oneItem];
		}
		
	}
	
	_tvOutput.text = [ret description];
	
	NSMutableString *retStr = [[NSMutableString alloc] init];
	[retStr appendString:@"***<没钱赚商店>购物清单***\n"];
	
	float total = 0.0f;
	float totalSave = 0.0f;
	NSMutableArray *saved = [NSMutableArray arrayWithCapacity:1];
	
	for (NSDictionary *one in ret) {
		Item *item = (Item *)one[@"item"];
		[retStr appendFormat:@"名称: %@, ", item.name];
		[retStr appendFormat:@"数量: %@%@, ", one[@"count"], item.unit];
		[retStr appendFormat:@"单价: %0.2f(元), ", item.price];
		
		int freeCount = 0;
		float per = 1.0f;
		if ([Operator isItem:item.ID hasDiscountIn:discount[[@"sample" stringByAppendingFormat:@"%d", no]]]) {
			Discount *dc = [Operator getDiscountByID:item.ID inArray:discount[[@"sample" stringByAppendingFormat:@"%d", no]]];
			
			if (dc.buy > 0 && dc.free > 0) {
				// T1
				
				freeCount = [one[@"count"] intValue] / (dc.buy + dc.free);
				if (freeCount > 0) {
					// EXE T1
					// IGNORE T2/Nah
					
					totalSave = totalSave + (freeCount * item.price);
					per = 1;
					
					[saved addObject:@{@"ID":item.ID, @"item":item, @"count":@(freeCount),}];
					
				} else {
					if (dc.dc > 0 && dc.dc < 1) {
						// T2
						// EXE T2
						per = dc.dc;
						totalSave = totalSave + (item.price * [one[@"count"] intValue] * (1 - per));
					}
				}
			} else if (dc.dc > 0 && dc.dc < 1) {
				// T2
				// EXE T2
				per = dc.dc;
				totalSave = totalSave + (item.price * [one[@"count"] intValue] * (1 - per));
			}
		} else {
			// NO DISCOUNT
		}
		
		[retStr appendFormat:@"小计: %0.2f(元)", item.price * ([one[@"count"] intValue] - freeCount) * per];
		total = total + (item.price * ([one[@"count"] intValue] - freeCount) * per);
		if (per < 1 && per > 0) {
			[retStr appendFormat:@", 节省%0.2f(元)", (item.price * ([one[@"count"] intValue] - freeCount) * (1 - per))];
		}
		[retStr appendString:@"\n"];
	}
	
	if (totalSave > 0 && [saved count] > 0) {
		[retStr appendString:@"----------------------\n"];
		[retStr appendString:@"买二赠一的商品:\n"];
		for (NSDictionary *one in saved) {
			Item *oneItem = one[@"item"];
			[retStr appendFormat:@"名称: %@, ", oneItem.name];
			[retStr appendFormat:@"数量: %@%@\n", one[@"count"], oneItem.unit];
		}
	}
	
	
	[retStr appendString:@"----------------------\n"];
	[retStr appendFormat:@"总计: %0.2f(元)\n", total];
	
	if (totalSave > 0) {
		[retStr appendFormat:@"节省: %0.2f(元)\n", totalSave];
	}
	
	[retStr appendString:@"**********************"];
	
	_tvOutput.text = retStr;
	
	// PRINT
	NSLog(@"\n\n%@\n\n", retStr);
}


@end
