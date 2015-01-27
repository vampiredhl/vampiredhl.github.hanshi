//
//  CopSearch.m
//  hanshi
//
//  Created by wujin on 14/12/21.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import "CorpSearch.h"

@implementation CorpSearch
-(void)requestWithSusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock
{
	AppendUrl(@"corp/corpsearch/");
	[super requestWithSusessBlock:susessBlock FailBlock:failBlock];
}
-(id)handleSusessParam:(NSString *)str Susess:(BOOL *)result
{
	NSDictionary *dic=[super handleSusessParam:str Susess:result];
	CorpList *c=[[CorpList alloc] initWithArray:dic[@"list"]];
	return c;
}
@end
@implementation CorpInfo

-(void)requestWithId:(NSString *)corpId SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock
{
	AppendUrl(@"corp/corpinfo/");
	[queryDictionary setObject:corpId forKey:@"corpid"];
	[super requestWithSusessBlock:susessBlock FailBlock:failBlock];
}
-(id)handleSusessParam:(NSString *)str Susess:(BOOL *)result{
	NSDictionary * dic=[super handleSusessParam:str Susess:result];
	Corp *c=[[Corp alloc] initWithDictionary:dic];
	return c;
}

@end

@implementation CorpMaterial

-(void)requestWithId:(NSString *)corpId SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock
{
	AppendUrl(@"corp/corpmaterial/");
	[queryDictionary setObject:corpId forKey:@"corpid"];
	[super requestWithSusessBlock:susessBlock FailBlock:failBlock];
}
-(id)handleSusessParam:(NSString *)str Susess:(BOOL *)result{
	NSDictionary * dic=[super handleSusessParam:str Susess:result];
	MaterialList *c=[[MaterialList alloc] initWithArray:dic[@"list"]];
	return c;
}

@end

@implementation MaterialPic
-(void)requestWithId:(NSString *)mtId SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock
{
	AppendUrl(@"material/materialpic/");
	[queryDictionary setObject:mtId forKey:@"mtid"];
	[super requestWithSusessBlock:susessBlock FailBlock:failBlock];
}
-(id)handleSusessParam:(NSString *)str Susess:(BOOL *)result{
	NSDictionary * dic=[super handleSusessParam:str Susess:result];
	MaterialList *c=[[MaterialList alloc] initWithArray:dic[@"list"]];
	return c;
}

@end

@implementation MaterialSearch

-(void)requestWithCorpId:(NSArray *)corpid Scope:(NSArray *)scrop Mater:(NSArray *)mater SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock
{
	///http://localhost:1002/api/material/materialsearch/?corpid=1,2,3&scope=天花,墙面&mater=天花,墙面&pagesize=10&pageno=1
	AppendUrl(@"material/materialsearch/");
	[queryDictionary setObject:@"10000" forKey:@"pagesize"];
	if (corpid.count>0) {
		[queryDictionary setObject:[corpid componentsJoinedByString:@","] forKey:@"corpid"];
	}
	if (mater.count>0) {
		[queryDictionary setObject:[mater componentsJoinedByString:@","] forKey:@"mater"];
	}
	if (scrop.count>0) {
		[queryDictionary setObject:[scrop componentsJoinedByString:@","] forKey:@"scopte"];
	}
	[super requestWithSusessBlock:susessBlock FailBlock:failBlock];
}
-(id)handleSusessParam:(NSString *)str Susess:(BOOL *)result{
	NSDictionary * dic=[super handleSusessParam:str Susess:result];
	MaterialList *c=[[MaterialList alloc] initWithArray:dic[@"list"]];
	return c;
}

@end

@implementation MaterialNature

-(void)requestWithSusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock
{
	AppendUrl(@"material/nature/");
	[super requestWithSusessBlock:susessBlock FailBlock:failBlock];
}

-(id)handleSusessParam:(NSString *)str Susess:(BOOL *)result
{
	NSDictionary *dic=[super handleSusessParam:str Susess:result];
	MaterialList *m=[[MaterialList alloc] initWithArray:dic[@"list"]];
	return m;
}
@end

@implementation MaterialType

-(void)requestWithSusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock
{
	//http://115.47.49.111:1002/api2/material/materialtype/
	AppendUrl(@"material/materialtype/");
	[super requestWithSusessBlock:susessBlock FailBlock:failBlock];
}

-(void)requestWithFlag:(NSString *)flag SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock
{
	[queryDictionary setObject:flag forKey:@"flag"];
	[self requestWithSusessBlock:susessBlock FailBlock:failBlock];
}

-(id)handleSusessParam:(NSString *)str Susess:(BOOL *)result
{
	NSDictionary *dic=[super handleSusessParam:str Susess:result];
	MaterialList *m=[[MaterialList alloc] initWithArray:dic[@"list"]];
	return m;
}
@end

@implementation CorpCorpbyType

-(void)requestWithType:(NSString *)ntype SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock
{
	AppendUrl(@"corp/corpbytype/");
	[queryDictionary setObject:ntype forKey:@"ntype"];
	[super requestWithSusessBlock:susessBlock FailBlock:failBlock];
}

-(id)handleSusessParam:(NSString *)str Susess:(BOOL *)result{
	NSDictionary * dic=[super handleSusessParam:str Susess:result];
	CorpList *c=[[CorpList alloc] initWithArray:dic[@"list"]];
	return c;
}
@end

@implementation HanbookHbList

-(void)requestWithCorpId:(NSString *)coprid userName:(NSString *)userName SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock
{
	AppendUrl(@"handbook/hblist/");
	if (StringNotNullAndEmpty(coprid)) {
		[queryDictionary setObject:coprid forKey:@"corpid"];
	}
	if (StringNotNullAndEmpty(userName)) {
		[queryDictionary setObject:userName forKey:@"username"];
	}
	[super requestWithSusessBlock:susessBlock FailBlock:failBlock];
}

-(id)handleSusessParam:(NSString *)str Susess:(BOOL *)result
{
	NSString * dic=[super handleSusessParam:str Susess:result];
	return [[HanBookList alloc] initWithArray:[dic valueForKey:@"list"]];
}

@end
@implementation MaterialByType

-(void)requestWithMtid:(NSString *)mtid Hbid:(NSString *)hbid SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock
{
	AppendUrl(@"material/materialbytype/");
	[queryDictionary setObject:mtid forKey:@"mtid"];
	[queryDictionary setObject:hbid forKey:@"hbid"];
	[super requestWithSusessBlock:susessBlock FailBlock:failBlock];
}

-(id)handleSusessParam:(NSString *)str Susess:(BOOL *)result
{
	NSDictionary *dic=[super handleSusessParam:str Susess:result];
	MaterialList *m=[[MaterialList alloc] initWithArray:dic[@"list"]];
	return m;
}
@end

@implementation HanBookAll

-(void)requestWithId:(NSString *)hbid SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock
{
	AppendUrl(@"handbook/hbcatalog/");
	[queryDictionary setObject:hbid forKey:@"hbid"];
	[super requestWithSusessBlock:susessBlock FailBlock:failBlock];
}
-(id)handleSusessParam:(NSString *)str Susess:(BOOL *)result
{
	NSString * dic=[super handleSusessParam:str Susess:result];
	return [[HanBookOneList alloc] initWithArray:[dic valueForKey:@"list"]];
}
@end

@implementation HandBookMaterial

-(void)requestWithCtid:(NSString *)ctid SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock
{
	AppendUrl(@"handbook/ctmaterial/");
	[queryDictionary setObject:ctid forKey:@"ctid"];
	[super requestWithSusessBlock:susessBlock FailBlock:failBlock];
}
-(id)handleSusessParam:(NSString *)str Susess:(BOOL *)result
{
	NSDictionary *dic=[super handleSusessParam:str Susess:result];
	MaterialList *m=[[MaterialList alloc] initWithArray:dic[@"list"]];
	return m;
}

@end

@implementation Loglist

-(void)requestWithUserName:(NSString *)username SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock
{
	AppendUrl(@"handbook/logolist/");
	[queryDictionary setObject:username forKey:@"username"];
	[super requestWithSusessBlock:susessBlock FailBlock:failBlock];
}
-(id)handleSusessParam:(NSString *)str Susess:(BOOL *)result
{
	NSDictionary *dic=[super handleSusessParam:str Susess:result];
	CorpList *m=[[CorpList alloc] initWithArray:dic[@"list"]];
	return m;
}
@end