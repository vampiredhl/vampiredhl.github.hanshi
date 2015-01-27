//
//  DQJKActionSheet.m
//  Cloud
//
//  Created by wujin on 12-11-22.
//  Copyright (c) 2012年 wujin. All rights reserved.
//

#import "DQJKActionSheet.h"

@implementation DQJKActionSheet

-(id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles HandleBlock:(ActionHandleBlock)handle
{
    if (otherButtonTitles!=nil) {
        self=[super initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles, nil];
    }else{
        self=[super initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil];
    }
    if (self) {
        self.handleBlock=handle;
    }
    return self;
}

+(id)actionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles HandleBlock:(ActionHandleBlock)handle
{
    return [[[DQJKActionSheet alloc] initWithTitle:title cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles HandleBlock:handle] autorelease];
}

-(void)dealloc
{
    self.handleBlock=nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark actionSheet delegate
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.handleBlock!=nil) {
        self.handleBlock(buttonIndex);
        self.handleBlock=nil;
    }
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet  // before animation and showing view
{
    
}

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet  // after animation
{
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex // before animation and hiding view
{
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex  // after animation
{
    
}

@end
