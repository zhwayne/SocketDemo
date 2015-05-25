//
//  AppDelegate.h
//  SocketDemo
//
//  Created by wayne on 15/1/9.
//  Copyright (c) 2015年 zh.wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCUdpSocket.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) TCUdpSocket *udpSocket;

@end

