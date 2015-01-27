//
//  ProtocolManager.m
//  hanshi
//
//  Created by wujin on 14/12/20.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import "ProtocolManager.h"
#import <UIKit/UIKit.h>

@implementation ProtocolManager
- (instancetype)init
{
	self = [super init];
	if (self) {
		[self applicationStart:nil];
		[self applicationResign:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationStart:) name:UIApplicationDidFinishLaunchingNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationResign:) name:UIApplicationDidBecomeActiveNotification object:nil];
	}
	return self;
}
- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 更新启动画面
 */
-(void)updateLeadList
{
	SysLead *l=[SysLead protocolAutoRelease];
	[l requestWithSusessBlock:NULL FailBlock:NULL];
}

-(void)applicationStart:(NSNotification*)note
{

}

-(void)applicationResign:(NSNotification*)note
{
	[self updateLeadList];
}

+(ProtocolManager*)shareManager
{
	static ProtocolManager *_instance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_instance=[[ProtocolManager alloc] init];
	});
	return _instance;
}
@end
