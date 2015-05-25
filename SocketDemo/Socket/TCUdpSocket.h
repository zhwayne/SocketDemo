//
//  TCUdpSocket.h
//  SocketDemo
//
//  Created by wayne on 15/1/9.
//  Copyright (c) 2015年 zh.wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"


#define TCUdpSocketMulticastHost    @"224.0.0.2"
#define TCUdpSocketMulticastPort    30000


@interface TCUdpSocket : NSObject

/**
 *	@brief  通过地址信息获得主机IP，端口号
 *
 *	@param host    主机IP指针
 *	@param port    端口号指针
 *	@param address 地址信息
 */
+ (void)getHost:(NSString **)host port:(uint16_t *)port fromAddress:(NSData *)address;

#pragma mrak -
/**
 *	@brief  绑定组播端口
 *	@return 成功返回nil, 失败返回错误信息
 */
- (NSError *)bindMulticastPort;

/**
 *	@brief  加入组播组，准备接受监听到的数据。
 *
 *	@return 成功返回nil, 失败返回错误信息
 */
- (NSError *)joinMulticastGroup;
- (NSError *)leaveMulticastGroup;

/**
 *	@brief  关闭socket
 */
- (void)close;


#pragma mark - send

/**
 *	@brief  发送组播数据包
 *
 *	@param data        待发送的数据包
 */
- (void)sendMulticastData:(NSData *)data;

/**
 *	@brief  发送数据包
 *
 *	@param data         待发送的数据包
 *  @param serviveHost  要发送到的远程主机
 *  @param servicePort  远程主机端口
 */
- (void)sendData:(NSData *)data serviveHost:(NSString *)serviveHost servicePort:(uint16_t)servicePort;

#pragma mark - recv
/**
 *	@brief  接受监听到的数据
 *
 *	@param block 数据信息
 */
- (void)receivingData:(void (^)(NSData *data, NSData *address, id filterContext))block;

@end

