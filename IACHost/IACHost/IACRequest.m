//
//  IACRequest.m
//  IACHost
//
//  Created by 柳尧 on 2019/6/27.
//  Copyright © 2019 Diver. All rights reserved.
//

#import "IACRequest.h"

@implementation IACRequest

-(id)init
{
    if(self=[super init])
    {
        self.parameterDict = [[NSMutableDictionary alloc] init];
        self.responseString = [[NSString alloc] init];
    }
    return self;
}

-(void)requestWithURL:(NSURL*)url
{
    self.request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    NSDictionary *headers = [self.request allHTTPHeaderFields];
    [headers setValue:@"macOS-Client-IAC" forKey:@"User-Agent"];
    [self.parameterDict removeAllObjects];
    self.responseString  = [NSMutableString string];
}

-(void)setPostValue:(NSString*)value forKey:(NSString*)key
{
    [self.parameterDict setValue:value forKey:key];
}

-(void)setRequestMethod:(NSString*)requestType
{
    [self.request setHTTPMethod:requestType];
}

-(NSString *)startSynchronous{
    NSArray *keys = [self.parameterDict allKeys];
    NSMutableString * contentString = [[NSMutableString alloc] initWithString:@""];
    for (int i=0;i<keys.count;i++)
    {
        if(contentString.length!=0)
            [contentString appendString:@"&"];
        [contentString appendString:keys[i]];
        [contentString appendString:@"="];
        [contentString appendString:self.parameterDict[keys[i]]];
    }
    NSData *data = [contentString dataUsingEncoding:NSUTF8StringEncoding];
    [self.request setHTTPBody:data];
    
    //同步执行Http请求，获取返回数据
    NSURLResponse *response;
    NSError *error;
    NSData *result = [NSURLConnection sendSynchronousRequest:self.request returningResponse:&response error:&error];
    
    //获取状态码和HTTP响应头信息
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSInteger statusCode = [httpResponse statusCode];
    //NSDictionary *responseHeaders = [httpResponse allHeaderFields];
    //NSString *cookie = [responseHeaders valueForKey:@"Set-Cookie"];
    
    //（如果有错误）错误描述
    NSString *errorDesc = [error localizedDescription];
    
    if (statusCode==200)
    {
        //返数据转成字符串
        NSString *resultString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        
        if (errorDesc == NULL)
        {
            NSLog(@"Result:%@\n",resultString);
            self.responseString  = resultString;
        }
    }
    else
    {
        if (errorDesc != NULL)
        {
            NSLog(@"Error:%@\n",errorDesc);
            self.responseString  = errorDesc;;
        }
    }
    return self.responseString;
}

@end
