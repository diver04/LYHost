//
//  IACTestItem.m
//  IACHost
//
//  Created by 柳尧 on 2019/7/9.
//  Copyright © 2019 Diver. All rights reserved.
//

#import "IACTestItem.h"

@implementation IACTestItem
-(id)init
{
    if(self=[super init])
    {
        self.Name = @"NA";
        self.Command = @"NA";
        self.ValidFrom = @"NA";
        self.unit = @"NA";
        self.min = 0;
        self.max = 0;
        self.isSkip = NO;
    }
    return self;
}
@end
