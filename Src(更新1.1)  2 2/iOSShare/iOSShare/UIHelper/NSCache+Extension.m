//
//  NSCache+Extension.m
//  iOSShare
//
//  Created by wujin on 13-11-15.
//  Copyright (c) 2013年 wujin. All rights reserved.
//

#import "NSCache+Extension.h"

@implementation NSCache (Extension)

@end

int const NSCacheCenterDefaultMaxCacheCount=100;
NSString * const NSCacheCenterClearAllCacheNotification=@"NSCacheCenterClearAllCacheNotification";
@interface NSCacheCenter (){
	NSCache *cache;
	NSMutableSet *allCacheKeys;
	///用于给cache加锁，防止出现多线程访问
	NSRecursiveLock *lock;
}

@end

@implementation NSCacheCenter
- (id)init
{
    self = [super init];
    if (self) {
        cache=[[NSCache alloc] init];
		allCacheKeys = [[NSMutableSet alloc] init];
		lock=[[NSRecursiveLock alloc] init];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearAllCache:) name:NSCacheCenterClearAllCacheNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
	[lock release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [cache removeAllObjects];
	[cache release];
	[allCacheKeys release];
	[super dealloc];
}

-(void)didReceiveMemoryWarning
{
	[lock lock];
	for (NSString *key in allCacheKeys) {
		[[cache objectForKey:key] removeAllObjects];
	}
	[lock unlock];
}

+(NSCacheCenter*)defaultCacheCenter
{
	static NSCacheCenter *cacheCenter;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		cacheCenter=[[NSCacheCenter alloc] init];
	});
	return cacheCenter;
}

-(NSCache*)generateCache
{
	NSCache *c=[[[NSCache alloc] init] autorelease];
	c.countLimit=NSCacheCenterDefaultMaxCacheCount;
	return c;
}

-(NSCache*)cacheForKey:(id)key
{
	if (key==nil) {
		NSLog(@"can't get nil-key for cacheCenter");
		return nil;
	}
	[lock lock];
	NSCache *c=[cache objectForKey:key];
	
	if (c==Nil) {
		c=[self generateCache];
		[allCacheKeys addObject:key];
		[cache setObject:c forKey:key];
	}
	[lock unlock];
	return c;
}

-(void)setCache:(NSCache *)cacheObj forKey:(id)key
{
	[lock lock];
	[cache setObject:cacheObj forKey:key];
	[lock unlock];
}

-(void)clearAllCache:(NSNotification*)notify
{
	[lock lock];
	for (id key in allCacheKeys) {
		NSCache *c=[cache objectForKey:key];
		[c removeAllObjects];
	}
	[lock unlock];
}
@end