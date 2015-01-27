//
//  Config.m
//  hanshi
//
//  Created by wujin on 14/12/20.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import "Config.h"

#define IMP_CONFIG_ITEM(name,type,default,beforeRet,beforeSet)\
static NSString * const kConfigKey_##name = @"kConfigKey_"#name;\
\
+(type)get##name\
{\
	return [Config getValue:kConfigKey_##name defaultValue:default beforeReturn:beforeRet];\
}\
\
+(void)set##name:(type)value\
{\
	[Config setValue:value forConfigKey:kConfigKey_##name beforeSetting:beforeSet];\
}

typedef id(^ConfigSettingBlock)(id value);
@implementation Config

+(id)getValue:(NSString*)key defaultValue:(id)defautValue beforeReturn:(ConfigSettingBlock)beforeRet
{
	id obj=[[NSUserDefaults standardUserDefaults] objectForKey:key];
	if (beforeRet) {
		obj = beforeRet(obj);
	}
	return obj!=nil?obj:defautValue;
}
+(void)setValue:(id)value forConfigKey:(NSString*)key beforeSetting:(ConfigSettingBlock)beforeSetting
{
	if (StringNotNullAndEmpty(key)&&value) {
		if (beforeSetting) {
			value=beforeSetting(value);
		}
		[[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
	}else{
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
	}
	[[NSUserDefaults standardUserDefaults] synchronize];
}


IMP_CONFIG_ITEM(Splash, NSArray*, @[@"df"],NULL,NULL)
IMP_CONFIG_ITEM(LoginUser, User*, nil,^(NSDictionary* v){return [[User alloc] initWithDictionary:v];}, ^(User* v){return v.dictionary;})
@end
