//
//  IACUI.h
//  IACHost
//
//  Created by 柳尧 on 2019/6/27.
//  Copyright © 2019 Diver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface IACUI : NSObject
@property (weak) IBOutlet NSTextField  *SN_TextField;
@property (weak) IBOutlet NSWindow *UIWindow;
@end

NS_ASSUME_NONNULL_END
