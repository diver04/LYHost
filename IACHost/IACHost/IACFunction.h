//
//  IACFunction.h
//  IACHost
//
//  Created by 柳尧 on 2019/6/27.
//  Copyright © 2019 Diver. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IACFunction : NSObject

@property(copy,nonatomic)NSMutableString *testValue;
@property(copy,nonatomic)NSMutableString *testMessage;
@property(copy,nonatomic)NSMutableString *testDisplayMessage;
@property Boolean isPass;
@property Boolean isTimeout;
@property Boolean skipBelowTest;
@property Boolean isStartPudding;

@end

NS_ASSUME_NONNULL_END
