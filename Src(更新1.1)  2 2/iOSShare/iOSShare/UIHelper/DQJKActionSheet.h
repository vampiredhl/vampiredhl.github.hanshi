//
//  DQJKActionSheet.h
//  Cloud
//
//  Created by wujin on 12-11-22.
//  Copyright (c) 2012年 wujin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionHandleBlock)(NSInteger btnIndex);

#define ActionSheet(title,cancelButton,destructiveBtn,otherButton,view) [[DQJKActionSheet actionSheetWithTitle:title cancelButtonTitle:cancelButton destructiveButtonTitle:destructiveBtn otherButtonTitles:otherButton HandleBlock:handle] showInView:view];

@interface DQJKActionSheet : UIActionSheet<UIActionSheetDelegate>

-(id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles HandleBlock:(ActionHandleBlock)handle;

+(id)actionSheetWithTitle:(NSString*)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles HandleBlock:(ActionHandleBlock)handle;

@property (nonatomic,copy) ActionHandleBlock handleBlock;

@end
