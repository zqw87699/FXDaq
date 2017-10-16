//
//  FXExceptionHttpAPI.m
//  Test
//
//  Created by 张大宗 on 2017/10/13.
//  Copyright © 2017年 张大宗. All rights reserved.
//

#import "FXExceptionHttpAPI.h"

@implementation FXExceptionHttpRequest

-(NSString*) getURL {
    return self.url;
}

-(BOOL) validateParams {
    return YES;
}

-(NSDictionary*) getParams {
    return self.params;
}

-(NSDictionary*) getUploadFiles {
    return self.uploadFiles;
}

@end

@implementation FXExceptionHttpResponse

@end
