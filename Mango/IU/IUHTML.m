//
//  IUHTML.m
//  Mango
//
//  Created by JD on 13. 7. 5..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUHTML.h"
#import "IUWebView.h"


@implementation IUHTML

+(NSArray*)propertyList{
    return @[@"source"];
}

-(id)instantiate{
    [super instantiate];
    self.source = @"<div>Input Source</div>";
    return self;
}

-(IBAction)stopLoading{
    NSLog(@"stopLoading");
}

-(void)sampleImageDidChange{
    NSString* sampleImgPath = [[self.iuManager.pWC.project absoluteResDirPath] stringByAppendingPathComponent:self.sampleImage];
    NSImage *img = [[NSImage alloc] initWithContentsOfFile:sampleImgPath];
    if (img) {
        self.bg.img = sampleImgPath;
        
    }
}
-(void)setSource:(NSString *)source{
    _source = source;
    [self setNeedsDisplay:IUNeedsDisplayActionHTML];
}

-(NSString*)innerHTML2:(id)caller{
    return self.source;
}

-(NSString*)innerOutputHTML2{
    return self.source;
}



-(void)loadWithDict:(NSDictionary *)dict{
    [super loadWithDict:dict];
    [self importPropertyFromDict:[dict objectForKey:@"IUHTML"] ofClass:[IUHTML class]];
}

-(NSString*)localHTMLSource{
    return self.source;
}

-(NSMutableDictionary*)dict{
    NSMutableDictionary *dict = [super dict];
    [dict setObject:[self exportPropertyFromDictOfClass:[IUHTML class]] forKey:@"IUHTML"];
    return dict;
}

@end