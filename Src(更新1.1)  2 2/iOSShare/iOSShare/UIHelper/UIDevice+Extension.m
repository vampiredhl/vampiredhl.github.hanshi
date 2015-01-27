//
//  UIDevice+Extension.m
//  iOSShare
//
//  Created by wujin on 13-5-7.
//  Copyright (c) 2013年 wujin. All rights reserved.
//

#import "UIDevice+Extension.h"
#include <sys/sysctl.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>

BOOL DeviceSystemSmallerThan(float version)
{
	static float flag=-1;
	if (flag==-1) {
		flag=[[[UIDevice currentDevice] systemVersion] floatValue];
	}
	return flag<version;
}
BOOL DeviceIsiPhone5OrLater()
{
	static int flag=-1;
	if (flag==-1) {
		flag=[UIScreen mainScreen].bounds.size.height>480;
	}
	return flag;
}
BOOL DeviceIsiPad()
{
	static BOOL isipad=NO;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		isipad=[UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad;
	});
	return isipad;
}

BOOL DeviceIsiPhone()
{
	static BOOL isiphone=NO;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		isiphone=[UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone;
	});
	return isiphone;
}
@implementation UIDevice (Extension)
+ (NSString *)macAddress
{
	if (DeviceSystemSmallerThan(7.0)==NO) {
		NSLog(@"iOS7.0 or Later can't get the mac adress");
	}
	
    int                     mib[6];
    size_t                  len;
    char                    *buf;
    unsigned char           *ptr;
    struct if_msghdr        *ifm;
    struct sockaddr_dl      *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0)
    {
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0)
    {
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL)
    {
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0)
    {
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return outstring;
}

+ (NSString *) platformString
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5S (GSM)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 plus";
    
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch (1 Gen)";
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch (2 Gen)";
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch (3 Gen)";
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch (4 Gen)";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch (5 Gen)";
    
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([platform isEqualToString:@"iPad1,2"]) return @"iPad 3G";
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"i386"])    return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])  return @"Simulator";
    return platform;
}

+(CGFloat)DeviceSystem
{
    __block CGFloat s = 0.f;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s = [[[UIDevice currentDevice] systemVersion] floatValue];
    });
    return s;
}

/**
 屏幕宽度
 */
+ (CGFloat)screenWidth
{
    return CGRectGetWidth([UIScreen mainScreen].bounds);
}

/**
 屏幕宽度
 */
+ (CGFloat)screenHeight
{
    return CGRectGetHeight([UIScreen mainScreen].bounds);
}

+ (NSString *)channelStirng
{
    return  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Channel"];
}

@end
