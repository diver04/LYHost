//
//  IACPlist.m
//  IACHost
//
//  Created by 柳尧 on 2019/7/9.
//  Copyright © 2019 Diver. All rights reserved.
//

#import "IACPlist.h"
static IACPlist *plist;

@implementation IACPlist

//单例初始化
+ (IACPlist *)sharedIACPlist {
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        plist = [[IACPlist alloc]init];
        [plist getPlist];
        [plist getTestItemName];
        [plist getTest];
        [plist getTestCount];
    });
    return plist;
}

//获取整个ini.plist
- (void)getPlist{
    NSString*plistPath = [[NSBundle mainBundle] pathForResource:@"ini"ofType:@"plist"];
    plist.IAC_Dict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSDictionary *TestItemDict = [plist.IAC_Dict objectForKey:@"TESTS"];
    
    for (int i=0; i<plist.TestAmount; i++) {
        [self initTest:&testData[i]];
        NSString *item = plist.TestNameArray[i];
        NSDictionary *node = [[NSMutableDictionary alloc] initWithDictionary:[TestItemDict objectForKey:item]];
        if ([TestItemDict objectForKey:item]!=NULL) {
            [self setItemData:node toTestItemtData:&testData[i]];
        }
        else{
            NSLog(@"测试项 %@ 不存在",item);
            break;
        }
    }
}

//获取测试项名称
- (void)getTestItemName{
    plist.TestNameArray = [plist.IAC_Dict objectForKey:@"TEST_ITEM_NAME"];
}

//获取测试项
- (void)getTest{
    plist.TestItemDict = [plist.IAC_Dict objectForKey:@"TESTS"];
}

//获取测试项数量
- (void)getTestCount{
    plist.TestAmount = plist.TestNameArray.count;
}

/***************TEST***************/
-(void) initTest:(TEST*)t
{
    t->TestValue=[[NSMutableString alloc]initWithString:DEFAULT_STR];
    t->TestMessage=[[NSMutableString alloc]initWithString:DEFAULT_STR];
    t->TestDisplayMessage=[[NSMutableString alloc]initWithString:DEFAULT_STR];
    t->TestResult=[[NSMutableString alloc]initWithString:DEFAULT_STR];
    t->Name=[[NSMutableString alloc]initWithString:DEFAULT_STR];
    t->Command=[[NSMutableString alloc]initWithString:DEFAULT_STR];
    t->ValidFrom=[[NSMutableString alloc]initWithString:DEFAULT_STR];
    t->unit=[[NSMutableString alloc]initWithString:DEFAULT_STR];
    t->isWaive=FALSE;
    t->isWaivePass=FALSE;
    t->isSkip=FALSE;
    t->isPass=FALSE;
    t->isTimeout=FALSE;
    t->isNoLimit=FALSE;
    t->Maximum=DEFAULT_VAL;
    t->Maximum_W=DEFAULT_VAL;
    t->Minimum=DEFAULT_VAL;
    t->Minimum_W=DEFAULT_VAL;
    t->Min=[[NSMutableString alloc]initWithString:DEFAULT_STR];
    t->Max=[[NSMutableString alloc]initWithString:DEFAULT_STR];
}

-(TEST*)getItemWithIndex:(int)index
{
    return &testData[index];
}

-(void)setItemData:(NSDictionary*)node toTestItemtData:(TEST*)testItemData
{
    TEST *t=testItemData;
    
    t->isWaive=[[node objectForKey:INI_ITEM_KEY_WAIVE] boolValue];
    t->isSkip=[[node objectForKey:INI_ITEM_KEY_SKIP] boolValue];
    
    if ([node objectForKey:INI_ITEM_KEY_NAME]!=NULL)
        [t->Name setString:[node objectForKey:INI_ITEM_KEY_NAME]];
    if ([node objectForKey:INI_ITEM_KEY_CMD]!=NULL)
        [t->Command setString:[node objectForKey:INI_ITEM_KEY_CMD]];
    if ([node objectForKey:INI_ITEM_KEY_VF]!=NULL)
        [t->ValidFrom setString:[node objectForKey:INI_ITEM_KEY_VF]];
    if ([node objectForKey:INI_ITEM_KEY_UNIT]!=NULL)
        [t->unit setString:[node objectForKey:INI_ITEM_KEY_UNIT]];
    
    t->Minimum=[[node objectForKey:INI_ITEM_KEY_MIN]doubleValue];
    t->Maximum=[[node objectForKey:INI_ITEM_KEY_MAX]doubleValue];
    t->Minimum_W=[[node objectForKey:INI_ITEM_KEY_WAIVE_MIN]doubleValue];
    t->Maximum_W=[[node objectForKey:INI_ITEM_KEY_WAIVE_MAX]doubleValue];
    
    NSString *minStr=[self isInt:t->Minimum]?[NSString stringWithFormat:@"%d",(int)t->Minimum]:[NSString stringWithFormat:@"%f",t->Minimum];
    NSString *maxStr=[self isInt:t->Maximum]?[NSString stringWithFormat:@"%d",(int)t->Maximum]:[NSString stringWithFormat:@"%f",t->Maximum];
    
    if ([node objectForKey:INI_ITEM_KEY_MIN]!=NULL)
        [t->Min setString:minStr];
    if ([node objectForKey:INI_ITEM_KEY_MAX]!=NULL)
        [t->Max setString:maxStr];
    if ([node objectForKey:INI_ITEM_KEY_MIN]==NULL && [node objectForKey:INI_ITEM_KEY_MAX]==NULL)
        t->isNoLimit=true;
}

-(bool)isInt:(double)val
{
    return ((int)val == val)?true:false;
}

-(BOOL)checkIsAllPass{
    BOOL isAllPass=TRUE;
    for(int i=0; i<plist.TestAmount; i++)
    {
        if (!testData[i].isPass)
        {
            isAllPass=FALSE;
            break;
        }
    }
    return isAllPass;
}
@end
