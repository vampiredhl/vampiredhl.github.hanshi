//
//  User.m
//  hanshi
//
//  Created by wujin on 14/12/20.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import "User.h"

@implementation User
- (void)dealloc
{
	self.returnvalue=nil;
	self.ntype=nil;
	self.xingming=nil;
	self.corpid=nil;
	self.corpname=nil;
	self.cpic=nil;
	self.upic=nil;
	self.mobile=nil;
	self.scorpname=nil;
	self.loginname=nil;
    self.email = nil;
}
@end
@implementation UserList

+(Class)elementClass
{
	return [User class];
}

@end
@implementation Corp

- (void)dealloc
{
	self.scorpname=nil;
	self.corpid=nil;
	self.corpname=nil;
	self.cpic=nil;
	self.introduction=nil;
}

@end
@implementation CorpList

+(Class)elementClass
{
	return [Corp class];
}

@end

@implementation Material

- (void)dealloc
{
	self.mtid=nil;
	self.mname=nil;
	self.mpic_small=nil;
	self.mpic=nil;
	self.mtname=nil;
	self.explain=nil;
}

@end

@implementation MaterialList

+(Class)elementClass
{
	return [Material class];
}

@end

@implementation HanBook

- (void)dealloc
{
	self.hbid=nil;
	self.hbname=nil;
	self.fbdate=nil;
	self.gxdate=nil;
	self.hbpic=nil;
}

@end
@implementation HanBookList

+(Class)elementClass
{
	return [HanBook class];
}
@end

@implementation HanBookOne

- (void)dealloc
{
	self.ctid=nil;
	self.cname=nil;
	self.cpic=nil;
}

@end

@implementation HanBookOneList

+(Class)elementClass
{
	return [HanBookOne class];
}

@end