//
//  IACFunction.h
//  IACHost
//
//  Created by 柳尧 on 2019/6/27.
//  Copyright © 2019 Diver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IACRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface IACFunction : NSObject

@property IACRequest *request;
@property(copy,nonatomic)NSString *testValue;
@property(copy,nonatomic)NSString *testMessage;
@property(copy,nonatomic)NSString *testDisplayMessage;
@property Boolean isPass;
@property Boolean isTimeout;
@property Boolean isStartPudding;

@property Boolean skipBelowTest;

@end

NS_ASSUME_NONNULL_END
