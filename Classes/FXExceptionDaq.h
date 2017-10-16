//
//  FXExceptionDaq.h
//  Test
//
//  Created by 张大宗 on 2017/10/13.
//  Copyright © 2017年 张大宗. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXSingleton.h"
#import "IFXLaunchProtocol.h"

@interface FXExceptionDaq : NSObject<IFXLaunchProtocol>

AS_SINGLETON(FXExceptionDaq)

/*
 *  设置崩溃日志收集地址
 *  url:接口地址
 *  params:接口参数
 */
- (void)registerDaqUrl:(NSString *)url Params:(NSDictionary *)params;

/*
 *  手动上传崩溃日志
 */
- (void)uploadExceptionFile;

/*
 *  清除崩溃日志
 */
- (BOOL)clearExceptionFile;

@end
