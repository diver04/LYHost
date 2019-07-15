//
//  IACUI.m
//  IACHost
//
//  Created by 柳尧 on 2019/6/27.
//  Copyright © 2019 Diver. All rights reserved.
//

#import "IACUI.h"
#import "IACPlist.h"
#import "IACTestItem.h"
#import "IACFunction.h"

@implementation IACUI

- (IBAction)clickStartTest:(id)sender {
    NSLog(@"开始测试");
    int dutNum=[[sender identifier] intValue];//1
    NSString *identifier = [sender identifier];//@"1"
    [self doExecuteWithDUT:dutNum senderIdentifier:identifier];
}

#pragma mark --针对多线程进行测试
-(void)doExecuteWithDUT:(int)dutNum senderIdentifier:(NSString*)identifier{
    NSArray *argumentArr = [NSArray arrayWithObjects:identifier,self.SN_TextField.stringValue, nil];
    [self performSelectorInBackground:@selector(executTest:) withObject:argumentArr];
    
}

#pragma mark --开始测试
-(void)executTest:(NSArray*)argument{
    NSString *caseSN = argument[1];
    [self performSelectorOnMainThread:@selector(setTestingStatus:) withObject:argument[0] waitUntilDone:YES];
    IACPlist *plist = [IACPlist sharedIACPlist];
    IACFunction *fun = [[IACFunction alloc] init];
    for (int i = 0; i<plist.TestAmount; i++) {
        NSString*itemName = plist.TestNameArray[i];
        NSDictionary *testItems = plist.TestItemDict;
        NSDictionary *aTestItem= [testItems objectForKey:itemName];
        NSLog(@"aTestItem--%@",aTestItem);
        NSArray*args=[NSArray arrayWithObjects:itemName,[aTestItem valueForKey:@"ValidFrom"],[aTestItem valueForKey:@"min"],[aTestItem valueForKey:@"max"],[aTestItem valueForKey:@"unit"],caseSN,nil];
        BOOL isSkip = [[aTestItem objectForKey:@"skip"] boolValue];
        if (!isSkip) {
            if ([fun respondsToSelector:NSSelectorFromString([NSString stringWithFormat:@"%@:",itemName])]) {
                 [fun performSelector:NSSelectorFromString([NSString stringWithFormat:@"%@:",itemName]) withObject:args];
            }
        }
        //保存测试结果
        TEST *item=[plist getItemWithIndex:i];
        if (!item->isSkip) {
            
        }
    }
    [self performSelectorOnMainThread:@selector(testEnd:) withObject:argument waitUntilDone:YES];
}

#pragma mark--设置测试的UI界面显示
-(void)setTestingStatus:(NSNumber*)dutNum
{
    self.SN_TextField.stringValue = @"Testing";
    self.UIWindow.backgroundColor = [NSColor yellowColor];
}

//测试结束
-(void)testEnd:(NSArray*)argument
{
    [self performSelectorOnMainThread:@selector(showTheTestResultOnUI:) withObject:[argument objectAtIndex:0] waitUntilDone:YES];
}

-(void)showTheTestResultOnUI1:(NSNumber*)dutNum{
    
}
@end
