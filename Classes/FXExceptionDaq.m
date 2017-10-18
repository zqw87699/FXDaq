//
//  FXExceptionDaq.m
//  Test
//
//  Created by 张大宗 on 2017/10/13.
//  Copyright © 2017年 张大宗. All rights reserved.
//

#import "FXExceptionDaq.h"
#import "AFFXHttpEngine.h"
#import "FXExceptionHttpAPI.h"
#import "FXUtils.h"

@interface FXExceptionDaq()

@property (nonatomic, copy) NSString *exceptionUrl;

@property (nonatomic, copy) NSDictionary *params;

@property (nonatomic, strong) AFFXHttpEngine *httpEngine;

@end

@implementation FXExceptionDaq

DEF_SINGLETON_INIT(FXExceptionDaq)

- (void)singleInit{
    self.httpEngine = [[AFFXHttpEngine alloc] init];
}

- (void)registerDaqUrl:(NSString *)url Params:(NSDictionary *)params{
    if (self.exceptionUrl){
        if ([FXFileUtils existFile:[FXExceptionDaq exceptionFilePath]]){
            [self uploadExceptionFile];
        }
        self.exceptionUrl = url;
        self.params = params;
    }else{
        self.exceptionUrl = url;
        self.params = params;
        if ([FXFileUtils existFile:[FXExceptionDaq exceptionFilePath]]){
            [self uploadExceptionFile];
        }
    }
}

- (void)uploadExceptionFile{
    FX_WEAK_REF_TYPE selfObject = self;
    if (![self.httpEngine hasLoading] && FX_STRING_IS_NOT_EMPTY(self.exceptionUrl)){
        FXExceptionHttpRequest *requset = [[FXExceptionHttpRequest alloc] init];
        [requset setUrl:self.exceptionUrl];
        [requset setParams:self.params];
        [requset setUploadFiles:@{@"FXException":[FXExceptionDaq exceptionFilePath]}];
        [self.httpEngine asynRequest:requset responseClass:[FXExceptionHttpResponse class] responseBlock:^(id<IFXHttpResponse> res, NSError *error) {
            if (error){
                FXLogError(@"上传崩溃日志失败:%@",error.userInfo[NSLocalizedDescriptionKey]);
                [selfObject resaveExceptionWithParams];
            }else{
                if ([res isError]){
                    FXLogError(@"上传崩溃日志失败:%@",[res errorMsg]);
                    [selfObject resaveExceptionWithParams];
                }else{
                    FXLogInfo(@"上传崩溃日志成功");
                    [selfObject clearExceptionFile];
                }
            }
        }];
    }
}

- (BOOL)clearExceptionFile{
    return [FXFileUtils deleteFile:[FXExceptionDaq exceptionFilePath]];
}

- (void)resaveExceptionWithParams{
    NSArray *currentExcep = [[NSArray alloc] initWithContentsOfFile:[FXExceptionDaq exceptionFilePath]];
    NSMutableArray *newExcep = [currentExcep mutableCopy];
    for (int i=0;i<currentExcep.count;i++){
        NSMutableDictionary *newDict = [currentExcep[i] mutableCopy];
        if (![newDict objectForKey:@"Params"]){
            [newDict setObject:self.params forKey:@"Params"];
        }
        [newExcep addObject:newDict];
    }
    [newExcep writeToFile:[FXExceptionDaq exceptionFilePath] atomically:YES];
}

- (void)appDidLaunchWithOptions:(NSDictionary *)options{
    NSSetUncaughtExceptionHandler(&fxUncaughtExceptionHandler);
}

static void fxUncaughtExceptionHandler (NSException *exception) {
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[@"CallStackSymbols"] = [exception callStackSymbols]; //调用栈信息
    info[@"Name"] = [exception name];                         //报错名称
    info[@"Reason"] = [exception reason];                     //报错名称

    NSMutableArray *currentExcep = [[NSMutableArray alloc] initWithContentsOfFile:[FXExceptionDaq exceptionFilePath]];
    if (!currentExcep){
        currentExcep = [[NSMutableArray alloc] init];
    }
    [currentExcep addObject:info];
    [currentExcep writeToFile:[FXExceptionDaq exceptionFilePath] atomically:YES];
}

+ (NSString*)exceptionFilePath{
    return [[FXFileUtils documentDir] stringByAppendingString:@"/FXException.txt"];
}

@end
