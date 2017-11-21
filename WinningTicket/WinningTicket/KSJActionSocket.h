//
//  Created by Kurt Jacobs
//  Copyright © 2016 RandomDudes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSWebSocket.h"

@class KSJActionSocket;

typedef NS_ENUM(NSUInteger, KSJActionSocketStatus)
{
    KSJActionSocketStatusConnecting,
    KSJActionSocketStatusConnected,
    KSJActionSocketStatusClosing,
    KSJActionSocketStatusClosed,
    KSJActionSocketStatusUnknown
};

typedef void(^KSJConnectedSocketBlock)(KSJActionSocket *socket);
typedef void(^KSJFailedConnectSocketBlock)(NSError *error);
typedef void(^KSJClosedSocketBlock)(NSInteger code, NSString *reason, BOOL wasClean);
typedef void(^KSJRecievedDataSocketBlock)(id data);

@protocol KSJActionSocketDelegate <NSObject>

@required
- (void)actionSocketOpened:(KSJActionSocket *)socket;
- (void)actionSocket:(KSJActionSocket *)socket recievedData:(NSData *)data;
- (void)actionSocket:(KSJActionSocket *)socket failedWithError:(NSError *)error;
- (void)actionSocket:(KSJActionSocket *)socket closedWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;

@end

@interface KSJActionSocket : NSObject <PSWebSocketDelegate>

+ (KSJActionSocket *)socketWithURL:(NSURL *)socketURL;

- (void)joinChannelWithName:(NSString *)channelName andPayload:(NSDictionary *)payload;
- (void)sendCommand:(NSString *)commandName toChannel:(NSString *)channelName withPayload:(NSDictionary *)payload;
- (void)open;
- (void)close;

@property (nonatomic, copy) KSJConnectedSocketBlock socketConnected;
@property (nonatomic, copy) KSJFailedConnectSocketBlock socketFailedToConnect;
@property (nonatomic, copy) KSJClosedSocketBlock socketClosed;
@property (nonatomic, copy) KSJRecievedDataSocketBlock socketRecievedData;

@property (nonatomic, readonly) PSWebSocket *socket;
@property (nonatomic, readonly) KSJActionSocketStatus currentSocketStatus;
@property (nonatomic, weak) id <KSJActionSocketDelegate> delegate;

@end
