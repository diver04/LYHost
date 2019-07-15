//
//  IACRequest.h
//  IACHost
//
//  Created by 柳尧 on 2019/6/27.
//  Copyright © 2019 Diver. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IACRequest : NSObject

@property NSMutableURLRequest *request;
@property NSMutableDictionary *parameterDict;
@property NSString *responseString;

-(void)requestWithURL:(NSURL*)urlStr;
-(void)setRequestMethod:(NSString*)requestType;
-(void)setPostValue:(NSString*)value forKey:(NSString*)key;
-(NSString *)startSynchronous;
@end



NS_ASSUME_NONNULL_END
