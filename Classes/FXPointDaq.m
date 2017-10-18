//
//  FXPointDaq.m
//  Test
//
//  Created by 张大宗 on 2017/10/17.
//  Copyright © 2017年 张大宗. All rights reserved.
//

#import "FXPointDaq.h"
#import "AFFXHttpEngine.h"
#import "FXPointAPI.h"
#import "FXUtils.h"

@interface FXPointDaq()

@property (nonatomic, assign) NSInteger interval;

@property (nonatomic, assign) NSInteger currentDown;

@property (nonatomic, strong) AFFXHttpEngine *httpEngine;

@property (nonatomic, copy) NSString *pointUrl;

@property (nonatomic, copy) NSDictionary *params;

@property (nonatomic, strong) NSTimer *timer;

@end


@implementation FXPointDaq

DEF_SINGLETON_INIT(FXPointDaq)

- (void)singleInit{
    self.httpEngine = [[AFFXHttpEngine alloc] init];
    self.interval = 10;
    self.currentDown = 10;
}

- (void)uploadPointFile{
    FX_WEAK_REF_TYPE selfObject = self;
    if (![self.httpEngine hasLoading] && FX_STRING_IS_NOT_EMPTY(self.pointUrl) && [FXFileUtils existFile:[FXPointDaq pointFilePath]]){
        FXPointRequest *requset = [[FXPointRequest alloc] init];
        [requset setUrl:self.pointUrl];
        [requset setParams:self.params];
        [requset setUploadFiles:@{@"FXPoint":[FXPointDaq pointFilePath]}];
        [self.httpEngine asynRequest:requset responseClass:[FXPointResponse class] responseBlock:^(id<IFXHttpResponse> res, NSError *error) {
            if (error){
                FXLogError(@"上传埋点日志失败:%@",error.userInfo[NSLocalizedDescriptionKey]);
                [selfObject resavePointWithParams];
            }else{
                if ([res isError]){
                    FXLogError(@"上传埋点日志失败:%@",[res errorMsg]);
                    [selfObject resavePointWithParams];
                }else{
                    FXLogInfo(@"上传埋点日志成功");
                    [selfObject clearPointFile];
                }
            }
            selfObject.currentDown = selfObject.interval;
        }];
    }
}

- (void)appDidLaunchWithOptions:(NSDictionary *)options{
    
}

- (void)registerDaqUrl:(NSString *)url Params:(NSDictionary *)params SendInterval:(NSInteger)interval{
    if (self.pointUrl){
        if ([FXFileUtils existFile:[FXPointDaq pointFilePath]]){
            [self uploadPointFile];
        }
        self.pointUrl = url;
        self.params = params;
        self.interval = interval;
        self.currentDown = interval;
    }else{
        self.pointUrl = url;
        self.params = params;
        self.interval = interval;
        self.currentDown = interval;
        if ([FXFileUtils existFile:[FXPointDaq pointFilePath]]){
            [self uploadPointFile];
        }
    }
    
    if ([self.timer isValid]){
        [self.timer invalidate];
        self.timer = nil;
    }
    if (interval != 0){
        FX_WEAK_REF_TYPE selfObject = self;
        selfObject.timer = [NSTimer timerWithTimeInterval:1.0f repeats:YES block:^(NSTimer * _Nonnull timer) {
            if (selfObject.interval != 0){
                if (selfObject.currentDown <= 0){
                    [selfObject uploadPointFile];
                }else{
                    selfObject.currentDown -= 1;
                }
            }
        }];
        [[NSRunLoop currentRunLoop] addTimer:selfObject.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)resavePointWithParams{
    NSArray *currentExcep = [[NSArray alloc] initWithContentsOfFile:[FXPointDaq pointFilePath]];
    NSMutableArray *newExcep = [currentExcep mutableCopy];
    for (int i=0;i<currentExcep.count;i++){
        NSMutableDictionary *newDict = [currentExcep[i] mutableCopy];
        if (![newDict objectForKey:@"Params"]){
            [newDict setObject:self.params forKey:@"Params"];
        }
        [newExcep addObject:newDict];
    }
    [newExcep writeToFile:[FXPointDaq pointFilePath] atomically:YES];
}

- (BOOL)clearPointFile{
    return [FXFileUtils deleteFile:[FXPointDaq pointFilePath]];
}

+ (NSString*)pointFilePath{
    return [[FXFileUtils documentDir] stringByAppendingString:@"/FXPoint.txt"];
}

+ (void)saveDaq:(NSString *)pointName Action:(NSString *)action{
    if (!pointName) {
        return;
    }
    if (!action) {
        action = [FXDateUtils currentSystemDate];
    }
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[@"PointName"] = pointName;
    info[@"Action"] = action;
    info[@"Time"] = [FXDateUtils currentSystemDate];
    
    NSMutableArray *currentExcep = [[NSMutableArray alloc] initWithContentsOfFile:[self pointFilePath]];
    if (!currentExcep){
        currentExcep = [[NSMutableArray alloc] init];
    }
    [currentExcep addObject:info];
    [currentExcep writeToFile:[self pointFilePath] atomically:YES];
}

@end
