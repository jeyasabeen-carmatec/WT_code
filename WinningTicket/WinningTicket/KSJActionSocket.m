//
//  Created by Kurt Jacobs
//  Copyright © 2016 RandomDudes. All rights reserved.
//

#import "KSJActionSocket.h"

@interface KSJActionSocket ()

@property (nonatomic, readwrite) PSWebSocket *socket;
@property (nonatomic, readwrite) KSJActionSocketStatus currentSocketStatus;
@property (nonatomic, strong) dispatch_queue_t delegateQueue;

@end

@implementation KSJActionSocket

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.socket = nil;
        self.currentSocketStatus = KSJActionSocketStatusUnknown;
        self.delegateQueue = dispatch_queue_create("ksjactionsocket_queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

+ (KSJActionSocket *)socketWithURL:(NSURL *)socketURL
{
    NSString *auth_tok = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    
    KSJActionSocket *actionSocket = [[KSJActionSocket alloc] init];
    NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc] init];
    
//    [NSMutableURLRequest
//     requestWithURL:socketURL
//     cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    
    [request1 setURL:socketURL];
 
    [request1 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request1 setValue:auth_tok forHTTPHeaderField:@"auth_token"];
    [request1 setHTTPShouldHandleCookies:YES];
    
    PSWebSocket *ws = [PSWebSocket clientSocketWithRequest:request1];
    ws.delegate = actionSocket;
    actionSocket.socket = ws;
    return actionSocket;
}

+ (NSString *)stringifyDictionary:(NSDictionary *)dict
{
    __block NSMutableString *str = [NSMutableString stringWithFormat:@"\"data\":{"];
    __block NSUInteger count = 0;
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        count ++;
        if (count == dict.count)
        {
            [str appendFormat:@"\"%@\":\"%@\"",key,obj];
        }
        else
        {
            [str appendFormat:@"\"%@\":\"%@\",",key,obj];
        }
    }];
    [str appendFormat:@"}"];
    return str;
}

- (void)setSocketURL:(NSURL *)socketURL
{
    NSURLRequest *req = [NSURLRequest requestWithURL:socketURL];
    PSWebSocket *ws = [PSWebSocket clientSocketWithRequest:req];
    self.socket = ws;
    self.socket.delegate = self;
}

- (void)joinChannelWithName:(NSString *)channelName andPayload:(NSDictionary *)payload
{
    NSString *channel = [NSString stringWithFormat:@"{ \"channel\": \"%@\", %@}",channelName,[KSJActionSocket stringifyDictionary:payload]];
    NSDictionary *payload_dict = @{@"command": @"subscribe",@"identifier":channel};
    NSData *json_data = [NSJSONSerialization  dataWithJSONObject:payload_dict options:0 error:nil];
    NSString *payload_str = [[NSString alloc] initWithData:json_data encoding:NSUTF8StringEncoding];
    [self.socket send:payload_str];
}

- (void)sendCommand:(NSString *)commandName toChannel:(NSString *)channelName withPayload:(NSDictionary *)payload
{
  NSString *action = [[NSString alloc] initWithFormat:@"{\"action\":\"%@\",\"payload\":\"%@\"}",commandName,payload];
  NSString *channel =[NSString stringWithFormat:@"{\"channel\":\"%@\"}",channelName];
  NSDictionary *payload_dict = @{@"command":@"message",@"identifier":channel,@"data":action};
  NSData *json_data = [NSJSONSerialization  dataWithJSONObject:payload_dict options:0 error:nil];
  NSString *payload_str = [[NSString alloc] initWithData:json_data encoding:NSUTF8StringEncoding];
  [self.socket send:payload_str];
}

- (void)open
{
    if (!self.socket){return;}
    [self.socket open];
    self.currentSocketStatus = KSJActionSocketStatusConnecting;
}

- (void)close
{
    if (!self.socket){return;}
    [self.socket close];
    self.currentSocketStatus = KSJActionSocketStatusClosing;
}

#pragma mark - PSWebSocketDelegate Methods

- (void)webSocketDidOpen:(PSWebSocket *)webSocket
{
    __weak typeof (self) ws = self;
    dispatch_async(self.delegateQueue, ^{
        ws.currentSocketStatus = KSJActionSocketStatusConnected;
        if (ws.delegate)
        {
            [ws.delegate actionSocketOpened:ws];
        }
        if (ws.socketConnected)
        {
            ws.socketConnected(self);
        }
    });
}

-(void)webSocket:(PSWebSocket *)webSocket didReceiveMessage:(NSData *)message
{
    __weak typeof (self) ws = self;
    dispatch_async(self.delegateQueue, ^{
        if (ws.delegate)
        {
            [ws.delegate actionSocket:ws recievedData:message];
        }
        if (ws.socketRecievedData)
        {
            ws.socketRecievedData(message);
        }
    });
}

-(void)webSocket:(PSWebSocket *)webSocket didFailWithError:(NSError *)error
{
    __weak typeof (self) ws = self;
    dispatch_async(self.delegateQueue, ^{
        if (ws.delegate)
        {
            [ws.delegate actionSocket:ws failedWithError:error];
        }
        ws.currentSocketStatus = KSJActionSocketStatusClosed;
        if (ws.socketFailedToConnect)
        {
            ws.socketFailedToConnect(error);
        }
    });
}

-(void)webSocket:(PSWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    __weak typeof (self) ws = self;
    dispatch_async(self.delegateQueue, ^{
        ws.currentSocketStatus = KSJActionSocketStatusClosed;
        if (ws.delegate)
        {
            [ws.delegate actionSocket:ws closedWithCode:code reason:reason wasClean:wasClean];
        }
        if (ws.socketClosed)
        {
            ws.socketClosed(code,reason,wasClean);
        }
    });
}

@end
