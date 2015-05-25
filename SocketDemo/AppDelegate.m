//
//  AppDelegate.m
//  SocketDemo
//
//  Created by wayne on 15/1/9.
//  Copyright (c) 2015年 zh.wayne. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /* socket连接 */
    _udpSocket = [[TCUdpSocket alloc] init];
    [_udpSocket bindMulticastPort];
    [_udpSocket joinMulticastGroup];
    [_udpSocket receivingData:^(NSData *data, NSData *address, id filterContext) {
        NSMutableDictionary *info = [NSMutableDictionary new];
        [info setValue:data forKey:@"data"];
        [info setValue:address forKey:@"address"];
        [info setValue:filterContext forKey:@"filterContext"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TCUdpSocketReveivedData" object:nil userInfo:info];
    }];
    
    /* 发送一个广播消息 */
    char *msg = "online:?";
    [_udpSocket sendMulticastData:[NSData dataWithBytes:msg length:strlen(msg)]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    /* 进入后台后离开组播组 */
    [_udpSocket leaveMulticastGroup];
    [_udpSocket close];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [_udpSocket bindMulticastPort];
    [_udpSocket joinMulticastGroup];
    
    /* 发送一个广播消息 */
    char *msg = "online:?";
    [_udpSocket sendMulticastData:[NSData dataWithBytes:msg length:strlen(msg)]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
