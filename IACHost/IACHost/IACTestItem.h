//
//  IACTestItem.h
//  IACHost
//
//  Created by 柳尧 on 2019/7/9.
//  Copyright © 2019 Diver. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IACTestItem : NSObject

@property (copy,nonatomic)NSString *Name;
@property (copy,nonatomic)NSString *Command;
@property (copy,nonatomic)NSString *ValidFrom;
@property (copy,nonatomic)NSString *unit;
@property int min;
@property int max;
@property BOOL isSkip;

@end

NS_ASSUME_NONNULL_END
