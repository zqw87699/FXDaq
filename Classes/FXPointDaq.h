//
//  FXPointDaq.h
//  Test
//
//  Created by 张大宗 on 2017/10/17.
//  Copyright © 2017年 张大宗. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXSingleton.h"
#import "IFXLaunchProtocol.h"

@interface FXPointDaq : NSObject<IFXLaunchProtocol>

AS_SINGLETON(FXExceptionDaq)

/*
 *  设置埋点日志收集地址
 *  url:接口地址
 *  params:接口参数
 *  interval:发送间隔（单位：s）  0表示启动时发送  默认间隔：10s
 */
- (void)registerDaqUrl:(NSString *)url Params:(NSDictionary *)params SendInterval:(NSInteger)interval;

/*
 *  手动上传埋点日志
 */
- (void)uploadPointFile;

/*
 *  清除埋点日志
 */
- (BOOL)clearPointFile;

/*
 *  保存埋点日志
 */
+ (void)saveDaq:(NSString*)pointName Action:(NSString*)action;

@end
