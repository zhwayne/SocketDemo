//
//  TCUdpSocket.m
//  SocketDemo
//
//  Created by wayne on 15/1/9.
//  Copyright (c) 2015年 zh.wayne. All rights reserved.
//

#import "TCUdpSocket.h"




@interface TCUdpSocket () <GCDAsyncUdpSocketDelegate>

/**
 *	@brief  套接字
 */
@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;

/**
 *	@brief  接受数据的回调
 */
@property (nonatomic, strong) void (^b)(NSData *data, NSData *address, id filterContext);



@end


@implementation TCUdpSocket


//////////////
#pragma mark -
- (id)init
{
    if(self = [super init]){
        _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

//////////////
#pragma mark -
- (NSError *)bindMulticastPort
{
    NSError *error = nil;
    
    [_udpSocket bindToPort:TCUdpSocketMulticastPort error:&error];
    
    return error;
}

- (NSError *)joinMulticastGroup
{
    NSError *error = nil;
    BOOL res = [_udpSocket joinMulticastGroup:TCUdpSocketMulticastHost error:&error];
    if(res == NO){
        return error;
    }
    
    res = [_udpSocket beginReceiving:&error];
    if(res == NO){
        return error;
    }
    
    return nil;
}

- (NSError *)leaveMulticastGroup
{
    
    NSError *error = nil;
    
    [_udpSocket leaveMulticastGroup:TCUdpSocketMulticastHost error:&error];
    
    return error;
}

- (void)close
{
    [_udpSocket close];
}

#pragma mark - send
- (void)sendHeartbeatPacket:(NSData *)heartbeatPacket
{
    [self sendMulticastData:heartbeatPacket];
}

- (void)sendMulticastData:(NSData *)data
{
    NSAssert(_udpSocket, @"scoket 必须存在");
    [_udpSocket sendData:data toHost:TCUdpSocketMulticastHost port:TCUdpSocketMulticastPort withTimeout:-1 tag:0];
}

- (void)sendData:(NSData *)data serviveHost:(NSString *)serviveHost servicePort:(uint16_t)servicePort;
{
    NSAssert(_udpSocket, @"scoket 必须存在");
    [_udpSocket sendData:data toHost:serviveHost port:servicePort withTimeout:-1 tag:0];
}


#pragma mark - receive

- (void)receivingData:(void (^)(NSData *data, NSData *address, id filterContext))block
{
    _b = block;
}

#pragma mrak - Delegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    _b(data, address, filterContext);
}


#pragma mark - delloc
- (void)dealloc
{
    if(_udpSocket){
        [_udpSocket close];
    }
}




+ (void)getHost:(NSString *__autoreleasing *)host port:(uint16_t *)port fromAddress:(NSData *)address
{
    [GCDAsyncUdpSocket getHost:host port:port fromAddress:address];
}

@end
