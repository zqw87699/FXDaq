//
//  FXExceptionHttpAPI.h
//  Test
//
//  Created by 张大宗 on 2017/10/13.
//  Copyright © 2017年 张大宗. All rights reserved.
//

#import <FXCommon/FXCommon.h>
#import "BaseFXHttpRequest.h"
#import "BaseFXHttpResponse.h"

@interface FXExceptionHttpRequest : BaseFXHttpRequest

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSDictionary *params;

@property (nonatomic, copy) NSDictionary *uploadFiles;

@end

@interface FXExceptionHttpResponse : BaseFXHttpResponse

@end
