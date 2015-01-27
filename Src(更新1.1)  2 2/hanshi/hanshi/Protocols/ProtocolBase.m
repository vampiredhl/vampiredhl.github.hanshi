//
//  ProtocolBase.m
//  hanshi
//
//  Created by wujin on 14/12/20.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import "ProtocolBase.h"

@implementation ProtocolBase
- (instancetype)init
{
	self = [super init];
	if (self) {
//		[queryDictionary setObject:@"json" forKey:@"resulttype"];
		self.requestMethod=@"GET";
		[queryDictionary setObject:@"utf-8" forKey:@"encoding"];
		[queryDictionary setObject:@"1000" forKey:@"pagesize"];
	}
	return self;
}
-(id)handleSusessParam:(NSString *)str Susess:(BOOL *)result
{
	*result=YES;
	return [str objectFromJSONString];
}
@end
