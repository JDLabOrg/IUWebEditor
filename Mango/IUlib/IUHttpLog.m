//
//  IUHttpLog.m
//  Mango
//
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

#import "IUHttpLog.h"

@implementation IUHttpLog

+(void)sendHTTPLog:(NSString *)path post:(NSDictionary*) post{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void){
        NSURL *url = [NSURL URLWithString:path];
        NSMutableString *dataStr = [NSMutableString string];
        for (NSString *key in post) {
            [dataStr appendFormat:@"%@=%@&", key, [post objectForKey:key]];
        }
        [dataStr stringByTrimEndWithChar:'&'];
        
        NSData *data=[dataStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%ld", [data length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:data];
        NSURLResponse *response;
        NSError *error;
        //NSData *responseData=
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
       
        if (error!=nil) {
            NSLog(@"%s send http error", __func__);
        }
        
    });
}


+(void)sendNewUserLog{
    NSDictionary *dict = @{@"iu_check": @"insert"};
    NSString *path = [NSString stringWithFormat:@"http://iu.jdlab.org/iuuser/add/"];
    [self sendHTTPLog:path post:dict];
}


+(void)sendNewIUObjLog:(NSString*)IUType{
    NSDictionary *dict = @{@"iu_check": @"insert"};
    NSString *path = [NSString stringWithFormat:@"http://iu.jdlab.org/iuobj/%@/add/", IUType];
    [self sendHTTPLog:path post:dict];
}

+(void)sendRunLog{
    NSDictionary *dict = @{@"iu_check": @"insert"};
    NSString *path = [NSString stringWithFormat:@"http://iu.jdlab.org/iurun/add/"];
    [self sendHTTPLog:path post:dict];
}
+(void)sendNewProjectLog:(NSString*)projectType cloudType:(NSString*)cloudType git:(NSString*)gitType{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"iu_check" forKey:@"insert"];
    [dict setObjectRemoveNil:projectType forKey:@"project_type"];
    [dict setObjectRemoveNil:cloudType forKey:@"cloud_type"];
    [dict setObjectRemoveNil:gitType forKey:@"git_type"];

    NSString *path = [NSString stringWithFormat:@"http://iu.jdlab.org/iuproject/add/"];
    [self sendHTTPLog:path post:dict];
}
+(void)sendMail:(NSString*)emailAddr message:(NSString*)message{
    if ([emailAddr length] ==0 || [message length] == 0) {
        return;
    }
    NSDictionary *dict = @{@"iu_check": @"insert", @"email": emailAddr, @"msg":message };
    NSString *path = [NSString stringWithFormat:@"http://iu.jdlab.org/iuopinion"];
    [self sendHTTPLog:path post:dict];
}

                   
@end
