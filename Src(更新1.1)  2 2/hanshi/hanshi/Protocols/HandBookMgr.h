//
//  HandBookMgr.h
//  hanshi
//
//  Created by wujin on 14/12/27.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString * const kHandBookMgrDownloadProgressChangedNotification;
typedef enum : NSUInteger {
	HandBookMgrTypeNew,
	HandBookMgrTypeNeedNew,
	HandBookMgrTypeNone
} HandBookMgrType;
@interface HandBookMgr : NSOperationQueue
-(instancetype)initWithHandBook:(HanBook*)book;
@property (nonatomic,strong,readonly)HanBook *book;
/**
 当前手册的状态
*/
-(HandBookMgrType)state;
-(HanBookOneList*)list;
-(NSString*)imagePathForOne:(HanBookOne*)one;
/**
 下载或者更新手册
 */
-(void)downloadWithList:(HanBookOneList*)list;
@end
