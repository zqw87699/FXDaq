//
//  FXPointAPI.m
//  Test
//
//  Created by 张大宗 on 2017/10/17.
//  Copyright © 2017年 张大宗. All rights reserved.
//

#import "FXPointAPI.h"

@implementation FXPointRequest

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

@implementation FXPointResponse

@end
