//
//  RequestHandle.m
//  RequestHandle
//
//  Created by XXT on 15/9/7.
//  Copyright (c) 2015年 XXT. All rights reserved.
//

#import "RequestHandle.h"
@interface RequestHandle() <NSURLConnectionDataDelegate>
@property (nonatomic,retain)NSMutableData *data;
@property (nonatomic,retain)NSURLConnection *connection;//记录请求对象
@end
@implementation RequestHandle
-(id)initWithURLString:(NSString *)urlString parameter:(NSString *)parameter requestMethod:(NSString *)method delegate:(id<RequestHandleDelegate>)delegate{
    self =[super init];
    if (self) {
        self.delegate =delegate;
        if ([method isEqualToString:@"GET"]) {
            //进行GET请求
            [self requestNetworkWithGET:urlString];
        }else if ([method isEqualToString:@"POST"]){
            //进行POST请求
            [self requestNetworkWithPOST:urlString parameter:parameter requestMethod:method];
        }
    }
    return self;
}
-(void)requestNetworkWithGET:(NSString *)urlString{
    NSString *urlStr =[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.connection= [NSURLConnection connectionWithRequest:request delegate:self];
}
//取消请求方法
-(void)cancelRequest{
    [_connection cancel];
}

-(void)requestNetworkWithPOST:(NSString *)urlString parameter:(NSString *)parameter requestMethod:(NSString *)method{
    NSURL *url = [NSURL URLWithString:urlString];
    //2.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //3.设置请求体

    NSData *bodyData = [parameter dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:bodyData];
    //设置请求方式
    [request setHTTPMethod:@"POST"];
    //4.请求 并设置代理
    [NSURLConnection connectionWithRequest:request delegate:self];
}
//连接服务器
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    if (_data == nil) {
        self.data =[NSMutableData data];
    }
}
//获取数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_data appendData:data];
    
}
//完成加载
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    //通知代理 将请求成功的信息拿走
    [_delegate requestHandle:self didSucceedWithData:_data];
}
//请求失败
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
//通知代理 将请求失败的信息拿走
    [_delegate requestHandle:self didFailWithError:error];
}

#pragma mark -

@end
