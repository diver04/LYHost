//
//  AppDelegate.m
//  IACHost
//
//  Created by 柳尧 on 2019/6/27.
//  Copyright © 2019 Diver. All rights reserved.
//

#import "AppDelegate.h"
#import "IACRequest.h"
@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
 
}

- (void)test1{
    //1.创建NSURLSession对象（可以获取单例对象）
    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionConfiguration
    
    //2.根据NSURLSession对象创建一个Task
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.28:12345?resultIndex=1&lower_limit=NA&upper_limit=NA&units=NA&displayMsg=NA&testResult=FAIL&errorMsg=NA&value=NA"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //方法参数说明
    /*
     注意：该block是在子线程中调用的，如果拿到数据之后要做一些UI刷新操作，那么需要回到主线程刷新
     第一个参数：需要发送的请求对象
     block:当请求结束拿到服务器响应的数据时调用block
     block-NSData:该请求的响应体
     block-NSURLResponse:存放本次请求的响应信息，响应头，真实类型为NSHTTPURLResponse
     block-NSErroe:请求错误信息
     */
    NSURLSessionDataTask * dataTask =  [session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        
        //拿到响应头信息
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        
        //4.解析拿到的响应数据
        NSLog(@"%@\n%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding],res.allHeaderFields);
    }];
    
    //3.执行Task
    //注意：刚创建出来的task默认是挂起状态的，需要调用该方法来启动任务（执行任务）
    [dataTask resume];
}

- (void)test2{
    //1.创建NSURLSession对象（可以获取单例对象）
    NSURLSession *session = [NSURLSession sharedSession];
    
    //2.根据NSURLSession对象创建一个Task
//    NSURL *url = [NSURL URLWithString:@"http://psd1926.iacp.iac/MAYBobcat/Home/B235"];
//    NSURL *url = [NSURL URLWithString:@"http://10.0.1.9:8887/demo1"];
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.28:12345"];
    //创建一个请求对象，并这是请求方法为POST，把参数放在请求体中传递
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
//    request.HTTPBody = [@"c=SS_PRECHECK&sn=FXWYLZXTLX2Y&accessory_1=FXWYMBG0JJNV&accessory_2=FWYYN14UJJNW&accessory_3=FXWYLZXTLX2Y&station_id=IACP_P03-3FCRT-01_6_SHIPPING-SETTINGS" dataUsingEncoding:NSUTF8StringEncoding];
//    request.HTTPBody = [@"TestFunc=1" dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = [@"TestFunc=1" dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        //拿到响应头信息
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        //解析拿到的响应数据
        NSLog(@"%@\n%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding],res.allHeaderFields);
    }];
    
    //3.执行Task
    //注意：刚创建出来的task默认是挂起状态的，需要调用该方法来启动任务（执行任务）
    [dataTask resume];
}

-(void)test3 {
    // 1.创建url  采用Apache本地服务器
    NSString *urlString = @"http://localhost/upload.php";
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 2.创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 文件上传使用post
    request.HTTPMethod = @"POST";
    
    // 3.开始上传   request的body data将被忽略，而由fromData提供
    [[[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:[NSData dataWithContentsOfFile:@"/Users/userName/Desktop/IMG_0359.jpg"]     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"upload success：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } else {
            NSLog(@"upload error:%@",error);
        }
    }] resume];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
