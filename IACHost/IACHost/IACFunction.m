//
//  IACFunction.m
//  IACHost
//
//  Created by 柳尧 on 2019/6/27.
//  Copyright © 2019 Diver. All rights reserved.
//

#import "IACFunction.h"

#define init_before_test \
self.testValue = @"0";\
self.testMessage = @"NA";\
self.testDisplayMessage = @"NA";\
self.isPass = FALSE;\
self.isTimeout = FALSE;\
if (self.skipBelowTest)\
{\
self.testDisplayMessage = @"skiped";\
self.isPass=true;\
return;\
}\

@implementation IACFunction

-(id)init
{
    if(self=[super init])
    {
        self.request = [[IACRequest alloc] init];
    }
    return self;
}

-(void)CheckPudding:(NSMutableArray *)args{
    init_before_test
    NSString *str = [self.request requestDataWithCommand:@"SR1"];
    NSLog(@"Response1:\n %@",str);
    self.isPass = YES;
    if (!self.isPass) {
        self.skipBelowTest = YES;
    }
}

-(void)CheckBatman_Case:(NSMutableArray *)args{
    init_before_test
    NSString *str = [self.request requestDataWithCommand:@"SR1"];
    NSLog(@"Response2:\n %@",str);
    self.isPass = YES;
}

-(void)finishWorkHandler:(NSMutableArray *)args{
    init_before_test
    NSString *str = [self.request requestDataWithCommand:@"SR1"];
    NSLog(@"Response3:\n %@",str);
    self.isPass = YES;
}

@end
