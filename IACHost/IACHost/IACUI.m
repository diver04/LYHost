//
//  IACUI.m
//  IACHost
//
//  Created by 柳尧 on 2019/6/27.
//  Copyright © 2019 Diver. All rights reserved.
//

#import "IACUI.h"

@implementation IACUI

- (IBAction)clickStartTest:(id)sender {
    NSLog(@"开始测试");
    int dutNum=[[sender identifier] intValue];//1
    NSString *identifier = [sender identifier];//@"1"
    [self doExecuteWithDUT:dutNum senderIdentifier:identifier];
}

#pragma mark --针对多线程进行测试
-(void)doExecuteWithDUT:(int)dutNum senderIdentifier:(NSString*)identifier{
    NSArray *argument = [NSArray arrayWithObjects:identifier,self.SN_TextField.stringValue, nil];
    [self performSelectorInBackground:@selector(executTest:) withObject:argument];
    
}

#pragma mark --开始测试
-(void)executTest:(NSArray*)argument{
    NSString *caseSN = argument[1];
    [self performSelectorOnMainThread:@selector(setTestingStatus:) withObject:argument[0] waitUntilDone:YES];
    plist = [IACPlist sharedIACPlist];
    IACFunction *fun = [[IACFunction alloc] init];
    for (int i = 0; i<plist.TestAmount; i++) {
        NSString*itemName = plist.TestNameArray[i];//
        NSLog(@"测试项名称为：%@",itemName);
        NSDictionary *aTestItem= [plist.TestItemDict objectForKey:itemName];//TESTS里的一个Item
        NSLog(@"aTestItem--%@",aTestItem);
    
        NSArray*args=@[itemName,caseSN];
        BOOL isSkip = [[aTestItem objectForKey:@"skip"] boolValue];
        if (!isSkip) {
            if ([fun respondsToSelector:NSSelectorFromString([NSString stringWithFormat:@"%@:",itemName])]) {
                 [fun performSelector:NSSelectorFromString([NSString stringWithFormat:@"%@:",itemName]) withObject:args];
            }else{
                NSLog(@"没有找到%@",itemName);
            }
        }
        //保存测试结果
        TEST *item=[plist getItemWithIndex:i];
        if (!item->isSkip) {
            item->TestValue = fun.testValue;
            item->TestDisplayMessage = fun.testDisplayMessage;
            item->TestMessage = fun.testMessage;
            item->isPass = fun.isPass;
            item->isTimeout = fun.isTimeout;
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

-(void)showTheTestResultOnUI:(NSNumber*)dutNum{
    if ([plist checkIsAllPass]) {
        self.SN_TextField.stringValue = @"Pass";
        self.UIWindow.backgroundColor = [NSColor greenColor];
    }
    else{
        self.SN_TextField.stringValue = @"Fail";
        self.UIWindow.backgroundColor = [NSColor redColor];
    }
}

#pragma mark--TableView处理
-(void)updateData:(NSNumber *)index
{
    [self.MyTableView reloadData];
    [self.MyTableView scrollRowToVisible:index.integerValue];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return 1;
}


@end
