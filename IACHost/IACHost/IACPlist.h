//
//  IACPlist.h
//  IACHost
//
//  Created by 柳尧 on 2019/7/9.
//  Copyright © 2019 Diver. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
#define INI_ITEM_KEY_NAME @"name"
#define INI_ITEM_KEY_CMD @"command"
#define INI_ITEM_KEY_VF @"validator"
#define INI_ITEM_KEY_UNIT @"unit"
#define INI_ITEM_KEY_SKIP @"skip"
#define INI_ITEM_KEY_WAIVE @"waive"
#define INI_ITEM_KEY_MAX @"max"
#define INI_ITEM_KEY_MIN @"min"
#define INI_ITEM_KEY_WAIVE_MAX @"max_w"
#define INI_ITEM_KEY_WAIVE_MIN @"min_w"

#define DEFAULT_STR @"NA"
#define DEFAULT_VAL 0
#define MAX_TESTS_SIZE 4096

typedef struct
{
    Boolean isSkip;
    Boolean isWaive;
    NSMutableString *Name;
    NSMutableString *Command;
    NSMutableString *ValidFrom;
    double Minimum;
    double Maximum;
    double Minimum_W;
    double Maximum_W;
    NSMutableString *Min;
    NSMutableString *Max;
    NSMutableString *unit;
    
    NSMutableString *TestValue;//for InstantPudding value
    NSMutableString *TestDisplayMessage; //for UI display
    NSMutableString *TestMessage; //for InstantPudding message
    NSMutableString *TestResult;
    Boolean isPass;
    Boolean isWaivePass;
    Boolean isTimeout;
    Boolean isNoLimit;
} TEST;

@interface IACPlist : NSObject
{
    TEST testData[MAX_TESTS_SIZE];//用于保存测试项的结果
}
+ (IACPlist *)sharedIACPlist;
-(TEST*)getItemWithIndex:(int)index;

@property (nonatomic) NSMutableDictionary *IAC_Dict;
@property (nonatomic) NSUInteger TestAmount;
@property (nonatomic) NSArray *TestNameArray;
@property (nonatomic) NSDictionary *TestItemDict;

@end

NS_ASSUME_NONNULL_END
