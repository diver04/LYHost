//
//  IACRequest.m
//  IACHost
//
//  Created by 柳尧 on 2019/6/27.
//  Copyright © 2019 Diver. All rights reserved.
//

#import "IACRequest.h"
#define URL @"http://192.168.1.28:12345"
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

- (NSString *)requestDataWithCommand:(NSString *)aCommand{
    //1.创建NSURLSession对象（可以获取单例对象）
    NSURLSession *session = [NSURLSession sharedSession];
    
    //2.根据NSURLSession对象创建一个Task
    //    NSURL *url = [NSURL URLWithString:@"http://psd1926.iacp.iac/MAYBobcat/Home/B235"];
    //    NSURL *url = [NSURL URLWithString:@"http://10.0.1.9:8887/demo1"];
//    NSURL *url = [NSURL URLWithString:@"http://192.168.1.28:12345"];
    NSURL *url = [NSURL URLWithString:URL];
    //创建一个请求对象，并这是请求方法为POST，把参数放在请求体中传递
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    //    request.HTTPBody = [@"c=SS_PRECHECK&sn=FXWYLZXTLX2Y&accessory_1=FXWYMBG0JJNV&accessory_2=FWYYN14UJJNW&accessory_3=FXWYLZXTLX2Y&station_id=IACP_P03-3FCRT-01_6_SHIPPING-SETTINGS" dataUsingEncoding:NSUTF8StringEncoding];
    //    request.HTTPBody = [@"TestFunc=1" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *command = [NSString stringWithFormat:@"Command=%@",aCommand];
    request.HTTPBody = [command dataUsingEncoding:NSUTF8StringEncoding];
    
    __block NSString *receiveStr = [NSString string];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        //拿到响应头信息
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        //解析拿到的响应数据
        receiveStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@\n%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding],res.allHeaderFields);
        
    }];
    
    //3.执行Task
    //注意：刚创建出来的task默认是挂起状态的，需要调用该方法来启动任务（执行任务）
    [dataTask resume];
    
    return receiveStr;
}

/***********************我是分割符************************/
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
